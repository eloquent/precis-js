unorm = require 'unorm'

enforceCommon = require './enforce-common'
Normalizer = require './unicode/Normalizer'

module.exports = enforceCommon new Normalizer unorm
