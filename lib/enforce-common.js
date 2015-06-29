// Generated by CoffeeScript 1.9.3
(function() {
  var DirectionalityValidator, Precis, PrecisEnforcer, WidthMapper, fs, ref;

  fs = require('fs');

  Precis = require('./prepare');

  ref = Precis.unicode, DirectionalityValidator = ref.DirectionalityValidator, WidthMapper = ref.WidthMapper;

  PrecisEnforcer = Precis.PrecisEnforcer;

  module.exports = function(normalizer) {
    var directionalityValidator, enforcer, widthMapper, widthMappingData;
    widthMappingData = JSON.parse(fs.readFileSync(__dirname + '/../data/width-mapping.json'));
    widthMapper = new WidthMapper(widthMappingData);
    directionalityValidator = new DirectionalityValidator(Precis.propertyReader);
    enforcer = new PrecisEnforcer(Precis.preparer, Precis.propertyReader, widthMapper, normalizer, directionalityValidator);
    Precis.enforce = enforcer.enforce.bind(enforcer);
    Precis.enforcer = enforcer;
    return Precis;
  };

}).call(this);