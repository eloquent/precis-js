Precis = require '../constants'

module.exports = class Normalizer

    constructor: (@unorm, @stringClass = String) ->
        @_isNative = @stringClass.prototype.normalize?

    normalize: (form, codepoints) ->
        return @_normalizeNative form codepoints if @_isNative
        return @_normalizeUnorm form codepoints if @unorm?

        throw new Error 'No Unicode normalizer available. The unorm package is
            required unless ES6 String.prototype.normalize is available.'

    _normalizeNative: (form, codepoints) ->
        switch form
            when Precis.NORMALIZATION.NONE
                return codepoints
            when Precis.NORMALIZATION.C
                return ucs2.decode ucs2.encode(codepoints).normalize 'NFC'
            when Precis.NORMALIZATION.D
                return ucs2.decode ucs2.encode(codepoints).normalize 'NFD'
            when Precis.NORMALIZATION.KC
                return ucs2.decode ucs2.encode(codepoints).normalize 'NFKC'
            when Precis.NORMALIZATION.KD
                return ucs2.decode ucs2.encode(codepoints).normalize 'NFKD'

        throw new Error 'Normalization form not implemented.'

    _normalizeUnorm: (form, codepoints) ->
        switch form
            when Precis.NORMALIZATION.NONE
                return codepoints
            when Precis.NORMALIZATION.C
                return ucs2.decode @normalizer.nfc ucs2.encode codepoints
            when Precis.NORMALIZATION.D
                return ucs2.decode @normalizer.nfd ucs2.encode codepoints
            when Precis.NORMALIZATION.KC
                return ucs2.decode @normalizer.nfkc ucs2.encode codepoints
            when Precis.NORMALIZATION.KD
                return ucs2.decode @normalizer.nfkd ucs2.encode codepoints

        throw new Error 'Normalization form not implemented.'
