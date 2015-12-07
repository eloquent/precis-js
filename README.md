# PRECIS-JS

*A JavaScript implementation of RFC 7564 (The PRECIS Framework).*

[![Current version image][version-image]][current version]
[![Current build status image][build-image]][current build status]
[![Current coverage status image][coverage-image]][current coverage status]

[build-image]: http://img.shields.io/travis/eloquent/precis-js/develop.svg?style=flat-square "Current build status for the develop branch"
[coverage-image]: https://img.shields.io/codecov/c/github/eloquent/precis-js/develop.svg?style=flat-square "Current test coverage for the develop branch"
[current build status]: https://travis-ci.org/eloquent/precis-js
[current coverage status]: https://codecov.io/github/eloquent/precis-js
[current version]: https://www.npmjs.com/package/precis-js
[version-image]: https://img.shields.io/npm/v/precis-js.svg?style=flat-square "This project uses semantic versioning"

## Installation

Available as [NPM] package [precis-js]:

```
npm install --save precis-js
```

[npm]: http://npmjs.org/
[precis-js]: https://www.npmjs.com/package/precis-js

## What is PRECIS?

The PRECIS Framework, otherwise known as [RFC 7564], is a system for preparing
arbitrary Unicode strings for use in strict protocols, such as authentication
systems. In a general sense, PRECIS encompasses what needs to be done to
*correctly* handle Unicode in places like usernames and passwords.

The introduction of Unicode usernames and passwords comes with its own set of
challenges, especially in terms of security and usability. Spotify faced many of
these challenges when they decided to implement Unicode usernames, and the
article [Creative usernames and Spotify account hijacking] does a good job of
explaining the scope of the problem.

The PRECIS Framework obsoletes stringprep ([RFC 3454]) the previous de-facto
solution for handling Unicode usernames and passwords. PRECIS takes a more
sustainable approach than stringprep, because it is designed to adapt to future
versions of Unicode.

[creative usernames and spotify account hijacking]: https://labs.spotify.com/2013/06/18/creative-usernames/
[rfc 3454]: https://tools.ietf.org/html/rfc3454
[rfc 7564]: https://tools.ietf.org/html/rfc7564

## Node.js usage

```js
precis = require('precis-js');
profile = new precis.profile.UsernameCaseMappedProfile();

try {
    result = precis.enforce(profile, string);
} catch (e) {
    // handle error
}
```

## Browser usage

This package supports browser usage via [Browserify] and the [brfs] transform.
However, there are important caveats that may adversely affect the size of the
Browserify bundle. See the [Modules] section for more information.

In a typical server-client scenario, it is recommended to use the *prepare only*
module provided by *PRECIS-JS*:

```js
precis = require('precis-js/prepare');
profile = new precis.profile.UsernameCaseMappedProfile();

try {
    result = precis.prepare(profile, string);
} catch (e) {
    // handle error
}
```

[brfs]: https://github.com/substack/brfs
[browserify]: http://browserify.org/
[modules]: #modules

## API

### Preparation

Preparation should be favored when the goal is simply to check whether a string
is valid for a given profile. This can be used, for example, to highlight
invalid input in a browser or other client:

```js
precis.prepare(profile, string)
```

- Where `profile` is a profile object, and `string` is the string to prepare.
- Throws an exception if `string` is invalid for `profile`.
- Available in all *PRECIS-JS* modules.
- Return type is not guaranteed, and may change in future versions without
  warning.

### Enforcement

Enforcement involves not only checking the string against the rules of a
profile, but producing a canonical result string. In a sense, enforcement is a
type of normalization, and in fact usually involves Unicode normalization as a
part of the process.

The result of enforcement is the string that should be considered the canonical
version of the input string:

```js
canonicalString = precis.enforce(profile, string)
```

- Where `profile` is a profile object, and `string` is the string to prepare.
- Returns the canonicalized string for use in comparison etc.
- Throws an exception if `string` is invalid for `profile`.
- Not available in the `precis-js/prepare` module.

### Comparison

*PRECIS-JS* does not currently implement a comparison interface. This may change
in future, but all current PRECIS profiles seem to be using simple byte-for-byte
string comparison. This can be accomplished via JavaScript's
[identity operator (===)].

[identity operator (===)]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Comparison_Operators#Identity_strict_equality_()

### Profiles

*PRECIS-JS* provides a few standard PRECIS profiles, all of which live in the
`precis.profile` module. Each profile is implemented as a class:

- `precis.profile.NicknameProfile` is an implementation of the [Nickname
  Profile] found in the draft specification [Preparation, Enforcement, and
  Comparison of Internationalized Strings Representing Nicknames].
- `precis.profile.OpaqueStringProfile` is an implementation of the [OpaqueString
  Profile] found in [RFC 7613].
- `precis.profile.UsernameCaseMappedProfile` is an implementation of the
  [UsernameCaseMapped Profile] found in [RFC 7613].
- `precis.profile.UsernameCasePreservedProfile` is an implementation of the
  [UsernameCasePreserved Profile] found in [RFC 7613].

Custom profiles are also possible, and are very simple to implement. For now,
this is left as an exercise for the reader. Please see the [included profiles]
for sample code.

[included profiles]: src/profile
[nickname profile]: https://tools.ietf.org/html/draft-ietf-precis-nickname-19#section-2
[opaquestring profile]: https://tools.ietf.org/html/rfc7613#section-4.2
[preparation, enforcement, and comparison of internationalized strings representing nicknames]: https://tools.ietf.org/html/draft-ietf-precis-nickname-19
[rfc 7613]: https://tools.ietf.org/html/rfc7613
[usernamecasemapped profile]: https://tools.ietf.org/html/rfc7613#section-3.2
[usernamecasepreserved profile]: https://tools.ietf.org/html/rfc7613#section-3.3

## Modules

*PRECIS-JS* provides several alternate versions of the primary `precis-js`
module. These are useful when code size is an issue, such as in a browser.

When using *PRECIS-JS*, the primary contributor to code size is the Unicode data
that must be included to implement the various algorithms of PRECIS. The data
used directly by PRECIS constitutes approximately **7KB**. There is no way to
avoid including this data.

In addition, unless the ECMAScript 6 [String.prototype.normalize] function is
available, *PRECIS-JS* requires the [unorm] package in order to implement the
[Enforcement] API. This adds approximately **150KB** of Unicode normalization
data. Fortunately, the [Preparation] API, which does not require this data,
should be sufficient for typical client usage.

The available modules are as follows:

- The `precis-js` module includes both the [Preparation], and [Enforcement]
  APIs, but requires [unorm], and hence produces the biggest size.
- The `precis-js/enforce` module is an alias for the `precis-js` module.
- The `precis-js/enforce-es6` module is for use when
  [String.prototype.normalize] is guaranteed to be available. It includes both
  the [Preparation], and [Enforcement] APIs, but does not require the [unorm]
  package. This is the best of both worlds, if you can use it.
- The `precis-js/prepare` module includes only the [Preparation] API, and hence
  produces the smallest possible size. Suitable for clients in a typical
  client-server scenario.

## Updating the internal data

To regenerate the *PRECIS-JS* data from the latest Unicode data, run the
included `scripts/generate-data` script. This will fetch the latest version of
the [Unicode Character Database], run [PrecisMaker], and convert the data into
an optimized format.

[precismaker]: https://github.com/stpeter/PrecisMaker
[unicode character database]: http://unicode.org/ucd/

[enforcement]: #enforcement
[preparation]: #preparation
[string.prototype.normalize]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/normalize
[unorm]: https://github.com/walling/unorm
