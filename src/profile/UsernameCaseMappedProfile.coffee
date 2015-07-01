EmptyStringError = require '../error/EmptyStringError'
precis = require '../constants'

module.exports = class UsernameCaseMappedProfile

    stringClass: precis.STRING_CLASS.IDENTIFIER
    widthMapping: precis.WIDTH_MAPPING.EAW
    caseMapping: precis.CASE_MAPPING.LOWERCASE
    normalization: precis.NORMALIZATION.C
    directionality: precis.DIRECTIONALITY.BIDI

    validate: (codepoints) ->
        throw new EmptyStringError() if codepoints.length < 1
