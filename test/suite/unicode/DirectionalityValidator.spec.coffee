fs = require 'fs'
UnicodeTrie = require 'unicode-trie'
{ucs2} = require 'punycode'

CodepointPropertyReader = require '../../../src/unicode/CodepointPropertyReader'
DirectionalityValidator = require '../../../src/unicode/DirectionalityValidator'
InvalidDirectionalityError = require '../../../src/error/InvalidDirectionalityError'

describe 'DirectionalityValidator', ->

    before ->
        data = fs.readFileSync __dirname + '/../../../data/properties.trie'
        trie = new UnicodeTrie data
        @propertyReader = new CodepointPropertyReader trie

    beforeEach ->
        @subject = new DirectionalityValidator @propertyReader

    describe 'validate()', ->

        it 'allows zero-length strings', ->
            assert.doesNotThrow => @subject.validate []

        it 'allows basic left-to-right strings', ->
            codepoints = ucs2.decode 'ab'

            assert.doesNotThrow => @subject.validate codepoints

        it 'allows complex left-to-right strings', ->
            codepoints = ucs2.decode 'a0+,#!\u00ADb\u0300\u0301'

            assert.doesNotThrow => @subject.validate codepoints

        it 'allows basic right-to-left strings', ->
            codepoints = ucs2.decode '\u05D0\u05D1'

            assert.doesNotThrow => @subject.validate codepoints

        it 'allows complex right-to-left strings', ->
            codepointsA = ucs2.decode '\u05D0\u0620\u0666+,#!\u00AD\u05D1\u0300\u0301'
            codepointsB = ucs2.decode '\u05D0\u06200+,#!\u00AD\u05D1\u0300\u0301'

            assert.doesNotThrow => @subject.validate codepointsA
            assert.doesNotThrow => @subject.validate codepointsB

        it 'rejects a starting codepoint that is not L, R, or AL', ->
            codepoints = ucs2.decode '\u0666'

            assert.throws (=> @subject.validate codepoints), InvalidDirectionalityError

        it 'rejects invalid codepoints in left-to-right strings', ->
            codepoints = ucs2.decode 'a\u0620'

            assert.throws (=> @subject.validate codepoints), InvalidDirectionalityError

        it 'rejects invalid left-to-right string endings', ->
            codepoints = ucs2.decode 'a+'

            assert.throws (=> @subject.validate codepoints), InvalidDirectionalityError

        it 'rejects invalid codepoints in right-to-left strings', ->
            codepoints = ucs2.decode '\u0620a'

            assert.throws (=> @subject.validate codepoints), InvalidDirectionalityError

        it 'rejects invalid right-to-left string endings', ->
            codepoints = ucs2.decode '\u0620+'

            assert.throws (=> @subject.validate codepoints), InvalidDirectionalityError

        it 'rejects right-to-left strings with both AN and EN codepoints', ->
            codepointsA = ucs2.decode '\u0620\u06660'
            codepointsB = ucs2.decode '\u06200\u0666'

            assert.throws (=> @subject.validate codepointsA), InvalidDirectionalityError
            assert.throws (=> @subject.validate codepointsB), InvalidDirectionalityError
