fs = require 'fs'
UnicodeTrie = require 'unicode-trie'

CodepointPropertyReader = require '../../../src/unicode/CodepointPropertyReader'
precis = require '../../../src/constants'

describe 'CodepointPropertyReader', ->

    before ->
        data = fs.readFileSync __dirname + '/../../../data/properties.trie'
        @trie = new UnicodeTrie data

    beforeEach ->
        @subject = new CodepointPropertyReader @trie

    describe 'precisCategory()', ->

        it 'returns correct PRECIS categories', ->
            assert.strictEqual @subject.precisCategory(0x0000), precis.PRECIS_CATEGORY.DISALLOWED
            assert.strictEqual @subject.precisCategory(0x0020), precis.PRECIS_CATEGORY.FREE_PVAL
            assert.strictEqual @subject.precisCategory(0x0021), precis.PRECIS_CATEGORY.PVALID
            assert.strictEqual @subject.precisCategory(0x007F), precis.PRECIS_CATEGORY.DISALLOWED
            assert.strictEqual @subject.precisCategory(0x00B7), precis.PRECIS_CATEGORY.CONTEXTO
            assert.strictEqual @subject.precisCategory(0x0378), precis.PRECIS_CATEGORY.UNASSIGNED
            assert.strictEqual @subject.precisCategory(0x200C), precis.PRECIS_CATEGORY.CONTEXTJ

    describe 'bidiClass()', ->

        it 'returns correct Bidi classes', ->
            assert.strictEqual @subject.bidiClass(0x0000), precis.BIDI_CLASS.BN, 'BN'
            assert.strictEqual @subject.bidiClass(0x0009), precis.BIDI_CLASS.OTHER, 'S'
            assert.strictEqual @subject.bidiClass(0x000A), precis.BIDI_CLASS.OTHER, 'B'
            assert.strictEqual @subject.bidiClass(0x000C), precis.BIDI_CLASS.OTHER, 'WS'
            assert.strictEqual @subject.bidiClass(0x0021), precis.BIDI_CLASS.ON, 'ON'
            assert.strictEqual @subject.bidiClass(0x0023), precis.BIDI_CLASS.ET, 'ET'
            assert.strictEqual @subject.bidiClass(0x002B), precis.BIDI_CLASS.ES, 'ES'
            assert.strictEqual @subject.bidiClass(0x002C), precis.BIDI_CLASS.CS, 'CS'
            assert.strictEqual @subject.bidiClass(0x0030), precis.BIDI_CLASS.EN, 'EN'
            assert.strictEqual @subject.bidiClass(0x0041), precis.BIDI_CLASS.L, 'L'
            assert.strictEqual @subject.bidiClass(0x0300), precis.BIDI_CLASS.NSM, 'NSM'
            assert.strictEqual @subject.bidiClass(0x05BE), precis.BIDI_CLASS.R, 'R'
            assert.strictEqual @subject.bidiClass(0x0600), precis.BIDI_CLASS.AN, 'AN'
            assert.strictEqual @subject.bidiClass(0x0608), precis.BIDI_CLASS.AL, 'AL'
            assert.strictEqual @subject.bidiClass(0x202A), precis.BIDI_CLASS.OTHER, 'LRE'
            assert.strictEqual @subject.bidiClass(0x202B), precis.BIDI_CLASS.OTHER, 'RLE'
            assert.strictEqual @subject.bidiClass(0x202C), precis.BIDI_CLASS.OTHER, 'PDF'
            assert.strictEqual @subject.bidiClass(0x202D), precis.BIDI_CLASS.OTHER, 'LRO'
            assert.strictEqual @subject.bidiClass(0x202E), precis.BIDI_CLASS.OTHER, 'RLO'
            assert.strictEqual @subject.bidiClass(0x2066), precis.BIDI_CLASS.OTHER, 'LRI'
            assert.strictEqual @subject.bidiClass(0x2067), precis.BIDI_CLASS.OTHER, 'RLI'
            assert.strictEqual @subject.bidiClass(0x2068), precis.BIDI_CLASS.OTHER, 'FSI'
            assert.strictEqual @subject.bidiClass(0x2069), precis.BIDI_CLASS.OTHER, 'PDI'

    describe 'isNonAsciiSpace()', ->

        it 'returns truthy for non-ASCII space separators', ->
            assert.ok @subject.isNonAsciiSpace 0x00A0
            assert.ok @subject.isNonAsciiSpace 0x1680
            assert.ok @subject.isNonAsciiSpace 0x2000
            assert.ok @subject.isNonAsciiSpace 0x2001
            assert.ok @subject.isNonAsciiSpace 0x2002
            assert.ok @subject.isNonAsciiSpace 0x2003
            assert.ok @subject.isNonAsciiSpace 0x2004
            assert.ok @subject.isNonAsciiSpace 0x2005
            assert.ok @subject.isNonAsciiSpace 0x2006
            assert.ok @subject.isNonAsciiSpace 0x2007
            assert.ok @subject.isNonAsciiSpace 0x2008
            assert.ok @subject.isNonAsciiSpace 0x2009
            assert.ok @subject.isNonAsciiSpace 0x200A
            assert.ok @subject.isNonAsciiSpace 0x202F
            assert.ok @subject.isNonAsciiSpace 0x205F
            assert.ok @subject.isNonAsciiSpace 0x3000

        it 'returns falsy for the ASCII space codepoint', ->
            assert.notOk @subject.isNonAsciiSpace 0x0020

        it 'returns falsy for non-space characters', ->
            assert.notOk @subject.isNonAsciiSpace 0x0030

        it 'returns falsy for line separators', ->
            assert.notOk @subject.isNonAsciiSpace 0x2028

        it 'returns falsy for paragraph separators', ->
            assert.notOk @subject.isNonAsciiSpace 0x2029
