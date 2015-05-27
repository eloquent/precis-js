CodepointPropertyReader = require '../../src/CodepointPropertyReader'

describe 'CodepointPropertyReader', ->

    beforeEach ->
        @subject = new CodepointPropertyReader()

    describe 'precisCategory()', ->

        it 'returns correct PRECIS categories', ->
            assert.strictEqual @subject.precisCategory(0), CodepointPropertyReader.PRECIS.DISALLOWED
            assert.strictEqual @subject.precisCategory(31), CodepointPropertyReader.PRECIS.DISALLOWED
            assert.strictEqual @subject.precisCategory(32), CodepointPropertyReader.PRECIS.FREE_PVAL
            assert.strictEqual @subject.precisCategory(33), CodepointPropertyReader.PRECIS.PVALID
            assert.strictEqual @subject.precisCategory(126), CodepointPropertyReader.PRECIS.PVALID
            assert.strictEqual @subject.precisCategory(127), CodepointPropertyReader.PRECIS.DISALLOWED
            assert.strictEqual @subject.precisCategory(183), CodepointPropertyReader.PRECIS.CONTEXTO
            assert.strictEqual @subject.precisCategory(888), CodepointPropertyReader.PRECIS.UNASSIGNED
            assert.strictEqual @subject.precisCategory(8204), CodepointPropertyReader.PRECIS.CONTEXTJ
