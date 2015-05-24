fs = require 'fs'

categoryRanges = JSON.parse fs.readFileSync 'build/precis-ranges.json'
fd = fs.openSync 'src/ranges.coffee', 'w'

fs.writeSync fd, 'module.exports =\n'

for category of categoryRanges
    fs.writeSync fd, "    #{category}: ["
    first = true

    for codepoint in categoryRanges[category]
        if first
            fs.writeSync fd, codepoint
        else
            fs.writeSync fd, ",#{codepoint}"
        first = false

    fs.writeSync fd, "]\n"

fs.closeSync fd
