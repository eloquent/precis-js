CodepointPropertyReader = require '../../src/CodepointPropertyReader'

describe 'CodepointPropertyReader', ->

    beforeEach ->
        @subject = new CodepointPropertyReader()

    describe 'precisCategory()', ->

        it 'returns correct PRECIS categories', ->
            assert.strictEqual @subject.precisCategory(0x0000), CodepointPropertyReader.PRECIS.DISALLOWED
            assert.strictEqual @subject.precisCategory(0x0020), CodepointPropertyReader.PRECIS.FREE_PVAL
            assert.strictEqual @subject.precisCategory(0x0021), CodepointPropertyReader.PRECIS.PVALID
            assert.strictEqual @subject.precisCategory(0x007F), CodepointPropertyReader.PRECIS.DISALLOWED
            assert.strictEqual @subject.precisCategory(0x00B7), CodepointPropertyReader.PRECIS.CONTEXTO
            assert.strictEqual @subject.precisCategory(0x0378), CodepointPropertyReader.PRECIS.UNASSIGNED
            assert.strictEqual @subject.precisCategory(0x200C), CodepointPropertyReader.PRECIS.CONTEXTJ

    describe 'bidiClass()', ->

        it 'returns correct Bidi classes', ->
            assert.strictEqual @subject.bidiClass(0x0000), CodepointPropertyReader.BIDI.BN    # BN
            assert.strictEqual @subject.bidiClass(0x0009), CodepointPropertyReader.BIDI.OTHER # S
            assert.strictEqual @subject.bidiClass(0x000A), CodepointPropertyReader.BIDI.OTHER # B
            assert.strictEqual @subject.bidiClass(0x000C), CodepointPropertyReader.BIDI.OTHER # WS
            assert.strictEqual @subject.bidiClass(0x0021), CodepointPropertyReader.BIDI.ON    # ON
            assert.strictEqual @subject.bidiClass(0x0023), CodepointPropertyReader.BIDI.ET    # ET
            assert.strictEqual @subject.bidiClass(0x002B), CodepointPropertyReader.BIDI.ES    # ES
            assert.strictEqual @subject.bidiClass(0x002C), CodepointPropertyReader.BIDI.CS    # CS
            assert.strictEqual @subject.bidiClass(0x0030), CodepointPropertyReader.BIDI.EN    # EN
            assert.strictEqual @subject.bidiClass(0x0041), CodepointPropertyReader.BIDI.L     # L
            assert.strictEqual @subject.bidiClass(0x0300), CodepointPropertyReader.BIDI.NSM   # NSM
            assert.strictEqual @subject.bidiClass(0x05BE), CodepointPropertyReader.BIDI.R     # R
            assert.strictEqual @subject.bidiClass(0x0600), CodepointPropertyReader.BIDI.AN    # AN
            assert.strictEqual @subject.bidiClass(0x0608), CodepointPropertyReader.BIDI.AL    # AL
            assert.strictEqual @subject.bidiClass(0x202A), CodepointPropertyReader.BIDI.OTHER # LRE
            assert.strictEqual @subject.bidiClass(0x202B), CodepointPropertyReader.BIDI.OTHER # RLE
            assert.strictEqual @subject.bidiClass(0x202C), CodepointPropertyReader.BIDI.OTHER # PDF
            assert.strictEqual @subject.bidiClass(0x202D), CodepointPropertyReader.BIDI.OTHER # LRO
            assert.strictEqual @subject.bidiClass(0x202E), CodepointPropertyReader.BIDI.OTHER # RLO
            assert.strictEqual @subject.bidiClass(0x2066), CodepointPropertyReader.BIDI.OTHER # LRI
            assert.strictEqual @subject.bidiClass(0x2067), CodepointPropertyReader.BIDI.OTHER # RLI
            assert.strictEqual @subject.bidiClass(0x2068), CodepointPropertyReader.BIDI.OTHER # FSI
            assert.strictEqual @subject.bidiClass(0x2069), CodepointPropertyReader.BIDI.OTHER # PDI
