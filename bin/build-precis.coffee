fs = require 'fs'
UnicodeTrieBuilder = require 'unicode-trie/builder'

data = JSON.parse fs.readFileSync __dirname + '/../build/precis.json'

categories =
    UNASSIGNED: 0
    DISALLOWED: 1
    FREE_PVAL: 2
    PVALID: 3
    CONTEXTO: 4
    CONTEXTJ: 5

trie = new UnicodeTrieBuilder categories.UNASSIGNED
rangeStart = 0
previousCategory = null
previousCodepoint = null

addRange = (start, end, category) ->
    return if category is 'UNASSIGNED'

    trie.setRange parseInt(start), parseInt(end), categories[category]

for codepoint, category of data
    unless previousCategory is null or category is previousCategory
        addRange rangeStart, previousCodepoint, previousCategory
        rangeStart = codepoint

    previousCategory = category
    previousCodepoint = codepoint

addRange rangeStart, previousCodepoint, previousCategory

fs.writeFileSync __dirname + '/../data/precis.trie', trie.toBuffer()
