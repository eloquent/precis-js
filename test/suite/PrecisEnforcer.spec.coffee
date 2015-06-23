fs = require 'fs'
UnicodeTrie = require 'unicode-trie'
unorm = require 'unorm'
{ucs2} = require 'punycode'

CodepointPropertyReader = require '../../src/unicode/CodepointPropertyReader'
DirectionalityValidator = require '../../src/unicode/DirectionalityValidator'
InvalidCodepointError = require '../../src/error/InvalidCodepointError'
InvalidDirectionalityError = require '../../src/error/InvalidDirectionalityError'
Precis = require '../../src/index'
PrecisEnforcer = require '../../src/PrecisEnforcer'
PrecisPreparer = require '../../src/PrecisPreparer'
WidthMapper = require '../../src/unicode/WidthMapper'

describe 'PrecisEnforcer', ->

    before ->
        trieData = fs.readFileSync __dirname + '/../../data/properties.trie'
        widthMappingData = JSON.parse fs.readFileSync __dirname + '/../../data/width-mapping.json'

        trie = new UnicodeTrie trieData
        @propertyReader = new CodepointPropertyReader trie
        @preparer = new PrecisPreparer @propertyReader
        @widthMapper = new WidthMapper widthMappingData
        @directionalityValidator = new DirectionalityValidator @propertyReader

    beforeEach ->
        @subject = new PrecisEnforcer @preparer, @propertyReader, @widthMapper, unorm, @directionalityValidator

    describe 'enforce()', ->

        it 'supports custom width mapping logic', ->
            passedCodepoints = null
            @profile = stringClass: Precis.STRING_CLASS.FREEFORM, mapWidth: (codepoints) ->
                passedCodepoints = codepoints.slice()
            @subject.enforce @profile, 'ab'

            assert.deepEqual passedCodepoints, [97, 98]

        it 'supports custom case mapping logic', ->
            passedCodepoints = null
            @profile = stringClass: Precis.STRING_CLASS.FREEFORM, mapCase: (codepoints) ->
                passedCodepoints = codepoints.slice()
            @subject.enforce @profile, 'ab'

            assert.deepEqual passedCodepoints, [97, 98]

        it 'supports custom normalization logic', ->
            passedCodepoints = null
            @profile = stringClass: Precis.STRING_CLASS.FREEFORM, normalize: (codepoints) ->
                passedCodepoints = codepoints.slice()
            @subject.enforce @profile, 'ab'

            assert.deepEqual passedCodepoints, [97, 98]

        it 'supports custom directionality validation', ->
            passedCodepoints = null
            @profile = stringClass: Precis.STRING_CLASS.FREEFORM, validateDirectionality: (codepoints) ->
                passedCodepoints = codepoints.slice()
            @subject.enforce @profile, 'ab'

            assert.deepEqual passedCodepoints, [97, 98]

        it 'throws an error if the string class is not implemented', ->
            assert.throws (=> @subject.enforce stringClass: 111, ''), 'Not implemented.'

        describe 'for FreeformClass string class profiles', ->

            beforeEach ->
                @profile = stringClass: Precis.STRING_CLASS.FREEFORM

            it 'allows characters in the FreeformClass string class', ->
                assert.strictEqual @subject.enforce(@profile, ' !'), ' !'

            it 'rejects characters outside the FreeformClass string class', ->
                assert.throws (=> @subject.enforce @profile, '\u0000'), InvalidCodepointError
                assert.throws (=> @subject.enforce @profile, '\u007F'), InvalidCodepointError
                assert.throws (=> @subject.enforce @profile, '\u00B7'), InvalidCodepointError
                assert.throws (=> @subject.enforce @profile, '\u0378'), InvalidCodepointError
                assert.throws (=> @subject.enforce @profile, '\u200C'), InvalidCodepointError

        describe 'for profiles with callbacks', ->

            it 'calls the custom mapping callback', ->
                passedCodepoints = null
                passedPropertyReader = null
                @profile =
                    stringClass: Precis.STRING_CLASS.FREEFORM
                    map: (codepoints, propertyReader) ->
                        passedCodepoints = codepoints.slice()
                        passedPropertyReader = propertyReader
                @subject.enforce @profile, 'ab'

                assert.deepEqual passedCodepoints, [97, 98]
                assert.strictEqual passedPropertyReader, @propertyReader

            it 'calls the custom validation callback', ->
                passedCodepoints = null
                @profile =
                    stringClass: Precis.STRING_CLASS.FREEFORM
                    validate: (codepoints) -> passedCodepoints = codepoints.slice()
                @subject.enforce @profile, 'ab'

                assert.deepEqual passedCodepoints, [97, 98]

        describe 'profile width mapping options', ->

            it 'supports width mapping', ->
                @profile =
                    stringClass: Precis.STRING_CLASS.FREEFORM
                    widthMapping: Precis.WIDTH_MAPPING.EAW

                assert.strictEqual @subject.enforce(@profile, '\uFF61'), '\u3002'

        describe 'profile case mapping options', ->

            beforeEach ->
                @profile = stringClass: Precis.STRING_CLASS.FREEFORM

            it 'supports lowercase case mapping', ->
                @profile.caseMapping = Precis.CASE_MAPPING.LOWERCASE

                assert.strictEqual @subject.enforce(@profile, 'Ab\u0370\u0371'), 'ab\u0371\u0371'

        describe 'profile normalization options', ->

            beforeEach ->
                @profile = stringClass: Precis.STRING_CLASS.FREEFORM

            it 'supports NFC normalization', ->
                @profile.normalization = Precis.NORMALIZATION.C
                actual = @subject.enforce @profile, '\u00F6\u0307o\u0308\u0307o\u0307\u0308\u2163'
                expected = '\u00F6\u0307\u00F6\u0307\u022F\u0308\u2163'

                assert.deepEqual ucs2.decode(actual), ucs2.decode(expected)

            it 'supports NFD normalization', ->
                @profile.normalization = Precis.NORMALIZATION.D
                actual = @subject.enforce @profile, '\u00F6\u0307o\u0308\u0307o\u0307\u0308\u2163'
                expected = 'o\u0308\u0307o\u0308\u0307o\u0307\u0308\u2163'

                assert.deepEqual ucs2.decode(actual), ucs2.decode(expected)

            it 'supports NFKC normalization', ->
                @profile.normalization = Precis.NORMALIZATION.KC
                actual = @subject.enforce @profile, '\u00F6\u0307o\u0308\u0307o\u0307\u0308\u2163'
                expected = '\u00F6\u0307\u00F6\u0307\u022F\u0308IV'

                assert.deepEqual ucs2.decode(actual), ucs2.decode(expected)

            it 'supports NFKD normalization', ->
                @profile.normalization = Precis.NORMALIZATION.KD
                actual = @subject.enforce @profile, '\u00F6\u0307o\u0308\u0307o\u0307\u0308\u2163'
                expected = 'o\u0308\u0307o\u0308\u0307o\u0307\u0308IV'

                assert.deepEqual ucs2.decode(actual), ucs2.decode(expected)

        describe 'profile directionality options', ->

            it 'supports directionality validation', ->
                @profile =
                    stringClass: Precis.STRING_CLASS.FREEFORM
                    directionality: Precis.DIRECTIONALITY.BIDI

                assert.doesNotThrow => @subject.enforce @profile, 'ab'
                assert.throws (=> @subject.enforce @profile, '0'), InvalidDirectionalityError
