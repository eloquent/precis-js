EmptyStringError = require '../../../src/error/EmptyStringError'

describe 'EmptyStringError', ->

    beforeEach ->
        @subject = new EmptyStringError()

    it 'generates a meaningful message', ->
        assert.strictEqual @subject.message, 'String cannot be empty.'
