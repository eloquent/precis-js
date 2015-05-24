CodepointCategorizer = require '../../src/CodepointCategorizer'

describe 'CodepointCategorizer', ->

    beforeEach ->
        @subject = new CodepointCategorizer()

    describe 'codepointCategory()', ->

        it 'correctly categorizes codepoints', ->
            assert.strictEqual @subject.codepointCategory(0), 'DISALLOWED'
            assert.strictEqual @subject.codepointCategory(31), 'DISALLOWED'
            assert.strictEqual @subject.codepointCategory(32), 'FREE_PVAL'
            assert.strictEqual @subject.codepointCategory(33), 'PVALID'
            assert.strictEqual @subject.codepointCategory(126), 'PVALID'
            assert.strictEqual @subject.codepointCategory(127), 'DISALLOWED'
            assert.strictEqual @subject.codepointCategory(183), 'CONTEXTO'
            assert.strictEqual @subject.codepointCategory(888), 'UNASSIGNED'
            assert.strictEqual @subject.codepointCategory(8204), 'CONTEXTJ'
