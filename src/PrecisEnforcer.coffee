Precis = require './constants'
{ucs2} = require 'punycode'

module.exports = class PrecisEnforcer

    constructor: (
        @preparer
        @propertyReader
        @widthMapper
        @normalizer
        @directionalityValidator
    ) ->

    enforce: (profile, string) ->
        codepoints = @preparer.prepare profile, string

        if typeof profile.mapWidth is 'function'
            profile.mapWidth codepoints
        else if profile.widthMapping is Precis.WIDTH_MAPPING.EAW
            @widthMapper.map codepoints

        if typeof profile.map is 'function'
            profile.map codepoints, @propertyReader

        if typeof profile.mapCase is 'function'
            profile.mapCase codepoints
        else if profile.caseMapping is Precis.CASE_MAPPING.LOWERCASE
            codepoints = ucs2.decode ucs2.encode(codepoints).toLowerCase()

        if typeof profile.normalize is 'function'
            profile.normalize codepoints
        else
            codepoints = @normalizer.normalize profile.normalization, codepoints

        if typeof profile.validateDirectionality is 'function'
            profile.validateDirectionality codepoints
        else if profile.directionality is Precis.DIRECTIONALITY.BIDI
            @directionalityValidator.validate codepoints

        profile.validate codepoints if typeof profile.validate is 'function'

        ucs2.encode codepoints
