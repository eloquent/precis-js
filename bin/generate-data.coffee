### !pragma coverage-skip-block ###

fs = require 'fs'
UnicodeTrieBuilder = require 'unicode-trie/builder'

Precis = require '../src/constants'

log2 = Math.log2 or (n) -> Math.log(n) / Math.LN2
bits = (n) -> (log2(n) + 1) | 0

precisBits = bits Object.keys(Precis.PRECIS_CATEGORY).length - 1
bidiBits = bits Object.keys(Precis.BIDI_CLASS).length - 1

precisShift = bidiBits + 1
bidiShift = 1

codepoints = require('codepoints/parser') __dirname + '/../build/ucd'
precisData = JSON.parse fs.readFileSync __dirname + '/../build/precis.json'
trie = new UnicodeTrieBuilder()
widthMappings = []

for data in codepoints
    continue unless data?

    precisCategory = Precis.PRECIS_CATEGORY[precisData[data.code.toString()]] or 0
    bidiClass = Precis.BIDI_CLASS[data.bidiClass] or 0
    nonAsciiSpace = if data.category is 'Zs' and data.code isnt 0x20 then 1 else 0

    trie.set data.code,
        (precisCategory << precisShift) |
        (bidiClass << bidiShift) |
        nonAsciiSpace

    if data.eastAsianWidth in ['H', 'F'] and data.decomposition.length
        unless data.decomposition.length is 1
            throw new Error 'Unexpected width mapping decomposition.'

        widthMappings.push data.code, data.decomposition[0]

fs.writeFileSync __dirname + '/../data/properties.trie', trie.toBuffer()
fs.writeFileSync __dirname + '/../data/width-mapping.json', JSON.stringify widthMappings
