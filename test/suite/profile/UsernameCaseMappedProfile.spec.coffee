EmptyStringError = require '../../../src/error/EmptyStringError'
precis = require '../../../src/constants'
UsernameCaseMappedProfile = require '../../../src/profile/UsernameCaseMappedProfile'

describe 'UsernameCaseMappedProfile', ->

    beforeEach ->
        @subject = new UsernameCaseMappedProfile()

    it 'has the correct properties', ->
        assert.strictEqual @subject.stringClass, precis.STRING_CLASS.IDENTIFIER
        assert.strictEqual @subject.widthMapping, precis.WIDTH_MAPPING.EAW
        assert.strictEqual @subject.caseMapping, precis.CASE_MAPPING.LOWERCASE
        assert.strictEqual @subject.normalization, precis.NORMALIZATION.C
        assert.strictEqual @subject.directionality, precis.DIRECTIONALITY.BIDI

    describe 'validate()', ->

        it 'allows non-empty strings', ->
            assert.doesNotThrow => @subject.validate [0]

        it 'rejects empty strings', ->
            assert.throws (=> @subject.validate []), EmptyStringError
