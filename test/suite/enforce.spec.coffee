{ucs2} = require 'punycode'

CodepointPropertyReader = require '../../src/unicode/CodepointPropertyReader'
DirectionalityValidator = require '../../src/unicode/DirectionalityValidator'
EmptyStringError = require '../../src/error/EmptyStringError'
InvalidCodepointError = require '../../src/error/InvalidCodepointError'
InvalidDirectionalityError = require '../../src/error/InvalidDirectionalityError'
NicknameProfile = require '../../src/profile/NicknameProfile'
Normalizer = require '../../src/unicode/Normalizer'
OpaqueStringProfile = require '../../src/profile/OpaqueStringProfile'
precis = require '../../src/enforce'
PrecisEnforcer = require '../../src/PrecisEnforcer'
PrecisPreparer = require '../../src/PrecisPreparer'
UsernameCaseMappedProfile = require '../../src/profile/UsernameCaseMappedProfile'
UsernameCasePreservedProfile = require '../../src/profile/UsernameCasePreservedProfile'
WidthMapper = require '../../src/unicode/WidthMapper'

describe 'enforce', ->

    it 'produces the correct exports', ->
        assert.instanceOf precis.enforcer, PrecisEnforcer
        assert.instanceOf precis.preparer, PrecisPreparer
        assert.instanceOf precis.propertyReader, CodepointPropertyReader
        assert.strictEqual precis.PrecisPreparer, PrecisPreparer
        assert.strictEqual precis.error.EmptyStringError, EmptyStringError
        assert.strictEqual precis.error.InvalidCodepointError, InvalidCodepointError
        assert.strictEqual precis.error.InvalidDirectionalityError, InvalidDirectionalityError
        assert.strictEqual precis.profile.NicknameProfile, NicknameProfile
        assert.strictEqual precis.profile.OpaqueStringProfile, OpaqueStringProfile
        assert.strictEqual precis.profile.UsernameCaseMappedProfile, UsernameCaseMappedProfile
        assert.strictEqual precis.profile.UsernameCasePreservedProfile, UsernameCasePreservedProfile
        assert.strictEqual precis.unicode.CodepointPropertyReader, CodepointPropertyReader
        assert.strictEqual precis.unicode.DirectionalityValidator, DirectionalityValidator
        assert.strictEqual precis.unicode.Normalizer, Normalizer
        assert.strictEqual precis.unicode.WidthMapper, WidthMapper

    describe 'prepare()', ->

        it 'throws an error if the string class is not implemented', ->
            assert.throws (-> precis.prepare stringClass: 111, ''), 'PRECIS string class not implemented.'

        describe 'for FreeformClass string class profiles', ->

            beforeEach ->
                @profile = stringClass: precis.STRING_CLASS.FREEFORM, normalization: precis.NORMALIZATION.NONE

            it 'allows characters in the FreeformClass string class', ->
                assert.deepEqual precis.prepare(@profile, ' !'), [0x0020, 0x0021]

            it 'rejects characters outside the FreeformClass string class', ->
                assert.throws (=> precis.prepare @profile, "\u0000"), InvalidCodepointError
                assert.throws (=> precis.prepare @profile, "\u007F"), InvalidCodepointError
                assert.throws (=> precis.prepare @profile, "\u00B7"), InvalidCodepointError
                assert.throws (=> precis.prepare @profile, "\u0378"), InvalidCodepointError
                assert.throws (=> precis.prepare @profile, "\u200C"), InvalidCodepointError

        describe 'for IdentifierClass string class profiles', ->

            beforeEach ->
                @profile = stringClass: precis.STRING_CLASS.IDENTIFIER, normalization: precis.NORMALIZATION.NONE

            it 'allows characters in the IdentifierClass string class', ->
                assert.deepEqual precis.prepare(@profile, '!'), [0x0021]

            it 'rejects characters outside the IdentifierClass string class', ->
                assert.throws (=> precis.prepare @profile, "\u0000"), InvalidCodepointError
                assert.throws (=> precis.prepare @profile, "\u0020"), InvalidCodepointError
                assert.throws (=> precis.prepare @profile, "\u007F"), InvalidCodepointError
                assert.throws (=> precis.prepare @profile, "\u00B7"), InvalidCodepointError
                assert.throws (=> precis.prepare @profile, "\u0378"), InvalidCodepointError
                assert.throws (=> precis.prepare @profile, "\u200C"), InvalidCodepointError

    describe 'enforce()', ->

        it 'throws an error if the string class is not implemented', ->
            assert.throws (-> precis.enforce stringClass: 111, ''), 'PRECIS string class not implemented.'

        describe 'for FreeformClass string class profiles', ->

            beforeEach ->
                @profile = stringClass: precis.STRING_CLASS.FREEFORM, normalization: precis.NORMALIZATION.NONE

            it 'allows characters in the FreeformClass string class', ->
                assert.strictEqual precis.enforce(@profile, ' !'), ' !'

            it 'rejects characters outside the FreeformClass string class', ->
                assert.throws (=> precis.enforce @profile, '\u0000'), InvalidCodepointError
                assert.throws (=> precis.enforce @profile, '\u007F'), InvalidCodepointError
                assert.throws (=> precis.enforce @profile, '\u00B7'), InvalidCodepointError
                assert.throws (=> precis.enforce @profile, '\u0378'), InvalidCodepointError
                assert.throws (=> precis.enforce @profile, '\u200C'), InvalidCodepointError

        describe 'for profiles with callbacks', ->

            it 'calls the custom mapping callback', ->
                passedCodepoints = null
                passedEnforcer = null
                @profile =
                    stringClass: precis.STRING_CLASS.FREEFORM
                    normalization: precis.NORMALIZATION.NONE
                    map: (codepoints, enforcer) ->
                        passedCodepoints = codepoints.slice()
                        passedEnforcer = enforcer
                precis.enforce @profile, 'ab'

                assert.deepEqual passedCodepoints, [97, 98]
                assert.strictEqual passedEnforcer, precis.enforcer

            it 'calls the custom validation callback', ->
                passedCodepoints = null
                passedEnforcer = null
                @profile =
                    stringClass: precis.STRING_CLASS.FREEFORM
                    normalization: precis.NORMALIZATION.NONE
                    validate: (codepoints, enforcer) ->
                        passedCodepoints = codepoints.slice()
                        passedEnforcer = enforcer
                precis.enforce @profile, 'ab'

                assert.deepEqual passedCodepoints, [97, 98]
                assert.strictEqual passedEnforcer, precis.enforcer

        describe 'profile width mapping options', ->

            it 'supports width mapping', ->
                @profile =
                    stringClass: precis.STRING_CLASS.FREEFORM
                    normalization: precis.NORMALIZATION.NONE
                    widthMapping: precis.WIDTH_MAPPING.EAW

                assert.strictEqual precis.enforce(@profile, '\uFF61'), '\u3002'

        describe 'profile case mapping options', ->

            beforeEach ->
                @profile = stringClass: precis.STRING_CLASS.FREEFORM, normalization: precis.NORMALIZATION.NONE

            it 'supports lowercase case mapping', ->
                @profile.caseMapping = precis.CASE_MAPPING.LOWERCASE

                assert.strictEqual precis.enforce(@profile, 'Ab\u0370\u0371'), 'ab\u0371\u0371'

        describe 'profile normalization options', ->

            beforeEach ->
                @profile = stringClass: precis.STRING_CLASS.FREEFORM, normalization: precis.NORMALIZATION.NONE

            it 'supports NFC normalization', ->
                @profile.normalization = precis.NORMALIZATION.C
                actual = precis.enforce @profile, '\u00F6\u0307o\u0308\u0307o\u0307\u0308\u2163'
                expected = '\u00F6\u0307\u00F6\u0307\u022F\u0308\u2163'

                assert.deepEqual ucs2.decode(actual), ucs2.decode(expected)

            it 'supports NFD normalization', ->
                @profile.normalization = precis.NORMALIZATION.D
                actual = precis.enforce @profile, '\u00F6\u0307o\u0308\u0307o\u0307\u0308\u2163'
                expected = 'o\u0308\u0307o\u0308\u0307o\u0307\u0308\u2163'

                assert.deepEqual ucs2.decode(actual), ucs2.decode(expected)

            it 'supports NFKC normalization', ->
                @profile.normalization = precis.NORMALIZATION.KC
                actual = precis.enforce @profile, '\u00F6\u0307o\u0308\u0307o\u0307\u0308\u2163'
                expected = '\u00F6\u0307\u00F6\u0307\u022F\u0308IV'

                assert.deepEqual ucs2.decode(actual), ucs2.decode(expected)

            it 'supports NFKD normalization', ->
                @profile.normalization = precis.NORMALIZATION.KD
                actual = precis.enforce @profile, '\u00F6\u0307o\u0308\u0307o\u0307\u0308\u2163'
                expected = 'o\u0308\u0307o\u0308\u0307o\u0307\u0308IV'

                assert.deepEqual ucs2.decode(actual), ucs2.decode(expected)

        describe 'profile directionality options', ->

            it 'supports directionality validation', ->
                @profile =
                    stringClass: precis.STRING_CLASS.FREEFORM
                    normalization: precis.NORMALIZATION.NONE
                    directionality: precis.DIRECTIONALITY.BIDI

                assert.doesNotThrow => precis.enforce @profile, 'ab'
                assert.throws (=> precis.enforce @profile, '0'), InvalidDirectionalityError
