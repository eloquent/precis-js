InvalidCodepointError = require '../../src/error/InvalidCodepointError'
Precis = require '../../src/prepare'

describe 'Precis (prepare only)', ->

    describe 'prepare()', ->

        it 'throws an error if the string class is not implemented', ->
            assert.throws (=> Precis.prepare stringClass: 111, ''), 'Not implemented.'

        describe 'for FreeformClass string class profiles', ->

            beforeEach ->
                @profile = stringClass: Precis.STRING_CLASS.FREEFORM

            it 'allows characters in the FreeformClass string class', ->
                assert.deepEqual Precis.prepare(@profile, ' !'), [0x0020, 0x0021]

            it 'rejects characters outside the FreeformClass string class', ->
                assert.throws (=> Precis.prepare @profile, "\u0000"), InvalidCodepointError
                assert.throws (=> Precis.prepare @profile, "\u007F"), InvalidCodepointError
                assert.throws (=> Precis.prepare @profile, "\u00B7"), InvalidCodepointError
                assert.throws (=> Precis.prepare @profile, "\u0378"), InvalidCodepointError
                assert.throws (=> Precis.prepare @profile, "\u200C"), InvalidCodepointError

        describe 'for IdentifierClass string class profiles', ->

            beforeEach ->
                @profile = stringClass: Precis.STRING_CLASS.IDENTIFIER

            it 'allows characters in the IdentifierClass string class', ->
                assert.deepEqual Precis.prepare(@profile, '!'), [0x0021]

            it 'rejects characters outside the IdentifierClass string class', ->
                assert.throws (=> Precis.prepare @profile, "\u0000"), InvalidCodepointError
                assert.throws (=> Precis.prepare @profile, "\u0020"), InvalidCodepointError
                assert.throws (=> Precis.prepare @profile, "\u007F"), InvalidCodepointError
                assert.throws (=> Precis.prepare @profile, "\u00B7"), InvalidCodepointError
                assert.throws (=> Precis.prepare @profile, "\u0378"), InvalidCodepointError
                assert.throws (=> Precis.prepare @profile, "\u200C"), InvalidCodepointError
