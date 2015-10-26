fs = require 'fs'
UnicodeTrie = require 'unicode-trie'
{ucs2} = require 'punycode'

CodepointPropertyReader = require '../../../src/unicode/CodepointPropertyReader'
EmptyStringError = require '../../../src/error/EmptyStringError'
OpaqueStringProfile = require '../../../src/profile/OpaqueStringProfile'
precis = require '../../../src/constants'

describe 'OpaqueStringProfile', ->

    before ->
        data = fs.readFileSync __dirname + '/../../../data/properties.trie'
        @trie = new UnicodeTrie data

    beforeEach ->
        @subject = new OpaqueStringProfile()

        @enforcer = propertyReader: new CodepointPropertyReader @trie

    it 'has the correct properties', ->
        assert.strictEqual @subject.stringClass, precis.STRING_CLASS.FREEFORM
        assert.strictEqual @subject.widthMapping, precis.WIDTH_MAPPING.NONE
        assert.strictEqual @subject.caseMapping, precis.CASE_MAPPING.NONE
        assert.strictEqual @subject.normalization, precis.NORMALIZATION.C
        assert.strictEqual @subject.directionality, precis.DIRECTIONALITY.NONE

    describe 'map()', ->

        it 'maps non-ASCII spaces to ASCII spaces', ->
            codepoints = ucs2.decode '\u3000ab\u3000cd\u3000ef\u3000'
            @subject.map codepoints, @enforcer

            assert.strictEqual ucs2.encode(codepoints), ' ab cd ef '

    describe 'validate()', ->

        it 'allows non-empty strings', ->
            assert.doesNotThrow => @subject.validate [0]

        it 'rejects empty strings', ->
            assert.throws (=> @subject.validate []), EmptyStringError
