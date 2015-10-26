fs = require 'fs'
UnicodeTrie = require 'unicode-trie'

CodepointPropertyReader = require '../../src/unicode/CodepointPropertyReader'
InvalidCodepointError = require '../../src/error/InvalidCodepointError'
precis = require '../../src/constants'
PrecisPreparer = require '../../src/PrecisPreparer'
WidthMapper = require '../../src/unicode/WidthMapper'

describe 'PrecisPreparer', ->

    before ->
        trieData = fs.readFileSync __dirname + '/../../data/properties.trie'
        widthMappingData = JSON.parse fs.readFileSync __dirname + '/../../data/width-mapping.json'

        @trie = new UnicodeTrie trieData
        @propertyReader = new CodepointPropertyReader @trie
        @widthMapper = new WidthMapper widthMappingData

    beforeEach ->
        @subject = new PrecisPreparer @propertyReader, @widthMapper

    describe 'prepare()', ->

        it 'supports custom prepare logic', ->
            @profile = prepare: sinon.spy()
            @subject.prepare @profile, 'ab'

            sinon.assert.calledWith @profile.prepare, 'ab', @subject

        it 'supports custom pre-prepare mapping logic', ->
            passedCodepoints = [-1, -1]
            @profile =
                stringClass: precis.STRING_CLASS.FREEFORM
                prePrepareMap: (codepoints) ->
                    passedCodepoints[0] = codepoints[0]
                    passedCodepoints[1] = codepoints[1]
                    codepoints[0] = 111
                    codepoints[1] = 222

            assert.deepEqual @subject.prepare(@profile, 'ab'), [111, 222]
            assert.deepEqual passedCodepoints, [97, 98]

        it 'throws an error if the string class is not implemented', ->
            assert.throws (=> @subject.prepare stringClass: 111, ''), 'PRECIS string class not implemented.'

        describe 'for FreeformClass string class profiles', ->

            beforeEach ->
                @profile = stringClass: precis.STRING_CLASS.FREEFORM

            it 'allows characters in the FreeformClass string class', ->
                assert.deepEqual @subject.prepare(@profile, ' !'), [0x0020, 0x0021]

            it 'rejects characters outside the FreeformClass string class', ->
                assert.throws (=> @subject.prepare @profile, "\u0000"), InvalidCodepointError
                assert.throws (=> @subject.prepare @profile, "\u007F"), InvalidCodepointError
                assert.throws (=> @subject.prepare @profile, "\u00B7"), InvalidCodepointError
                assert.throws (=> @subject.prepare @profile, "\u0378"), InvalidCodepointError
                assert.throws (=> @subject.prepare @profile, "\u200C"), InvalidCodepointError

        describe 'for IdentifierClass string class profiles', ->

            beforeEach ->
                @profile = stringClass: precis.STRING_CLASS.IDENTIFIER

            it 'allows characters in the IdentifierClass string class', ->
                assert.deepEqual @subject.prepare(@profile, '!'), [0x0021]

            it 'rejects characters outside the IdentifierClass string class', ->
                assert.throws (=> @subject.prepare @profile, "\u0000"), InvalidCodepointError
                assert.throws (=> @subject.prepare @profile, "\u0020"), InvalidCodepointError
                assert.throws (=> @subject.prepare @profile, "\u007F"), InvalidCodepointError
                assert.throws (=> @subject.prepare @profile, "\u00B7"), InvalidCodepointError
                assert.throws (=> @subject.prepare @profile, "\u0378"), InvalidCodepointError
                assert.throws (=> @subject.prepare @profile, "\u200C"), InvalidCodepointError
