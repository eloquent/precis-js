fs = require 'fs'

WidthMapper = require '../../../src/unicode/WidthMapper'

describe 'WidthMapper', ->

    before ->
        @data = JSON.parse fs.readFileSync __dirname + '/../../../data/width-mapping.json'

    beforeEach ->
        @subject = new WidthMapper @data

    describe 'map()', ->

        it 'maps halfwidth codepoints to their decompositions', ->
            actual = [0xFF61, 0xFF67, 0xFFA1, 0xFFDC]
            expected = [0x3002, 0x30A1, 0x3131, 0x3163]
            @subject.map actual

            assert.deepEqual actual, expected

        it 'maps fullwidth codepoints to their decompositions', ->
            actual = [0xFF01, 0xFF10, 0xFF21, 0xFFE0, 0xFFE6]
            expected = [0x0021, 0x0030, 0x0041, 0x00A2, 0x20A9]
            @subject.map actual

            assert.deepEqual actual, expected

        it 'does not map other codepoints', ->
            actual = [0, 0xFEFF]
            expected = [0, 0xFEFF]
            @subject.map actual

            assert.deepEqual actual, expected
