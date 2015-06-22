fs = require 'fs'
unorm = require 'unorm'

Precis = require './prepare'
{DirectionalityValidator, WidthMapper} = Precis.unicode
{PrecisEnforcer} = Precis

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

module.exports.enforcer = enforcer
