// Generated by CoffeeScript 1.10.0
(function() {
  var Normalizer, precis, ucs2;

  precis = require('../constants');

  ucs2 = require('punycode').ucs2;

  module.exports = Normalizer = (function() {
    function Normalizer(unorm) {
      this.unorm = unorm;
      this._isNative = String.prototype.normalize != null;
    }

    Normalizer.prototype.normalize = function(form, codepoints) {
      if (form === precis.NORMALIZATION.NONE) {
        return codepoints;
      }
      if (this._isNative) {
        return this._normalizeNative(form, codepoints);
      }
      if (this.unorm != null) {
        return this._normalizeUnorm(form, codepoints);
      }
      throw new Error('No Unicode normalizer available. The unorm package is required unless ES6 String.prototype.normalize is available.');
    };

    Normalizer.prototype._normalizeNative = function(form, codepoints) {
      var string;
      string = ucs2.encode(codepoints);
      switch (form) {
        case precis.NORMALIZATION.C:
          string = string.normalize('NFC');
          break;
        case precis.NORMALIZATION.D:
          string = string.normalize('NFD');
          break;
        case precis.NORMALIZATION.KC:
          string = string.normalize('NFKC');
          break;
        case precis.NORMALIZATION.KD:
          string = string.normalize('NFKD');
          break;
        default:
          throw new Error('Normalization form not implemented.');
      }
      return ucs2.decode(string);
    };

    Normalizer.prototype._normalizeUnorm = function(form, codepoints) {
      var string;
      string = ucs2.encode(codepoints);
      switch (form) {
        case precis.NORMALIZATION.C:
          string = this.unorm.nfc(string);
          break;
        case precis.NORMALIZATION.D:
          string = this.unorm.nfd(string);
          break;
        case precis.NORMALIZATION.KC:
          string = this.unorm.nfkc(string);
          break;
        case precis.NORMALIZATION.KD:
          string = this.unorm.nfkd(string);
          break;
        default:
          throw new Error('Normalization form not implemented.');
      }
      return ucs2.decode(string);
    };

    return Normalizer;

  })();

}).call(this);
