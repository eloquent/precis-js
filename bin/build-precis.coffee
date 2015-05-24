fs = require 'fs'
data = JSON.parse fs.readFileSync 'build/precis.json'

ranges = {}
rangeStart = 0
previousCategory = null
previousCodepoint = null

addRange = (category, start, end) ->
    return if category is 'UNASSIGNED'

    unless ranges[category]?
        ranges[category] = []

    ranges[category].push parseInt(start), parseInt(end)

for codepoint, category of data
    unless previousCategory is null or category is previousCategory
        addRange previousCategory, rangeStart, previousCodepoint
        rangeStart = codepoint

    previousCategory = category
    previousCodepoint = codepoint

addRange previousCategory, rangeStart, previousCodepoint

fs.writeFileSync 'build/precis-ranges.json', JSON.stringify ranges
