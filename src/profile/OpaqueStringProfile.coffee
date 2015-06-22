EmptyStringError = require '../error/EmptyStringError'
Precis = require '../constants'

module.exports = class OpaqueStringProfile

    stringClass: Precis.STRING_CLASS.FREEFORM
    widthMapping: Precis.WIDTH_MAPPING.NONE
    caseMapping: Precis.CASE_MAPPING.NONE
    normalization: Precis.NORMALIZATION.C
    directionality: Precis.DIRECTIONALITY.NONE

    map: (codepoints, propertyReader) ->
        for codepoint, i in codepoints
            codepoints[i] = 0x20 if propertyReader.isNonAsciiSpace codepoint

    validate: (codepoints) ->
        throw new EmptyStringError() if codepoints.length < 1
