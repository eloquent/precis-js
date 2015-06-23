Precis = require '../constants'
{ucs2} = require 'punycode'

module.exports = class Normalizer

    constructor: (@unorm) ->
        @_isNative = String.prototype.normalize?

    normalize: (form, codepoints) ->
        return codepoints if form is Precis.NORMALIZATION.NONE
        return @_normalizeNative form, codepoints if @_isNative
        return @_normalizeUnorm form, codepoints if @unorm?

        throw new Error 'No Unicode normalizer available. The unorm package is
            required unless ES6 String.prototype.normalize is available.'

    _normalizeNative: (form, codepoints) ->
        string = ucs2.encode codepoints

        switch form
            when Precis.NORMALIZATION.C
                string = string.normalize 'NFC'
            when Precis.NORMALIZATION.D
                string = string.normalize 'NFD'
            when Precis.NORMALIZATION.KC
                string = string.normalize 'NFKC'
            when Precis.NORMALIZATION.KD
                string = string.normalize 'NFKD'
            else
                throw new Error 'Normalization form not implemented.'

        ucs2.decode string

    _normalizeUnorm: (form, codepoints) ->
        string = ucs2.encode codepoints

        switch form
            when Precis.NORMALIZATION.C
                string = @unorm.nfc string
            when Precis.NORMALIZATION.D
                string = @unorm.nfd string
            when Precis.NORMALIZATION.KC
                string = @unorm.nfkc string
            when Precis.NORMALIZATION.KD
                string = @unorm.nfkd string
            else
                throw new Error 'Normalization form not implemented.'

        ucs2.decode string
