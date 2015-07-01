fs = require 'fs'

precis = require './prepare'
{DirectionalityValidator, WidthMapper} = precis.unicode
{PrecisEnforcer} = precis

module.exports = (normalizer) ->
    widthMappingData =
        JSON.parse fs.readFileSync __dirname + '/../data/width-mapping.json'
    widthMapper = new WidthMapper widthMappingData
    directionalityValidator = new DirectionalityValidator precis.propertyReader

    enforcer = new PrecisEnforcer \
        precis.preparer,
        precis.propertyReader,
        widthMapper,
        normalizer,
        directionalityValidator

    precis.enforce = enforcer.enforce.bind enforcer
    precis.enforcer = enforcer

    precis
