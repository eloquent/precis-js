{ucs2} = require 'punycode'

InvalidCodepointError = require './error/InvalidCodepointError'
Precis = require './index'

module.exports = class PrecisPreparer

    constructor: (@propertyReader) ->

    prepare: (profile, string) ->
        codepoints = ucs2.decode string

        switch profile.stringClass
            when Precis.STRING_CLASS.FREEFORM then @_freeform codepoints
            when Precis.STRING_CLASS.IDENTIFIER then @_identifier codepoints
            else
                throw new Error 'Not implemented.'

        codepoints

    _freeform: (codepoints) ->
        for codepoint in codepoints
            category = @propertyReader.precisCategory codepoint

            if category isnt Precis.PRECIS_CATEGORY.PVALID and
                category isnt Precis.PRECIS_CATEGORY.FREE_PVAL
                    throw new InvalidCodepointError "The codepoint #{codepoint}
                        is not allowed in the 'FreeformClass' string class."

    _identifier: (codepoints) ->
        for codepoint in codepoints
            category = @propertyReader.precisCategory codepoint

            if category isnt Precis.PRECIS_CATEGORY.PVALID
                throw new InvalidCodepointError "The codepoint #{codepoint} is
                    not allowed in the 'IdentifierClass' string class."
