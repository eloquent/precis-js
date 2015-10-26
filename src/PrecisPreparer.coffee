{ucs2} = require 'punycode'

InvalidCodepointError = require './error/InvalidCodepointError'
precis = require './constants'

module.exports = class PrecisPreparer

    constructor: (@propertyReader) ->

    prepare: (profile, string) ->
        return profile.prepare string, @ if typeof profile.prepare is 'function'

        codepoints = ucs2.decode string
        @validateStringClass profile.stringClass, codepoints

        codepoints

    validateStringClass: (stringClass, codepoints) ->
        switch stringClass
            when precis.STRING_CLASS.FREEFORM then @_freeform codepoints
            when precis.STRING_CLASS.IDENTIFIER then @_identifier codepoints
            else
                throw new Error 'PRECIS string class not implemented.'

        codepoints

    _freeform: (codepoints) ->
        for codepoint in codepoints
            category = @propertyReader.precisCategory codepoint
            isValid = category is precis.PRECIS_CATEGORY.PVALID or
                category is precis.PRECIS_CATEGORY.FREE_PVAL

            unless isValid
                throw new InvalidCodepointError "The codepoint #{codepoint} is
                    not allowed in the 'FreeformClass' string class."

    _identifier: (codepoints) ->
        for codepoint in codepoints
            category = @propertyReader.precisCategory codepoint

            if category isnt precis.PRECIS_CATEGORY.PVALID
                throw new InvalidCodepointError "The codepoint #{codepoint} is
                    not allowed in the 'IdentifierClass' string class."
