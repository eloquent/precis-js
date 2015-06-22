fs = require 'fs'
unorm = require 'unorm'

DirectionalityValidator = require './unicode/DirectionalityValidator'
Precis = require './prepare'
PrecisEnforcer = require './PrecisEnforcer'
WidthMapper = require './unicode/WidthMapper'

widthMappingData =
    JSON.parse fs.readFileSync __dirname + '/../data/width-mapping.json'
widthMapper = new WidthMapper widthMappingData

directionalityValidator = new DirectionalityValidator Precis.propertyReader

enforcer = new PrecisEnforcer \
    Precis.preparer,
    Precis.propertyReader,
    widthMapper,
    unorm,
    directionalityValidator

module.exports = Precis
module.exports.enforce = enforcer.enforce.bind enforcer
