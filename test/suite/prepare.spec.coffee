CodepointPropertyReader = require '../../src/unicode/CodepointPropertyReader'
DirectionalityValidator = require '../../src/unicode/DirectionalityValidator'
EmptyStringError = require '../../src/error/EmptyStringError'
InvalidCodepointError = require '../../src/error/InvalidCodepointError'
InvalidDirectionalityError = require '../../src/error/InvalidDirectionalityError'
NicknameProfile = require '../../src/profile/NicknameProfile'
Normalizer = require '../../src/unicode/Normalizer'
OpaqueStringProfile = require '../../src/profile/OpaqueStringProfile'
precis = require '../../src/prepare'
PrecisPreparer = require '../../src/PrecisPreparer'
UsernameCaseMappedProfile = require '../../src/profile/UsernameCaseMappedProfile'
UsernameCasePreservedProfile = require '../../src/profile/UsernameCasePreservedProfile'
WidthMapper = require '../../src/unicode/WidthMapper'

describe 'prepare', ->

    it 'produces the correct exports', ->
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
                @profile = stringClass: precis.STRING_CLASS.FREEFORM

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
                @profile = stringClass: precis.STRING_CLASS.IDENTIFIER

            it 'allows characters in the IdentifierClass string class', ->
                assert.deepEqual precis.prepare(@profile, '!'), [0x0021]

            it 'rejects characters outside the IdentifierClass string class', ->
                assert.throws (=> precis.prepare @profile, "\u0000"), InvalidCodepointError
                assert.throws (=> precis.prepare @profile, "\u0020"), InvalidCodepointError
                assert.throws (=> precis.prepare @profile, "\u007F"), InvalidCodepointError
                assert.throws (=> precis.prepare @profile, "\u00B7"), InvalidCodepointError
                assert.throws (=> precis.prepare @profile, "\u0378"), InvalidCodepointError
                assert.throws (=> precis.prepare @profile, "\u200C"), InvalidCodepointError
