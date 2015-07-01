precis = require '../constants'
{ucs2} = require 'punycode'

module.exports = class Normalizer

    constructor: (@unorm) ->
        @_isNative = String.prototype.normalize?

    normalize: (form, codepoints) ->
        return codepoints if form is precis.NORMALIZATION.NONE
        return @_normalizeNative form, codepoints if @_isNative
        return @_normalizeUnorm form, codepoints if @unorm?

        throw new Error 'No Unicode normalizer available. The unorm package is
            required unless ES6 String.prototype.normalize is available.'

    _normalizeNative: (form, codepoints) ->
        string = ucs2.encode codepoints

        switch form
            when precis.NORMALIZATION.C
                string = string.normalize 'NFC'
            when precis.NORMALIZATION.D
                string = string.normalize 'NFD'
            when precis.NORMALIZATION.KC
                string = string.normalize 'NFKC'
            when precis.NORMALIZATION.KD
                string = string.normalize 'NFKD'
            else
                throw new Error 'Normalization form not implemented.'

        ucs2.decode string

    _normalizeUnorm: (form, codepoints) ->
        string = ucs2.encode codepoints

        switch form
            when precis.NORMALIZATION.C
                string = @unorm.nfc string
            when precis.NORMALIZATION.D
                string = @unorm.nfd string
            when precis.NORMALIZATION.KC
                string = @unorm.nfkc string
            when precis.NORMALIZATION.KD
                string = @unorm.nfkd string
            else
                throw new Error 'Normalization form not implemented.'

        ucs2.decode string
