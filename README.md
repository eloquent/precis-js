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

## Node.js usage

```js
precis = require('precis-js');
profile = new precis.profile.UsernameCaseMappedProfile();

result = precis.enforce profile, 'username'
```

## Browser usage

This package supports browsers via [Browserify] and the [brfs] transform.
However, a sizable amount of Unicode data is required for full functionality.

For this reason, *PRECIS-JS* provides a choice of three modules, depending on
the required features:

- The `precis-js/prepare` module includes the `precis.prepare()` function.

[brfs]: https://github.com/substack/brfs
[Browserify]: http://browserify.org/
[String.prototype.normalize]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/normalize
[unorm]: https://github.com/walling/unorm
