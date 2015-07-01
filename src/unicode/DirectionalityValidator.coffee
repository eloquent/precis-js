InvalidDirectionalityError = require '../error/InvalidDirectionalityError'
precis = require '../constants'

module.exports = class DirectionalityValidator

    constructor: (@propertyReader) ->

    validate: (codepoints) ->
        return unless codepoints.length

        state = 0
        direction = -1
        last = -1

        for codepoint in codepoints
            bidiClass = @propertyReader.bidiClass codepoint
            last = bidiClass unless bidiClass is precis.BIDI_CLASS.NSM

            switch state
                when 0 # start of string
                    switch bidiClass
                        when precis.BIDI_CLASS.L
                            direction = 0
                            state = 1
                        when precis.BIDI_CLASS.R, precis.BIDI_CLASS.AL
                            direction = 1
                            state = 2
                        else
                            throw new InvalidDirectionalityError()

                when 1 # left-to-right
                    unless bidiClass in [
                        precis.BIDI_CLASS.L
                        precis.BIDI_CLASS.EN
                        precis.BIDI_CLASS.ES
                        precis.BIDI_CLASS.CS
                        precis.BIDI_CLASS.ET
                        precis.BIDI_CLASS.ON
                        precis.BIDI_CLASS.BN
                        precis.BIDI_CLASS.NSM
                    ]
                        throw new InvalidDirectionalityError()

                when 2 # right-to-left
                    unless bidiClass in [
                        precis.BIDI_CLASS.R
                        precis.BIDI_CLASS.AL
                        precis.BIDI_CLASS.AN
                        precis.BIDI_CLASS.EN
                        precis.BIDI_CLASS.ES
                        precis.BIDI_CLASS.CS
                        precis.BIDI_CLASS.ET
                        precis.BIDI_CLASS.ON
                        precis.BIDI_CLASS.BN
                        precis.BIDI_CLASS.NSM
                    ]
                        throw new InvalidDirectionalityError()

                    state = 3 if bidiClass is precis.BIDI_CLASS.EN
                    state = 4 if bidiClass is precis.BIDI_CLASS.AN

                when 3 # right-to-left, EN seen
                    unless bidiClass in [
                        precis.BIDI_CLASS.R
                        precis.BIDI_CLASS.AL
                        precis.BIDI_CLASS.EN
                        precis.BIDI_CLASS.ES
                        precis.BIDI_CLASS.CS
                        precis.BIDI_CLASS.ET
                        precis.BIDI_CLASS.ON
                        precis.BIDI_CLASS.BN
                        precis.BIDI_CLASS.NSM
                    ]
                        throw new InvalidDirectionalityError()

                when 4 # right-to-left, AN seen
                    unless bidiClass in [
                        precis.BIDI_CLASS.R
                        precis.BIDI_CLASS.AL
                        precis.BIDI_CLASS.AN
                        precis.BIDI_CLASS.ES
                        precis.BIDI_CLASS.CS
                        precis.BIDI_CLASS.ET
                        precis.BIDI_CLASS.ON
                        precis.BIDI_CLASS.BN
                        precis.BIDI_CLASS.NSM
                    ]
                        throw new InvalidDirectionalityError()

        if direction
            unless last in [
                precis.BIDI_CLASS.R
                precis.BIDI_CLASS.AL
                precis.BIDI_CLASS.AN
                precis.BIDI_CLASS.EN
            ]
                throw new InvalidDirectionalityError()
        else
            unless last in [precis.BIDI_CLASS.L, precis.BIDI_CLASS.EN]
                throw new InvalidDirectionalityError()
