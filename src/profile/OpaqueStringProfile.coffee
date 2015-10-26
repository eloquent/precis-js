EmptyStringError = require '../error/EmptyStringError'
precis = require '../constants'

module.exports = class OpaqueStringProfile

    stringClass: precis.STRING_CLASS.FREEFORM
    widthMapping: precis.WIDTH_MAPPING.NONE
    caseMapping: precis.CASE_MAPPING.NONE
    normalization: precis.NORMALIZATION.C
    directionality: precis.DIRECTIONALITY.NONE

    map: (codepoints, enforcer) ->
        for codepoint, i in codepoints
            if enforcer.propertyReader.isNonAsciiSpace codepoint
                codepoints[i] = 0x20

    validate: (codepoints) ->
        throw new EmptyStringError() if codepoints.length < 1
