Hack HTTP Request and Response Interfaces
=========================================

This project aims to create standard request and response interfaces for Hack,
using [PSR-7](http://www.php-fig.org/psr/psr-7/) as a starting point.

This project is currently *highly experimental* - all APIs are subject to
change, and we welcome discussion and feedback.

## Motivation

PSR-7 was designed for PHP, not Hack, and some descisions do not fit smoothly
with Hack's type system.

We would like agreement on a standardized interface before releasing v1.0 of
several libraries that could and should use this.

## Requirements

HHVM 3.24 and above.

## License

By contributing to Hack HTTP Request and Response Interfaces, you agree that your contributions will be licensed
under the LICENSE file in the root directory of this source tree.
