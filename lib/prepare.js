// Generated by CoffeeScript 1.9.3
(function() {
  var CodepointPropertyReader, Precis, PrecisEnforcer, PrecisPreparer, UnicodeTrie, fs, preparer, propertyReader, trie, trieData;

  fs = require('fs');

  UnicodeTrie = require('unicode-trie');

  CodepointPropertyReader = require('./unicode/CodepointPropertyReader');

  Precis = require('./constants');

  PrecisEnforcer = require('./PrecisEnforcer');

  PrecisPreparer = require('./PrecisPreparer');

  trieData = fs.readFileSync(__dirname + '/../data/properties.trie');

  trie = new UnicodeTrie(trieData);

  propertyReader = new CodepointPropertyReader(trie);

  preparer = new PrecisPreparer(propertyReader);

  module.exports = Precis;

  module.exports.prepare = preparer.prepare.bind(preparer);

  module.exports.preparer = preparer;

  module.exports.propertyReader = propertyReader;

  module.exports.PrecisEnforcer = PrecisEnforcer;

  module.exports.PrecisPreparer = PrecisPreparer;

  module.exports.error = {
    EmptyStringError: require('./error/EmptyStringError'),
    InvalidCodepointError: require('./error/InvalidCodepointError'),
    InvalidDirectionalityError: require('./error/InvalidDirectionalityError')
  };

  module.exports.profile = {
    NicknameProfile: require('./profile/NicknameProfile'),
    OpaqueStringProfile: require('./profile/OpaqueStringProfile'),
    UsernameCaseMappedProfile: require('./profile/UsernameCaseMappedProfile'),
    UsernameCasePreservedProfile: require('./profile/UsernameCasePreservedProfile')
  };

  module.exports.unicode = {
    CodepointPropertyReader: CodepointPropertyReader,
    DirectionalityValidator: require('./unicode/DirectionalityValidator'),
    Normalizer: require('./unicode/Normalizer'),
    WidthMapper: require('./unicode/WidthMapper')
  };

}).call(this);