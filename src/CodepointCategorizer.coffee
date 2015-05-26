fs = require 'fs'
UnicodeTrie = require 'unicode-trie'

module.exports = class CodepointCategorizer

    @UNASSIGNED: 0
    @DISALLOWED: 1
    @FREE_PVAL: 2
    @PVALID: 3
    @CONTEXTO: 4
    @CONTEXTJ: 5

    constructor: () ->
        data = fs.readFileSync __dirname + '/../data/precis.trie'
        @trie = new UnicodeTrie data

    codepointCategory: (codepoint) -> @trie.get codepoint

