EmptyStringError = require '../../../src/error/EmptyStringError'
Precis = require '../../../src/index'
UsernameCaseMappedProfile = require '../../../src/profile/UsernameCaseMappedProfile'

describe 'UsernameCaseMappedProfile', ->

    beforeEach ->
        @subject = new UsernameCaseMappedProfile()

    it 'has the correct properties', ->
        assert.strictEqual @subject.stringClass, Precis.STRING_CLASS.IDENTIFIER
        assert.isTrue @subject.widthMapping
        assert.strictEqual @subject.caseMapping, Precis.CASE_MAPPING.LOWERCASE
        assert.strictEqual @subject.normalization, Precis.NORMALIZATION.C
        assert.isTrue @subject.checkBidi

    describe 'validate()', ->

        it 'allows non-empty strings', ->
            assert.doesNotThrow => @subject.validate [0]

        it 'rejects empty strings', ->
            assert.throws (=> @subject.validate []), EmptyStringError
