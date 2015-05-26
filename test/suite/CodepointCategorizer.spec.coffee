CodepointCategorizer = require '../../src/CodepointCategorizer'

describe 'CodepointCategorizer', ->

    beforeEach ->
        @subject = new CodepointCategorizer()

    describe 'codepointCategory()', ->

        it 'correctly categorizes codepoints', ->
            assert.strictEqual @subject.codepointCategory(0), CodepointCategorizer.DISALLOWED
            assert.strictEqual @subject.codepointCategory(31), CodepointCategorizer.DISALLOWED
            assert.strictEqual @subject.codepointCategory(32), CodepointCategorizer.FREE_PVAL
            assert.strictEqual @subject.codepointCategory(33), CodepointCategorizer.PVALID
            assert.strictEqual @subject.codepointCategory(126), CodepointCategorizer.PVALID
            assert.strictEqual @subject.codepointCategory(127), CodepointCategorizer.DISALLOWED
            assert.strictEqual @subject.codepointCategory(183), CodepointCategorizer.CONTEXTO
            assert.strictEqual @subject.codepointCategory(888), CodepointCategorizer.UNASSIGNED
            assert.strictEqual @subject.codepointCategory(8204), CodepointCategorizer.CONTEXTJ
