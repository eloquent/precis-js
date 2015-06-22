fs = require 'fs'
UnicodeTrie = require 'unicode-trie'

CodepointPropertyReader = require './unicode/CodepointPropertyReader'
constants = require './constants'
PrecisPreparer = require './PrecisPreparer'

trieData = fs.readFileSync __dirname + '/../data/properties.trie'
trie = new UnicodeTrie trieData

propertyReader = new CodepointPropertyReader trie
preparer = new PrecisPreparer propertyReader

module.exports = constants
module.exports.prepare = preparer.prepare.bind preparer
module.exports._propertyReader = propertyReader
