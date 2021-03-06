// Generated by CoffeeScript 1.10.0
(function() {
  var EmptyStringError, UsernameCaseMappedProfile, precis;

  EmptyStringError = require('../error/EmptyStringError');

  precis = require('../constants');

  module.exports = UsernameCaseMappedProfile = (function() {
    function UsernameCaseMappedProfile() {}

    UsernameCaseMappedProfile.prototype.stringClass = precis.STRING_CLASS.IDENTIFIER;

    UsernameCaseMappedProfile.prototype.widthMapping = precis.WIDTH_MAPPING.NONE;

    UsernameCaseMappedProfile.prototype.caseMapping = precis.CASE_MAPPING.LOWERCASE;

    UsernameCaseMappedProfile.prototype.normalization = precis.NORMALIZATION.C;

    UsernameCaseMappedProfile.prototype.directionality = precis.DIRECTIONALITY.BIDI;

    UsernameCaseMappedProfile.prototype.prePrepareMap = function(codepoints, preparer) {
      return preparer.widthMapper.map(codepoints);
    };

    UsernameCaseMappedProfile.prototype.validate = function(codepoints) {
      if (codepoints.length < 1) {
        throw new EmptyStringError();
      }
    };

    return UsernameCaseMappedProfile;

  })();

}).call(this);
