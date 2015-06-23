fs = require 'fs'

Precis = require './prepare'
{DirectionalityValidator, WidthMapper} = Precis.unicode
{PrecisEnforcer} = Precis

module.exports = (normalizer) ->
    widthMappingData =
        JSON.parse fs.readFileSync __dirname + '/../data/width-mapping.json'
    widthMapper = new WidthMapper widthMappingData
    directionalityValidator = new DirectionalityValidator Precis.propertyReader

    enforcer = new PrecisEnforcer \
        Precis.preparer,
        Precis.propertyReader,
        widthMapper,
        normalizer,
        directionalityValidator

    Precis.enforce = enforcer.enforce.bind enforcer
    Precis.enforcer = enforcer

    Precis
