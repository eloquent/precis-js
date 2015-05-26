fs = require 'fs'
UnicodeTrieBuilder = require 'unicode-trie/builder'

codepoints = require('codepoints')(__dirname + '/../build/ucd')

   # 1.  The first character must be a character with Bidi property L, R,
   #     or AL.  If it has the R or AL property, it is an RTL label; if it
   #     has the L property, it is an LTR label.

   # 2.  In an RTL label, only characters with the Bidi properties R, AL,
   #     AN, EN, ES, CS, ET, ON, BN, or NSM are allowed.

   # 3.  In an RTL label, the end of the label must be a character with
   #     Bidi property R, AL, EN, or AN, followed by zero or more
   #     characters with Bidi property NSM.

   # 4.  In an RTL label, if an EN is present, no AN may be present, and
   #     vice versa.

   # 5.  In an LTR label, only characters with the Bidi properties L, EN,
   #     ES, CS, ET, ON, BN, or NSM are allowed.

   # 6.  In an LTR label, the end of the label must be a character with
   #     Bidi property L or EN, followed by zero or more characters with
   #     Bidi property NSM.

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

widthMappings = []
trie = new UnicodeTrieBuilder bidiClasses.OTHER
rangeStart = 0
previousClass = null
previousCodepoint = null

addRange = (start, end, bidiClass) ->
    return unless bidiClasses[bidiClass]?

    trie.setRange parseInt(start), parseInt(end), bidiClasses[bidiClass]

for data in codepoints
    continue unless data?

    if (data.eastAsianWidth is 'H' or data.eastAsianWidth is 'F') and
        data.decomposition.length
            widthMappings.push data.code, data.decomposition

    unless previousClass is null or data.bidiClass is previousClass
        addRange rangeStart, previousCodepoint, previousClass
        rangeStart = data.code

    previousClass = data.bidiClass
    previousCodepoint = data.code

addRange rangeStart, previousCodepoint, previousClass

fs.writeFileSync __dirname + '/../data/bidi.trie', trie.toBuffer()
fs.writeFileSync __dirname + '/../data/eaw.json', JSON.stringify widthMappings
