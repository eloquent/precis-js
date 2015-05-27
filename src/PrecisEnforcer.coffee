Precis = require './index'
{ucs2} = require 'punycode'

module.exports = class PrecisEnforcer

    constructor: (@preparer, @normalizer) ->

    enforce: (profile, string) ->
        codepoints = @preparer.prepare profile, string
        profile.map? codepoints

        switch profile.caseMapping
            when Precis.CASE_MAPPING.LOWERCASE
                codepoints = ucs2.decode ucs2.encode(codepoints).toLowerCase()

        switch profile.normalization
            when Precis.NORMALIZATION.C
                codepoints = ucs2.decode @normalizer.nfc ucs2.encode codepoints
            when Precis.NORMALIZATION.D
                codepoints = ucs2.decode @normalizer.nfd ucs2.encode codepoints
            when Precis.NORMALIZATION.KC
                codepoints = ucs2.decode @normalizer.nfkc ucs2.encode codepoints
            when Precis.NORMALIZATION.KD
                codepoints = ucs2.decode @normalizer.nfkd ucs2.encode codepoints

        profile.validate? codepoints

        ucs2.encode codepoints
