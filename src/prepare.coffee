fs = require 'fs'
UnicodeTrie = require 'unicode-trie'

CodepointPropertyReader = require './unicode/CodepointPropertyReader'
precis = require './constants'
PrecisEnforcer = require './PrecisEnforcer'
PrecisPreparer = require './PrecisPreparer'
WidthMapper = require './unicode/WidthMapper'

trieData = fs.readFileSync __dirname + '/../data/properties.trie'
trie = new UnicodeTrie trieData

propertyReader = new CodepointPropertyReader trie
widthMappingData =
    JSON.parse fs.readFileSync __dirname + '/../data/width-mapping.json'
widthMapper = new WidthMapper widthMappingData
preparer = new PrecisPreparer propertyReader, widthMapper

module.exports = precis

module.exports.prepare = preparer.prepare.bind preparer

module.exports.preparer = preparer
module.exports.propertyReader = propertyReader

module.exports.PrecisEnforcer = PrecisEnforcer
module.exports.PrecisPreparer = PrecisPreparer

module.exports.error =
    EmptyStringError: require './error/EmptyStringError'
    InvalidCodepointError: require './error/InvalidCodepointError'
    InvalidDirectionalityError: require './error/InvalidDirectionalityError'

module.exports.profile =
    NicknameProfile: require './profile/NicknameProfile'
    OpaqueStringProfile: require './profile/OpaqueStringProfile'
    UsernameCaseMappedProfile: require './profile/UsernameCaseMappedProfile'
    UsernameCasePreservedProfile:
        require './profile/UsernameCasePreservedProfile'

module.exports.unicode =
    CodepointPropertyReader: CodepointPropertyReader
    DirectionalityValidator: require './unicode/DirectionalityValidator'
    Normalizer: require './unicode/Normalizer'
    WidthMapper: WidthMapper
