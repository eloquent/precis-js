EmptyStringError = require '../error/EmptyStringError'
Precis = require '../constants'

module.exports = class UsernameCasePreservedProfile

    stringClass: Precis.STRING_CLASS.IDENTIFIER
    widthMapping: Precis.WIDTH_MAPPING.EAW
    caseMapping: Precis.CASE_MAPPING.NONE
    normalization: Precis.NORMALIZATION.C
    directionality: Precis.DIRECTIONALITY.BIDI

    validate: (codepoints) ->
        throw new EmptyStringError() if codepoints.length < 1
