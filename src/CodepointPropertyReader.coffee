fs = require 'fs'
UnicodeTrie = require 'unicode-trie'

log2 = Math.log2 or (n) -> Math.log(n) / Math.LN2
bits = (n) -> (log2(n) + 1) | 0

precisCategories =
    UNASSIGNED: 0
    DISALLOWED: 1
    FREE_PVAL: 2
    PVALID: 3
    CONTEXTO: 4
    CONTEXTJ: 5

bidiClasses =
    OTHER: 0
    L: 1
    R: 2
    AL: 3
    AN: 4
    EN: 5
    ES: 6
    CS: 7
    ET: 8
    ON: 9
    BN: 10
    NSM: 11

precisBits = bits Object.keys(precisCategories).length - 1
bidiBits = bits Object.keys(bidiClasses).length - 1

precisShift = bidiBits + 1
bidiShift = 1

precisMask = (1 << precisBits) - 1
bidiMask = (1 << bidiBits) - 1

module.exports = class CodepointPropertyReader

    @PRECIS = precisCategories
    @BIDI = bidiClasses

    constructor: ->
        data = fs.readFileSync __dirname + '/../data/properties.trie'
        @trie = new UnicodeTrie data

    precisCategory: (codepoint) ->
        data = @trie.get codepoint
        (data >> precisShift) & precisMask

    bidiClass: (codepoint) ->
        data = @trie.get codepoint
        (data >> bidiShift) & bidiMask

    isNonAsciiSpace: (codepoint) ->
        @trie.get codepoint & 1
