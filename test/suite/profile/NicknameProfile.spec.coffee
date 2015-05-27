fs = require 'fs'
UnicodeTrie = require 'unicode-trie'
{ucs2} = require 'punycode'

CodepointPropertyReader = require '../../../src/unicode/CodepointPropertyReader'
EmptyStringError = require '../../../src/error/EmptyStringError'
NicknameProfile = require '../../../src/profile/NicknameProfile'
Precis = require '../../../src/index'

describe 'NicknameProfile', ->

    before ->
        data = fs.readFileSync __dirname + '/../../../data/properties.trie'
        @trie = new UnicodeTrie data

    beforeEach ->
        @subject = new NicknameProfile()

        @propertyReader = new CodepointPropertyReader @trie

    it 'has the correct properties', ->
        assert.strictEqual @subject.stringClass, Precis.STRING_CLASS.FREEFORM
        assert.strictEqual @subject.widthMapping, Precis.WIDTH_MAPPING.NONE
        assert.strictEqual @subject.caseMapping, Precis.CASE_MAPPING.LOWERCASE
        assert.strictEqual @subject.normalization, Precis.NORMALIZATION.KC
        assert.strictEqual @subject.directionality, Precis.DIRECTIONALITY.NONE

    describe 'map()', ->

        it 'right-trims strings', ->
            codepoints = ucs2.decode 'ab  '
            @subject.map codepoints, @propertyReader

            assert.strictEqual ucs2.encode(codepoints), 'ab'

        it 'left-trims strings', ->
            codepoints = ucs2.decode '  ab'
            @subject.map codepoints, @propertyReader

            assert.strictEqual ucs2.encode(codepoints), 'ab'

        it 'trims strings', ->
            codepoints = ucs2.decode '  ab  '
            @subject.map codepoints, @propertyReader

            assert.strictEqual ucs2.encode(codepoints), 'ab'

        it 'collapses inner whitespace', ->
            codepoints = ucs2.decode 'ab  cd  ef'
            @subject.map codepoints, @propertyReader

            assert.strictEqual ucs2.encode(codepoints), 'ab cd ef'

        it 'collapses inner whitespace and trims at the same time', ->
            codepoints = ucs2.decode '  ab  cd  ef  '
            @subject.map codepoints, @propertyReader

            assert.strictEqual ucs2.encode(codepoints), 'ab cd ef'

        it 'maps non-ASCII spaces to ASCII spaces', ->
            codepoints = ucs2.decode '\u3000ab\u3000cd\u3000ef\u3000'
            @subject.map codepoints, @propertyReader

            assert.strictEqual ucs2.encode(codepoints), 'ab cd ef'

    describe 'validate()', ->

        it 'rejects empty strings', ->
            assert.throws (=> @subject.validate []), EmptyStringError
