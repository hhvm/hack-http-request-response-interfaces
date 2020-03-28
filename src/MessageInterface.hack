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
 * HTTP messages consist of requests from a client to a server and responses
 * from a server to a client. This interface defines the methods common to
 * each.
 *
 * Messages are considered immutable; all methods that might change state MUST
 * be implemented such that they retain the internal state of the current
 * message and return an instance that contains the changed state.
 *
 * @link http://www.ietf.org/rfc/rfc7230.txt
 * @link http://www.ietf.org/rfc/rfc7231.txt
 */
interface MessageInterface {
  /**
   * Retrieves the HTTP protocol version as a string.
   *
   * The string MUST contain only the HTTP version number (e.g., "1.1", "1.0").
   */
  public function getProtocolVersion(): string;

  /**
   * Return an instance with the specified HTTP protocol version.
   *
   * The version string MUST contain only the HTTP version number (e.g.,
   * "1.1", "1.0").
   *
   * This method MUST be implemented in such a way as to retain the
   * immutability of the message, and MUST return an instance that has the
   * new protocol version.
   */
  public function withProtocolVersion(string $version): this;

  /**
   * Retrieves all message header values.
   *
   * The keys represent the header name as it will be sent over the wire, and
   * each value is a vec of strings associated with the header.
   *
   * While header names are not case-sensitive, getHeaders() will preserve the
   * exact case in which headers were originally specified.
   *
   * Implementations *MUST* return header names of the form `Foo-Bar`, but keys
   * should be considered case-insensitive.
   *
   * Implementations *MAY* choose to normalize some headers in different ways,
   * for example, `ETag` instead of `Etag`.
   */
  public function getHeaders(): dict<string, vec<string>>;

  /**
   * Checks if a header exists by the given case-insensitive name.
   *
   * @param string $name Case-insensitive header field name, in the same form
   *     as HTTP itself - e.g. `Content-Length`, not `CONTENT_LENGTH`.
   * @return Returns true if any header names match the given header
   *     name using a case-insensitive string comparison. Returns false if
   *     no matching header name is found in the message.
   */
  public function hasHeader(string $name): bool;

  /**
   * Retrieves a message header value by the given case-insensitive name.
   *
   * This method returns an array of all the header values of the given
   * case-insensitive header name.
   *
   * If the header does not appear in the message, this method MUST return an
   * empty array.
   *
   * @param string $name Case-insensitive header field name, in the same form
   *   as HTTP itself - e.g. `Content-Length`, not `CONTENT_LENGTH`
   */
  public function getHeader(string $name): vec<string>;

  /**
   * Retrieves a comma-separated string of the values for a single header.
   *
   * This method returns all of the header values of the given
   * case-insensitive header name as a string concatenated together using
   * a comma.
   *
   * NOTE: Not all header values may be appropriately represented using
   * comma concatenation. For such headers, use getHeader() instead
   * and supply your own delimiter when concatenating.
   *
   * If the header does not appear in the message, this method MUST return
   * an empty string.
   *
   * @param string $name Case-insensitive header field name, in the same form
   *    as HTTP itself - for example, `Content-Length`, not `CONTENT_LENGTH`
   * @return string A string of values as provided for the given header
   *    concatenated together using a comma. If the header does not appear in
   *    the message, this method MUST return an empty string.
   */
  public function getHeaderLine(string $name): string;

  /**
   * Return an instance with the provided values replacing the specified header.
   *
   * While header names are case-insensitive, the casing of the header will
   * be preserved by this function, and returned from getHeaders().
   *
   * For example, if `foo` is already set as a header, calling
   * `withHeader('Foo')` will unset `foo`, and set `Foo`
   *
   * This method MUST be implemented in such a way as to retain the
   * immutability of the message, and MUST return an instance that has the
   * new and/or updated header and value.
   *
   * @param string $name Case-insensitive header field name.
   * @throws \InvalidArgumentException for invalid header names or values.
   */
  public function withHeader(string $name, vec<string> $values): this;

  /**
   * Return an instance with the provided value replacing the specified header.
   *
   * While header names are case-insensitive, the casing of the header will
   * be preserved by this function, and returned from getHeaders().
   *
   * This method MUST be implemented in such a way as to retain the
   * immutability of the message, and MUST return an instance that has the
   * new and/or updated header and value.
   *
   * @param string $name Case-insensitive header field name.
   * @throws \InvalidArgumentException for invalid header names or values.
   */
  public function withHeaderLine(string $name, string $value): this;

  /**
   * Return an instance with the specified header appended with the given values.
   *
   * Existing values for the specified header will be maintained. The new
   * values will be appended to the existing list. If the header did not
   * exist previously, it will be added.
   *
   * This method MUST be implemented in such a way as to retain the
   * immutability of the message, and MUST return an instance that has the
   * new header and/or value.
   *
   * @param string $name Case-insensitive header field name to add.
   * @return static
   * @throws \InvalidArgumentException for invalid header names or values.
   */
  public function withAddedHeader(string $name, vec<string> $values): this;

  /**
   * Return an instance with the specified header appended with the given value.
   *
   * Existing values for the specified header will be maintained. The new
   * value will be appended to the existing list. If the header did not
   * exist previously, it will be added.
   *
   * This method MUST be implemented in such a way as to retain the
   * immutability of the message, and MUST return an instance that has the
   * new header and/or value.
   *
   * @param string $name Case-insensitive header field name to add.
   * @return static
   * @throws \InvalidArgumentException for invalid header names or values.
   */
  public function withAddedHeaderLine(string $name, string $value): this;

  /**
   * Return an instance without the specified header.
   *
   * Header resolution MUST be done without case-sensitivity.
   *
   * This method MUST be implemented in such a way as to retain the
   * immutability of the message, and MUST return an instance that removes
   * the named header.
   *
   * @param string $name Case-insensitive header field name to remove.
   * @return static
   */
  public function withoutHeader(string $name): this;
}
