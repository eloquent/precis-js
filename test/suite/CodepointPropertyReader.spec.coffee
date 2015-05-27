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
