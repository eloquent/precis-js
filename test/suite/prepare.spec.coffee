CodepointPropertyReader = require '../../src/unicode/CodepointPropertyReader'
DirectionalityValidator = require '../../src/unicode/DirectionalityValidator'
EmptyStringError = require '../../src/error/EmptyStringError'
InvalidCodepointError = require '../../src/error/InvalidCodepointError'
InvalidDirectionalityError = require '../../src/error/InvalidDirectionalityError'
NicknameProfile = require '../../src/profile/NicknameProfile'
OpaqueStringProfile = require '../../src/profile/OpaqueStringProfile'
Precis = require '../../src/prepare'
PrecisPreparer = require '../../src/PrecisPreparer'
UsernameCaseMappedProfile = require '../../src/profile/UsernameCaseMappedProfile'
UsernameCasePreservedProfile = require '../../src/profile/UsernameCasePreservedProfile'
WidthMapper = require '../../src/unicode/WidthMapper'

describe 'Precis (prepare only)', ->

    it 'produces the correct exports', ->
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
