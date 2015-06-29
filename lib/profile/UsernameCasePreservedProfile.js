// Generated by CoffeeScript 1.9.3
(function() {
  var EmptyStringError, Precis, UsernameCasePreservedProfile;

  EmptyStringError = require('../error/EmptyStringError');

  Precis = require('../constants');

  module.exports = UsernameCasePreservedProfile = (function() {
    function UsernameCasePreservedProfile() {}

    UsernameCasePreservedProfile.prototype.stringClass = Precis.STRING_CLASS.IDENTIFIER;

    UsernameCasePreservedProfile.prototype.widthMapping = Precis.WIDTH_MAPPING.EAW;

    UsernameCasePreservedProfile.prototype.caseMapping = Precis.CASE_MAPPING.NONE;

    UsernameCasePreservedProfile.prototype.normalization = Precis.NORMALIZATION.C;

    UsernameCasePreservedProfile.prototype.directionality = Precis.DIRECTIONALITY.BIDI;

    UsernameCasePreservedProfile.prototype.validate = function(codepoints) {
      if (codepoints.length < 1) {
        throw new EmptyStringError();
      }
    };

    return UsernameCasePreservedProfile;

  })();

}).call(this);