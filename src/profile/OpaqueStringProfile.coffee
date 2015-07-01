EmptyStringError = require '../error/EmptyStringError'
precis = require '../constants'

module.exports = class OpaqueStringProfile

    stringClass: precis.STRING_CLASS.FREEFORM
    widthMapping: precis.WIDTH_MAPPING.NONE
    caseMapping: precis.CASE_MAPPING.NONE
    normalization: precis.NORMALIZATION.C
    directionality: precis.DIRECTIONALITY.NONE

    map: (codepoints, propertyReader) ->
        for codepoint, i in codepoints
            codepoints[i] = 0x20 if propertyReader.isNonAsciiSpace codepoint

    validate: (codepoints) ->
        throw new EmptyStringError() if codepoints.length < 1
