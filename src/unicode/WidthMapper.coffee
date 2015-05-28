module.exports = class WidthMapper

    constructor: (data) ->
        @_index = {}
        @_index[codepoint] = data[i + 1] for codepoint, i in data by 2

    map: (codepoints) ->
        i = codepoints.length - 1

        while i >= 0
            if @_index.hasOwnProperty codepoints[i]
                codepoints.splice i, 1, @_index[codepoints[i]]

            --i
