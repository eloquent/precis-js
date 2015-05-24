global.chai = require 'chai'
global.sinon = require 'sinon'
global.assert = chai.assert

sinon.spyObject = (name, methods) ->
    object = name: name
    object[method] = sinon.stub() for method in methods

    object
