module.exports = class CodepointCategorizer

    constructor: (ranges = require './ranges') ->
        @_index = []

        for category of ranges
            codepoints = ranges[category]
            i = 0

            while i < codepoints.length
                @_index.push [codepoints[i], codepoints[i + 1], category]

                i += 2

    codepointCategory: (codepoint) ->
        for [start, end, category] in @_index
            return category if codepoint >= start and codepoint <= end

        return 'UNASSIGNED'

