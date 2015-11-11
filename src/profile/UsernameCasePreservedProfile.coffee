EmptyStringError = require '../error/EmptyStringError'
precis = require '../constants'

module.exports = class UsernameCasePreservedProfile

    stringClass: precis.STRING_CLASS.IDENTIFIER
    widthMapping: precis.WIDTH_MAPPING.NONE
    caseMapping: precis.CASE_MAPPING.NONE
    normalization: precis.NORMALIZATION.C
    directionality: precis.DIRECTIONALITY.BIDI

    prePrepareMap: (codepoints, preparer) ->
        preparer.widthMapper.map codepoints

    validate: (codepoints) ->
        throw new EmptyStringError() if codepoints.length < 1
