{ucs2} = require 'punycode'

CodepointPropertyReader = require '../../src/unicode/CodepointPropertyReader'
DirectionalityValidator = require '../../src/unicode/DirectionalityValidator'
EmptyStringError = require '../../src/error/EmptyStringError'
InvalidCodepointError = require '../../src/error/InvalidCodepointError'
InvalidDirectionalityError = require '../../src/error/InvalidDirectionalityError'
NicknameProfile = require '../../src/profile/NicknameProfile'
OpaqueStringProfile = require '../../src/profile/OpaqueStringProfile'
Precis = require '../../src/enforce'
PrecisEnforcer = require '../../src/PrecisEnforcer'
PrecisPreparer = require '../../src/PrecisPreparer'
UsernameCaseMappedProfile = require '../../src/profile/UsernameCaseMappedProfile'
UsernameCasePreservedProfile = require '../../src/profile/UsernameCasePreservedProfile'
WidthMapper = require '../../src/unicode/WidthMapper'

describe 'Precis', ->

    it 'produces the correct exports', ->
        assert.instanceOf Precis.enforcer, PrecisEnforcer
        assert.instanceOf Precis.preparer, PrecisPreparer
        assert.instanceOf Precis.propertyReader, CodepointPropertyReader
        assert.strictEqual Precis.PrecisPreparer, PrecisPreparer
        assert.strictEqual Precis.error.EmptyStringError, EmptyStringError
        assert.strictEqual Precis.error.InvalidCodepointError, InvalidCodepointError
        assert.strictEqual Precis.error.InvalidDirectionalityError, InvalidDirectionalityError
        assert.strictEqual Precis.profile.NicknameProfile, NicknameProfile
        assert.strictEqual Precis.profile.OpaqueStringProfile, OpaqueStringProfile
        assert.strictEqual Precis.profile.UsernameCaseMappedProfile, UsernameCaseMappedProfile
        assert.strictEqual Precis.profile.UsernameCasePreservedProfile, UsernameCasePreservedProfile
        assert.strictEqual Precis.unicode.CodepointPropertyReader, CodepointPropertyReader
        assert.strictEqual Precis.unicode.DirectionalityValidator, DirectionalityValidator
        assert.strictEqual Precis.unicode.WidthMapper, WidthMapper

    describe 'prepare()', ->

        it 'throws an error if the string class is not implemented', ->
            assert.throws (-> Precis.prepare stringClass: 111, ''), 'PRECIS string class not implemented.'

        describe 'for FreeformClass string class profiles', ->

            beforeEach ->
                @profile = stringClass: Precis.STRING_CLASS.FREEFORM

            it 'allows characters in the FreeformClass string class', ->
                assert.deepEqual Precis.prepare(@profile, ' !'), [0x0020, 0x0021]

            it 'rejects characters outside the FreeformClass string class', ->
                assert.throws (=> Precis.prepare @profile, "\u0000"), InvalidCodepointError
                assert.throws (=> Precis.prepare @profile, "\u007F"), InvalidCodepointError
                assert.throws (=> Precis.prepare @profile, "\u00B7"), InvalidCodepointError
                assert.throws (=> Precis.prepare @profile, "\u0378"), InvalidCodepointError
                assert.throws (=> Precis.prepare @profile, "\u200C"), InvalidCodepointError

        describe 'for IdentifierClass string class profiles', ->

            beforeEach ->
                @profile = stringClass: Precis.STRING_CLASS.IDENTIFIER

            it 'allows characters in the IdentifierClass string class', ->
                assert.deepEqual Precis.prepare(@profile, '!'), [0x0021]

            it 'rejects characters outside the IdentifierClass string class', ->
                assert.throws (=> Precis.prepare @profile, "\u0000"), InvalidCodepointError
                assert.throws (=> Precis.prepare @profile, "\u0020"), InvalidCodepointError
                assert.throws (=> Precis.prepare @profile, "\u007F"), InvalidCodepointError
                assert.throws (=> Precis.prepare @profile, "\u00B7"), InvalidCodepointError
                assert.throws (=> Precis.prepare @profile, "\u0378"), InvalidCodepointError
                assert.throws (=> Precis.prepare @profile, "\u200C"), InvalidCodepointError

    describe 'enforce()', ->

        it 'throws an error if the string class is not implemented', ->
            assert.throws (-> Precis.enforce stringClass: 111, ''), 'PRECIS string class not implemented.'

        describe 'for FreeformClass string class profiles', ->

            beforeEach ->
                @profile = stringClass: Precis.STRING_CLASS.FREEFORM

            it 'allows characters in the FreeformClass string class', ->
                assert.strictEqual Precis.enforce(@profile, ' !'), ' !'

            it 'rejects characters outside the FreeformClass string class', ->
                assert.throws (=> Precis.enforce @profile, '\u0000'), InvalidCodepointError
                assert.throws (=> Precis.enforce @profile, '\u007F'), InvalidCodepointError
                assert.throws (=> Precis.enforce @profile, '\u00B7'), InvalidCodepointError
                assert.throws (=> Precis.enforce @profile, '\u0378'), InvalidCodepointError
                assert.throws (=> Precis.enforce @profile, '\u200C'), InvalidCodepointError

        describe 'for profiles with callbacks', ->

            it 'calls the custom mapping callback', ->
                passedCodepoints = null
                passedPropertyReader = null
                @profile =
                    stringClass: Precis.STRING_CLASS.FREEFORM
                    map: (codepoints, propertyReader) ->
                        passedCodepoints = codepoints.slice()
                        passedPropertyReader = propertyReader
                Precis.enforce @profile, 'ab'

                assert.deepEqual passedCodepoints, [97, 98]
                assert.strictEqual passedPropertyReader, Precis.propertyReader

            it 'calls the custom validation callback', ->
                passedCodepoints = null
                @profile =
                    stringClass: Precis.STRING_CLASS.FREEFORM
                    validate: (codepoints) -> passedCodepoints = codepoints.slice()
                Precis.enforce @profile, 'ab'

                assert.deepEqual passedCodepoints, [97, 98]

        describe 'profile width mapping options', ->

            it 'supports width mapping', ->
                @profile =
                    stringClass: Precis.STRING_CLASS.FREEFORM
                    widthMapping: Precis.WIDTH_MAPPING.EAW

                assert.strictEqual Precis.enforce(@profile, '\uFF61'), '\u3002'

        describe 'profile case mapping options', ->

            beforeEach ->
                @profile = stringClass: Precis.STRING_CLASS.FREEFORM

            it 'supports lowercase case mapping', ->
                @profile.caseMapping = Precis.CASE_MAPPING.LOWERCASE

                assert.strictEqual Precis.enforce(@profile, 'Ab\u0370\u0371'), 'ab\u0371\u0371'

        describe 'profile normalization options', ->

            beforeEach ->
                @profile = stringClass: Precis.STRING_CLASS.FREEFORM

            it 'supports NFC normalization', ->
                @profile.normalization = Precis.NORMALIZATION.C
                actual = Precis.enforce @profile, '\u00F6\u0307o\u0308\u0307o\u0307\u0308\u2163'
                expected = '\u00F6\u0307\u00F6\u0307\u022F\u0308\u2163'

                assert.deepEqual ucs2.decode(actual), ucs2.decode(expected)

            it 'supports NFD normalization', ->
                @profile.normalization = Precis.NORMALIZATION.D
                actual = Precis.enforce @profile, '\u00F6\u0307o\u0308\u0307o\u0307\u0308\u2163'
                expected = 'o\u0308\u0307o\u0308\u0307o\u0307\u0308\u2163'

                assert.deepEqual ucs2.decode(actual), ucs2.decode(expected)

            it 'supports NFKC normalization', ->
                @profile.normalization = Precis.NORMALIZATION.KC
                actual = Precis.enforce @profile, '\u00F6\u0307o\u0308\u0307o\u0307\u0308\u2163'
                expected = '\u00F6\u0307\u00F6\u0307\u022F\u0308IV'

                assert.deepEqual ucs2.decode(actual), ucs2.decode(expected)

            it 'supports NFKD normalization', ->
                @profile.normalization = Precis.NORMALIZATION.KD
                actual = Precis.enforce @profile, '\u00F6\u0307o\u0308\u0307o\u0307\u0308\u2163'
                expected = 'o\u0308\u0307o\u0308\u0307o\u0307\u0308IV'

                assert.deepEqual ucs2.decode(actual), ucs2.decode(expected)

        describe 'profile directionality options', ->

            it 'supports directionality validation', ->
                @profile =
                    stringClass: Precis.STRING_CLASS.FREEFORM
                    directionality: Precis.DIRECTIONALITY.BIDI

                assert.doesNotThrow => Precis.enforce @profile, 'ab'
                assert.throws (=> Precis.enforce @profile, '0'), InvalidDirectionalityError
