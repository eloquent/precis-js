{ucs2} = require 'punycode'

Normalizer = require '../../../src/unicode/Normalizer'
Precis = require '../../../src/constants'

describe 'Normalizer', ->

    beforeEach ->
        @oldStringNormalize = String.prototype.normalize

        @unorm = sinon.spyObject 'unorm', ['nfc', 'nfd', 'nfkc', 'nfkd']
        @codepoints = [97, 98]

    afterEach ->
        String.prototype.normalize = @oldStringNormalize if @oldStringNormalize?

    it 'throws an error if no normalizer is available', ->
        delete String.prototype.normalize
        @subject = new Normalizer()

        assert.throws (=> @subject.normalize Precis.NORMALIZATION.C, @codepoints.slice()),
            'No Unicode normalizer available.'

    describe 'with ES6', ->

        beforeEach ->
            String.prototype.normalize = (form) -> "#{@ + form}"

            @subject = new Normalizer @unorm

        describe 'normalize()', ->

            it 'supports NONE normalization', ->
                actual = @subject.normalize Precis.NORMALIZATION.NONE, @codepoints.slice()

                assert.deepEqual actual, @codepoints

            it 'supports C normalization', ->
                actual = @subject.normalize Precis.NORMALIZATION.C, @codepoints.slice()

                assert.deepEqual actual, ucs2.decode 'abNFC'

            it 'supports D normalization', ->
                actual = @subject.normalize Precis.NORMALIZATION.D, @codepoints.slice()

                assert.deepEqual actual, ucs2.decode 'abNFD'

            it 'supports KC normalization', ->
                actual = @subject.normalize Precis.NORMALIZATION.KC, @codepoints.slice()

                assert.deepEqual actual, ucs2.decode 'abNFKC'

            it 'supports KD normalization', ->
                actual = @subject.normalize Precis.NORMALIZATION.KD, @codepoints.slice()

                assert.deepEqual actual, ucs2.decode 'abNFKD'

            it 'rejects unsupported normalization forms', ->
                assert.throws (=> @subject.normalize 111, []), 'Normalization form not implemented.'

    describe 'without ES6', ->

        beforeEach ->
            delete String.prototype.normalize

            @subject = new Normalizer @unorm

        describe 'normalize()', ->

            it 'supports NONE normalization', ->
                actual = @subject.normalize Precis.NORMALIZATION.NONE, @codepoints.slice()

                assert.deepEqual actual, @codepoints

            it 'supports C normalization', ->
                @unorm.nfc.returns 'cd'
                actual = @subject.normalize Precis.NORMALIZATION.C, @codepoints.slice()

                assert.deepEqual actual, [99, 100]

            it 'supports D normalization', ->
                @unorm.nfd.returns 'cd'
                actual = @subject.normalize Precis.NORMALIZATION.D, @codepoints.slice()

                assert.deepEqual actual, [99, 100]

            it 'supports KC normalization', ->
                @unorm.nfkc.returns 'cd'
                actual = @subject.normalize Precis.NORMALIZATION.KC, @codepoints.slice()

                assert.deepEqual actual, [99, 100]

            it 'supports KD normalization', ->
                @unorm.nfkd.returns 'cd'
                actual = @subject.normalize Precis.NORMALIZATION.KD, @codepoints.slice()

                assert.deepEqual actual, [99, 100]

            it 'rejects unsupported normalization forms', ->
                assert.throws (=> @subject.normalize 111, []), 'Normalization form not implemented.'
