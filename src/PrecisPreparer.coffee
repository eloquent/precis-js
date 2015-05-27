{ucs2} = require 'punycode'

InvalidCodepointError = require './error/InvalidCodepointError'
Precis = require './index'

module.exports = class PrecisPreparer

    constructor: (@propertyReader) ->

    prepare: (profile, string) ->
        codepoints = ucs2.decode string

        switch profile.stringClass
            when Precis.STRING_CLASS.FREEFORM then @_validateFreeform codepoints
            else
                throw new Error 'Not implemented.'

        codepoints

    _validateFreeform: (codepoints) ->
        for codepoint in codepoints
            switch @propertyReader.precisCategory codepoint
                when Precis.PRECIS_CATEGORY.FREE_PVAL, \
                    Precis.PRECIS_CATEGORY.PVALID
                        continue

            throw new InvalidCodepointError "The codepoint #{codepoint} is not
                allowed in the 'FreeformClass' string class."
