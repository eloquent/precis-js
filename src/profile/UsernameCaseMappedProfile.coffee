EmptyStringError = require '../error/EmptyStringError'
Precis = require '../index'

module.exports = class UsernameCaseMappedProfile

    stringClass: Precis.STRING_CLASS.IDENTIFIER
    widthMapping: true
    caseMapping: Precis.CASE_MAPPING.LOWERCASE
    normalization: Precis.NORMALIZATION.C
    checkBidi: true

    validate: (codepoints) ->
        throw new EmptyStringError() if codepoints.length < 1
