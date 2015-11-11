EmptyStringError = require '../../../src/error/EmptyStringError'
precis = require '../../../src/constants'
UsernameCasePreservedProfile = require '../../../src/profile/UsernameCasePreservedProfile'

describe 'UsernameCasePreservedProfile', ->

    beforeEach ->
        @subject = new UsernameCasePreservedProfile()

    it 'has the correct properties', ->
        assert.strictEqual @subject.stringClass, precis.STRING_CLASS.IDENTIFIER
        assert.strictEqual @subject.widthMapping, precis.WIDTH_MAPPING.NONE
        assert.strictEqual @subject.caseMapping, precis.CASE_MAPPING.NONE
        assert.strictEqual @subject.normalization, precis.NORMALIZATION.C
        assert.strictEqual @subject.directionality, precis.DIRECTIONALITY.BIDI

    describe 'prePrepareMap()', ->

        it 'performs width mapping', ->
            actual = [0xFF61, 0xFF67, 0xFFA1, 0xFFDC]
            expected = [0x3002, 0x30A1, 0x3131, 0x3163]
            @subject.prePrepareMap(actual, precis.preparer)

            assert.deepEqual actual, expected

    describe 'validate()', ->

        it 'allows non-empty strings', ->
            assert.doesNotThrow => @subject.validate [0]

        it 'rejects empty strings', ->
            assert.throws (=> @subject.validate []), EmptyStringError
