# PRECIS-JS

*A JavaScript implementation of RFC 7564 (PRECIS Framework).*

[![The most recent stable version is 0.0.0][version-image]][Semantic versioning]
[![Current build status image][build-image]][Current build status]
[![Current coverage status image][coverage-image]][Current coverage status]

[build-image]: http://img.shields.io/travis/ezzatron/precis-js/develop.svg?style=flat-square "Current build status for the develop branch"
[coverage-image]: https://img.shields.io/codecov/c/github/ezzatron/precis-js/develop.svg?style=flat "Current test coverage"
[Current build status]: https://travis-ci.org/ezzatron/precis-js
[Current coverage status]: https://coveralls.io/r/ezzatron/precis-js
[Semantic versioning]: http://semver.org/
[version-image]: http://img.shields.io/:semver-0.0.0-red.svg?style=flat-square "This project uses semantic versioning"

<!--
## Installation

Available as [NPM] package [precis-js]:

```
npm install --save precis-js
```

[NPM]: http://npmjs.org/
[precis-js]: https://www.npmjs.com/package/precis-js
-->

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
solution for handling Unicode usernames and passwords. It takes a more
sustainable approach than stringprep, because it is designed to adapt to future
versions of Unicode.

[Creative usernames and Spotify account hijacking]: https://labs.spotify.com/2013/06/18/creative-usernames/
[RFC 3454]: https://tools.ietf.org/html/rfc3454
[RFC 7564]: https://tools.ietf.org/html/rfc7564

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
Browserify bundle.

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
[Browserify]: http://browserify.org/
[String.prototype.normalize]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/normalize
[unorm]: https://github.com/walling/unorm

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
