/*
 *  Copyright (c) 2014 PHP Framework Interoperability Group
 *
 *  Permission is hereby granted, free of charge, to any person obtaining a copy
 *  of this software and associated documentation files (the "Software"), to deal
 *  in the Software without restriction, including without limitation the rights
 *  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 *  copies of the Software, and to permit persons to whom the Software is
 *  furnished to do so, subject to the following conditions:
 *
 *  The above copyright notice and this permission notice shall be included in
 *  all copies or substantial portions of the Software.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 *  THE SOFTWARE.
 *
 *  Portions Copyright (c) 2018-present, Facebook, Inc.
 *  All rights reserved.
 *
 *  This source code is licensed under the MIT license found in the
 *  LICENSE file in the root directory of this source tree.
 *
 */
namespace Facebook\Experimental\Http\Message;

/**
 * Value object representing a URI.
 *
 * This interface is meant to represent URIs according to RFC 3986 and to
 * provide methods for most common operations. Additional functionality for
 * working with URIs can be provided on top of the interface or externally.
 * Its primary use is for HTTP requests, but may also be used in other
 * contexts.
 *
 * Instances of this interface are considered immutable; all methods that
 * might change state MUST be implemented such that they retain the internal
 * state of the current instance and return an instance that contains the
 * changed state.
 *
 * Typically the Host header will be also be present in the request message.
 * For server-side requests, the scheme will typically be discoverable in the
 * server parameters.
 *
 * @link http://tools.ietf.org/html/rfc3986 (the URI specification)
 */
interface UriInterface {
  /**
   * Retrieve the scheme component of the URI.
   *
   * If no scheme is present, this method MUST return the empty string
   *
   * The value returned MUST be normalized to lowercase, per RFC 3986
   * Section 3.1.
   *
   * The trailing ":" character is not part of the scheme and MUST NOT be
   * added.
   *
   * @see https://tools.ietf.org/html/rfc3986#section-3.1
   * @return null|string The URI scheme.
   */
  public function getScheme(): string;

  /**
   * Retrieve the authority component of the URI.
   *
   * If no authority information is present, this method MUST return null
   *
   * The authority syntax of the URI is:
   *
   * <pre>
   * [user-info@]host[:port]
   * </pre>
   *
   * If the port component is not set or is the standard port for the current
   * scheme, it SHOULD NOT be included.
   *
   * @see https://tools.ietf.org/html/rfc3986#section-3.2
   * @return null|string The URI authority, in "[user-info@]host[:port]" format.
   */
  public function getAuthority(): string;

  /**
   * Retrieve the user information component of the URI.
   *
   * If no credentials are present, this method MUST empty strings for username
   * and password.
   *
   * @return shape A shape containing username and password
   */
  public function getUserInfo(): shape('user' => string, 'pass' => string);

  /**
   * Retrieve the host component of the URI.
   *
   * If no host is present, this method MUST return the empty string
   *
   * The value returned MUST be normalized to lowercase, per RFC 3986
   * Section 3.2.2.
   *
   * @see http://tools.ietf.org/html/rfc3986#section-3.2.2
   * @return null|string The URI host.
   */
  public function getHost(): string;

  /**
   * Retrieve the port component of the URI.
   *
   * If a port is present, and it is non-standard for the current scheme,
   * this method MUST return it as an integer. If the port is the standard port
   * used with the current scheme, this method SHOULD return null.
   *
   * If no port is present, and no scheme is present, this method MUST return
   * a null value.
   *
   * If no port is present, but a scheme is present, this method MAY return
   * the standard port for that scheme, but SHOULD return null.
   *
   * @return null|int The URI port.
   */
  public function getPort(): ?int;

  /**
   * Retrieve the path component of the URI.
   *
   * The path can either be empty or absolute (starting with a slash) or
   * rootless (not starting with a slash). Implementations MUST support all
   * three syntaxes.
   *
   * Normally, the empty path "" and absolute path "/" are considered equal as
   * defined in RFC 7230 Section 2.7.3. But this method MUST NOT automatically
   * do this normalization because in contexts with a trimmed base path, e.g.
   * the front controller, this difference becomes significant. It's the task
   * of the user to handle both "" and "/".
   *
   * The value returned MUST be percent-encoded, but MUST NOT double-encode
   * any characters. To determine what characters to encode, please refer to
   * RFC 3986, Sections 2 and 3.3.
   *
   * As an example, if the value should include a slash ("/") not intended as
   * delimiter between path segments, that value MUST be passed in encoded
   * form (e.g., "%2F") to the instance.
   *
   * @see https://tools.ietf.org/html/rfc3986#section-2
   * @see https://tools.ietf.org/html/rfc3986#section-3.3
   */
  public function getPath(): string;

  /**
   * Retrieve the encoded query string of the URI.
   *
   * If no query params or string is present, this method MUST return the empty
   * string.
   *
   * The leading "?" character is not part of the query and MUST NOT be
   * added.
   *
   * The value returned MUST be percent-encoded, but MUST NOT double-encode
   * any characters. To determine what characters to encode, please refer to
   * RFC 3986, Sections 2 and 3.4.
   *
   * As an example, if a value in a key/value pair of the query string should
   * include an ampersand ("&") not intended as a delimiter between values,
   * that value MUST be passed in encoded form (e.g., "%26") to the instance.
   *
   * @see https://tools.ietf.org/html/rfc3986#section-2
   * @see https://tools.ietf.org/html/rfc3986#section-3.4
   * @return null|string The percent-encoded query string
   */
  public function getRawQuery(): string;

  /**
   * Retrieve the query params of the URI.
   *
   * If no query params are present, this method MUST return an empty dict
   *
   * All keys and values MUST not be encoded.
   */
  public function getQuery(): dict<string, string>;

  /**
   * Retrieve the fragment component of the URI.
   *
   * If no fragment is present, this method MUST return the empty string
   *
   * The leading "#" character is not part of the fragment and MUST NOT be
   * added.
   *
   * The value returned MUST be percent-encoded, but MUST NOT double-encode
   * any characters. To determine what characters to encode, please refer to
   * RFC 3986, Sections 2 and 3.5.
   *
   * @see https://tools.ietf.org/html/rfc3986#section-2
   * @see https://tools.ietf.org/html/rfc3986#section-3.5
   */
  public function getFragment(): string;

  /**
   * Return an instance with the specified scheme.
   *
   * This method MUST retain the state of the current instance, and return
   * an instance that contains the specified scheme.
   *
   * Implementations MUST support the schemes "http" and "https" case
   * insensitively, and MAY accommodate other schemes if required.
   *
   * An empty string is equivalent to removing the scheme.
   *
   * @throws \InvalidArgumentException for invalid or unsupported schemes.
   */
  public function withScheme(string $scheme): this;

  /**
   * Return an instance with the specified user information.
   *
   * This method MUST retain the state of the current instance, and return
   * an instance that contains the specified user information.
   *
   * An empty string for the user is equivalent to removing user
   * information.
   */
  public function withUserInfo(string $user, string $password): this;

  /**
   * Return an instance with the specified host.
   *
   * This method MUST retain the state of the current instance, and return
   * an instance that contains the specified host.
   *
   * An empty string is equivalent to removing the host.
   *
   * @throws \InvalidArgumentException for invalid hostnames.
   */
  public function withHost(string $host): this;

  /**
   * Return an instance with the specified port.
   *
   * This method MUST retain the state of the current instance, and return
   * an instance that contains the specified port.
   *
   * Implementations MUST raise an exception for ports outside the
   * established TCP and UDP port ranges.
   *
   * A null value provided for the port is equivalent to removing the port
   * information.
   *
   * @throws \InvalidArgumentException for invalid ports.
   */
  public function withPort(?int $port = null): this;

  /**
   * Return an instance with the specified path.
   *
   * This method MUST retain the state of the current instance, and return
   * an instance that contains the specified path.
   *
   * The path can either be empty or absolute (starting with a slash) or
   * rootless (not starting with a slash). Implementations MUST support all
   * three syntaxes.
   *
   * If the path is intended to be domain-relative rather than path relative then
   * it must begin with a slash ("/"). Paths not starting with a slash ("/")
   * are assumed to be relative to some base path known to the application or
   * consumer.
   *
   * Users can provide both encoded and decoded path characters.
   * Implementations ensure the correct encoding as outlined in getPath().
   *
   * @throws \InvalidArgumentException for invalid paths.
   */
  public function withPath(string $path): this;

  /**
   * Return an instance with the specified query params.
   *
   * This method MUST retain the state of the current instance, and return
   * an instance that contains the specified query.
   *
   * Users must provide only unencoded (raw) query characters in order to avoid double
   * encoding.
   * Implementations ensure the correct encoding as outlined in getQuery().
   * All query params which value is set to an empty string MUST be omitted.
   * The query params dict is assumed to be empty if there are no elements in
   * it or all params have been omitted.
   *
   * An empty query params dict is equivalent to removing the query.
   *
   * @return static A new instance with the specified query.
   * @throws \InvalidArgumentException for invalid query params.
   */
  public function withQuery(dict<string, string> $query): this;

  /**
   * Return an instance with the specified query string.
   *
   * This method MUST retain the state of the current instance, and return
   * an instance that contains the specified query.
   *
   * Users must provide only unencoded (raw) query characters in order to avoid double
   * encoding.
   * Implementations ensure the correct encoding as outlined in getQuery().
   *
   * An empty query string is equivalent to removing the query.
   *
   * @return static A new instance with the specified query.
   * @throws \InvalidArgumentException for invalid query params.
   */
  public function withRawQuery(string $query): this;

  /**
   * Return an instance with the specified URI fragment.
   *
   * This method MUST retain the state of the current instance, and return
   * an instance that contains the specified URI fragment.
   *
   * Users can provide both encoded and decoded fragment characters.
   * Implementations ensure the correct encoding as outlined in getFragment().
   *
   * A null value provided for the fragment is equivalent to removing the
   * fragment.
   *
   * @param string $fragment The fragment to use with the new instance.
   * @return static A new instance with the specified fragment.
   */
  public function withFragment(string $fragment): this;

  /**
   * Return the string representation as a URI reference.
   *
   * Depending on which components of the URI are present, the resulting
   * string is either a full URI or relative reference according to RFC 3986,
   * Section 4.1. The method concatenates the various components of the URI,
   * using the appropriate delimiters:
   *
   * - If a scheme is present, it MUST be suffixed by ":".
   * - If an authority is present, it MUST be prefixed by "//".
   * - The path can be concatenated without delimiters. But there are two
   *   cases where the an exception should be thrown:
   *     - If the path is rootless and an authority is present
   *     - If the path is starting with more than one "/" and no authority is
   *       present
   * - If a query is present, it MUST be prefixed by "?".
   * - If a fragment is present, it MUST be prefixed by "#".
   *
   * @see http://tools.ietf.org/html/rfc3986#section-4.1
   */
  public function toString(): string;
}
