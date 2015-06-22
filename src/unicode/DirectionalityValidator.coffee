InvalidDirectionalityError = require '../error/InvalidDirectionalityError'
Precis = require '../constants'

module.exports = class DirectionalityValidator

    constructor: (@propertyReader) ->

    validate: (codepoints) ->
        return unless codepoints.length

        state = 0
        direction = -1
        last = -1

        for codepoint in codepoints
            bidiClass = @propertyReader.bidiClass codepoint
            last = bidiClass unless bidiClass is Precis.BIDI_CLASS.NSM

            switch state
                when 0 # start of string
                    switch bidiClass
                        when Precis.BIDI_CLASS.L
                            direction = 0
                            state = 1
                        when Precis.BIDI_CLASS.R, Precis.BIDI_CLASS.AL
                            direction = 1
                            state = 2
                        else
                            throw new InvalidDirectionalityError()

                when 1 # left-to-right
                    unless bidiClass in [
                        Precis.BIDI_CLASS.L
                        Precis.BIDI_CLASS.EN
                        Precis.BIDI_CLASS.ES
                        Precis.BIDI_CLASS.CS
                        Precis.BIDI_CLASS.ET
                        Precis.BIDI_CLASS.ON
                        Precis.BIDI_CLASS.BN
                        Precis.BIDI_CLASS.NSM
                    ]
                        throw new InvalidDirectionalityError()

                when 2 # right-to-left
                    unless bidiClass in [
                        Precis.BIDI_CLASS.R
                        Precis.BIDI_CLASS.AL
                        Precis.BIDI_CLASS.AN
                        Precis.BIDI_CLASS.EN
                        Precis.BIDI_CLASS.ES
                        Precis.BIDI_CLASS.CS
                        Precis.BIDI_CLASS.ET
                        Precis.BIDI_CLASS.ON
                        Precis.BIDI_CLASS.BN
                        Precis.BIDI_CLASS.NSM
                    ]
                        throw new InvalidDirectionalityError()

                    state = 3 if bidiClass is Precis.BIDI_CLASS.EN
                    state = 4 if bidiClass is Precis.BIDI_CLASS.AN

                when 3 # right-to-left, EN seen
                    unless bidiClass in [
                        Precis.BIDI_CLASS.R
                        Precis.BIDI_CLASS.AL
                        Precis.BIDI_CLASS.EN
                        Precis.BIDI_CLASS.ES
                        Precis.BIDI_CLASS.CS
                        Precis.BIDI_CLASS.ET
                        Precis.BIDI_CLASS.ON
                        Precis.BIDI_CLASS.BN
                        Precis.BIDI_CLASS.NSM
                    ]
                        throw new InvalidDirectionalityError()

                when 4 # right-to-left, AN seen
                    unless bidiClass in [
                        Precis.BIDI_CLASS.R
                        Precis.BIDI_CLASS.AL
                        Precis.BIDI_CLASS.AN
                        Precis.BIDI_CLASS.ES
                        Precis.BIDI_CLASS.CS
                        Precis.BIDI_CLASS.ET
                        Precis.BIDI_CLASS.ON
                        Precis.BIDI_CLASS.BN
                        Precis.BIDI_CLASS.NSM
                    ]
                        throw new InvalidDirectionalityError()

        if direction
            unless last in [
                Precis.BIDI_CLASS.R
                Precis.BIDI_CLASS.AL
                Precis.BIDI_CLASS.AN
                Precis.BIDI_CLASS.EN
            ]
                throw new InvalidDirectionalityError()
        else
            unless last in [Precis.BIDI_CLASS.L, Precis.BIDI_CLASS.EN]
                throw new InvalidDirectionalityError()
