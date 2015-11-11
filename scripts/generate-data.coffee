### !pragma coverage-skip-block ###

fs = require 'fs'
UnicodeTrieBuilder = require 'unicode-trie/builder'
util = require 'util'

precis = require '../src/constants'

log2 = Math.log2 or (n) -> Math.log(n) / Math.LN2
bits = (n) -> (log2(n) + 1) | 0

precisBits = bits Object.keys(precis.PRECIS_CATEGORY).length - 1
bidiBits = bits Object.keys(precis.BIDI_CLASS).length - 1

precisShift = bidiBits + 1
bidiShift = 1

console.log 'Reading PrecisMaker data'

codepoints = require('codepoints/parser') __dirname + '/../build/ucd'
precisData = JSON.parse fs.readFileSync __dirname + '/../build/precis.json'
trie = new UnicodeTrieBuilder()
widthMappings = []

for data, i in codepoints
    process.stdout.write util.format \
        "Processing codepoint %d of %d (%d%%)\r",
        i + 1,
        codepoints.length,
        (((i + 1) / codepoints.length) * 100).toFixed()

    continue unless data?

    precisCategory = precis.PRECIS_CATEGORY[precisData[data.code.toString()]] or 0
    bidiClass = precis.BIDI_CLASS[data.bidiClass] or 0
    nonAsciiSpace = if data.category is 'Zs' and data.code isnt 0x20 then 1 else 0

    trie.set data.code,
        (precisCategory << precisShift) |
        (bidiClass << bidiShift) |
        nonAsciiSpace

    if data.eastAsianWidth in ['H', 'F'] and data.decomposition.length
        unless data.decomposition.length is 1
            throw new Error 'Unexpected width mapping decomposition.'

        widthMappings.push data.code, data.decomposition[0]

console.log 'Writing trie'
fs.writeFileSync __dirname + '/../data/properties.trie', trie.toBuffer()

console.log 'Writing width mapping data'
fs.writeFileSync __dirname + '/../data/width-mapping.json', JSON.stringify widthMappings
