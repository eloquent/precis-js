Precis = require '../index'

### !pragma coverage-skip-next ###
log2 = Math.log2 or (n) -> Math.log(n) / Math.LN2
bits = (n) -> (log2(n) + 1) | 0

precisBits = bits Object.keys(Precis.PRECIS_CATEGORY).length - 1
bidiBits = bits Object.keys(Precis.BIDI_CLASS).length - 1

precisShift = bidiBits + 1
bidiShift = 1

precisMask = (1 << precisBits) - 1
bidiMask = (1 << bidiBits) - 1

module.exports = class CodepointPropertyReader

    constructor: (@trie) ->

    precisCategory: (codepoint) ->
        data = @trie.get codepoint
        (data >> precisShift) & precisMask

    bidiClass: (codepoint) ->
        data = @trie.get codepoint
        (data >> bidiShift) & bidiMask

    isNonAsciiSpace: (codepoint) ->
        data = @trie.get codepoint
        data & 1
