EmptyStringError = require '../error/EmptyStringError'
precis = require '../constants'

module.exports = class NicknameProfile

    stringClass: precis.STRING_CLASS.FREEFORM
    widthMapping: precis.WIDTH_MAPPING.NONE
    caseMapping: precis.CASE_MAPPING.LOWERCASE
    normalization: precis.NORMALIZATION.KC
    directionality: precis.DIRECTIONALITY.NONE

    map: (codepoints, propertyReader) ->
        i = codepoints.length - 1
        last = i
        state = 0

        while i >= 0
            codepoints[i] = 0x20 if propertyReader.isNonAsciiSpace codepoints[i]

            switch state
                when 0 # end of string
                    if codepoints[i] is 0x20
                        codepoints.splice i, 1
                    else
                        last = i
                        state = 1

                when 1 # non-space seen
                    if codepoints[i] is 0x20
                        state = 2
                    else
                        last = i

                when 2 # previous was space
                    if codepoints[i] isnt 0x20
                        codepoints.splice i + 1, last - i - 2 if last > i + 2

                        last = i
                        state = 1

            --i

        codepoints.splice 0, last if last > 0

    validate: (codepoints) ->
        throw new EmptyStringError() if codepoints.length < 1
