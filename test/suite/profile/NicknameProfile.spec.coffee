{ucs2} = require 'punycode'

CodepointPropertyReader = require '../../../src/CodepointPropertyReader'
NicknameProfile = require '../../../src/profile/NicknameProfile'

describe 'NicknameProfile', ->

    beforeEach ->
        @subject = new NicknameProfile()

        @propertyReader = new CodepointPropertyReader()

    describe 'map()', ->

        it 'right-trims strings', ->
            codepoints = ucs2.decode 'ab  '
            @subject.map codepoints, @propertyReader

            assert.strictEqual ucs2.encode(codepoints), 'ab'

        it 'left-trims strings', ->
            codepoints = ucs2.decode '  ab'
            @subject.map codepoints, @propertyReader

            assert.strictEqual ucs2.encode(codepoints), 'ab'

        it 'trims strings', ->
            codepoints = ucs2.decode '  ab  '
            @subject.map codepoints, @propertyReader

            assert.strictEqual ucs2.encode(codepoints), 'ab'

        it 'collapses inner whitespace', ->
            codepoints = ucs2.decode 'ab  cd  ef'
            @subject.map codepoints, @propertyReader

            assert.strictEqual ucs2.encode(codepoints), 'ab cd ef'

        it 'collapses inner whitespace and trims at the same time', ->
            codepoints = ucs2.decode '  ab  cd  ef  '
            @subject.map codepoints, @propertyReader

            assert.strictEqual ucs2.encode(codepoints), 'ab cd ef'

        it 'maps non-ASCII spaces to ASCII spaces', ->
            codepoints = ucs2.decode '\u3000ab\u3000cd\u3000ef\u3000'
            @subject.map codepoints, @propertyReader

            assert.strictEqual ucs2.encode(codepoints), 'ab cd ef'
