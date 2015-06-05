fs = require 'fs'
UnicodeTrie = require 'unicode-trie'
{ucs2} = require 'punycode'

CodepointPropertyReader = require '../../../src/unicode/CodepointPropertyReader'
EmptyStringError = require '../../../src/error/EmptyStringError'
OpaqueStringProfile = require '../../../src/profile/OpaqueStringProfile'
Precis = require '../../../src/index'

describe 'OpaqueStringProfile', ->

    before ->
        data = fs.readFileSync __dirname + '/../../../data/properties.trie'
        @trie = new UnicodeTrie data

    beforeEach ->
        @subject = new OpaqueStringProfile()

        @propertyReader = new CodepointPropertyReader @trie

    it 'has the correct properties', ->
        assert.strictEqual @subject.stringClass, Precis.STRING_CLASS.FREEFORM
        assert.strictEqual @subject.widthMapping, Precis.WIDTH_MAPPING.NONE
        assert.strictEqual @subject.caseMapping, Precis.CASE_MAPPING.NONE
        assert.strictEqual @subject.normalization, Precis.NORMALIZATION.C
        assert.strictEqual @subject.directionality, Precis.DIRECTIONALITY.NONE

    describe 'map()', ->

        it 'maps non-ASCII spaces to ASCII spaces', ->
            codepoints = ucs2.decode '\u3000ab\u3000cd\u3000ef\u3000'
            @subject.map codepoints, @propertyReader

            assert.strictEqual ucs2.encode(codepoints), ' ab cd ef '

    describe 'validate()', ->

        it 'allows non-empty strings', ->
            assert.doesNotThrow => @subject.validate [0]

        it 'rejects empty strings', ->
            assert.throws (=> @subject.validate []), EmptyStringError
