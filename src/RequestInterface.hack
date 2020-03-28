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

use namespace HH\Lib\IO;

enum HTTPMethod: string {
  PUT     = 'PUT';
  GET     = 'GET';
  POST    = 'POST';
  HEAD    = 'HEAD';
  PATCH   = 'PATCH';
  TRACE   = 'TRACE';
  DELETE  = 'DELETE';
  OPTIONS = 'OPTIONS';
  CONNECT = 'CONNECT';
}

type RequestURIOptions = shape('preserveHost' => bool);

/**
 * Representation of an outgoing, client-side request.
 *
 * Per the HTTP specification, this interface includes properties for
 * each of the following:
 *
 * - Protocol version
 * - HTTP method
 * - URI
 * - Headers
 * - Message body
 *
 * During construction, implementations MUST attempt to set the Host header from
 * a provided URI if no Host header is provided.
 *
 * Requests are considered immutable; all methods that might change state MUST
 * be implemented such that they retain the internal state of the current
 * message and return an instance that contains the changed state.
 */
interface RequestInterface extends MessageInterface {
  /**
   * Retrieves the message's request target.
   *
   * Retrieves the message's request-target either as it will appear (for
   * clients), as it appeared at request (for servers), or as it was
   * specified for the instance (see withRequestTarget()).
   *
   * In most cases, this will be the origin-form of the composed URI,
   * unless a value was provided to the concrete implementation (see
   * withRequestTarget() below).
   *
   * If no URI is available, and no request-target has been specifically
   * provided, this method MUST return the string "/".
   *
   * @return string
   */
  public function getRequestTarget(): string;

  /**
   * Return an instance with the specific request-target.
   *
   * If the request needs a non-origin-form request-target — e.g., for
   * specifying an absolute-form, authority-form, or asterisk-form —
   * this method may be used to create an instance with the specified
   * request-target, verbatim.
   *
   * This method MUST be implemented in such a way as to retain the
   * immutability of the message, and MUST return an instance that has the
   * changed request target.
   *
   * @link http://tools.ietf.org/html/rfc7230#section-5.3 (for the various
   *     request-target forms allowed in request messages)
   * @return static
   */
  public function withRequestTarget(string $requestTarget): this;

  /**
   * Retrieves the HTTP method of the request.
   */
  public function getMethod(): HTTPMethod;

  /**
   * Return an instance with the provided HTTP method.
   *
   * This method MUST be implemented in such a way as to retain the
   * immutability of the message, and MUST return an instance that has the
   * changed request method.
   */
  public function withMethod(HTTPMethod $method): this;

  /**
   * Retrieves the URI instance.
   *
   * This method MUST return a UriInterface instance.
   *
   * @link http://tools.ietf.org/html/rfc3986#section-4.3
   * @return UriInterface Returns a UriInterface instance
   *     representing the URI of the request.
   */
  public function getUri(): UriInterface;

  /**
   * Returns an instance with the provided URI.
   *
   * This method MUST update the Host header of the returned request by
   * default if the URI contains a host component. If the URI does not
   * contain a host component, any pre-existing Host header MUST be carried
   * over to the returned request.
   *
   * You can opt-in to preserving the original state of the Host header by
   * setting `preserveHost` option to `true` in $options shape.
   * When `preserveHost` option is set to
   * `true`, this method interacts with the Host header in the following ways:
   *
   * - If the Host header is missing or empty, and the new URI contains
   *   a host component, this method MUST update the Host header in the returned
   *   request.
   * - If the Host header is missing or empty, and the new URI does not contain a
   *   host component, this method MUST NOT update the Host header in the returned
   *   request.
   * - If a Host header is present and non-empty, this method MUST NOT update
   *   the Host header in the returned request.
   *
   * This method MUST be implemented in such a way as to retain the
   * immutability of the message, and MUST return an instance that has the
   * new UriInterface instance.
   *
   * @link http://tools.ietf.org/html/rfc3986#section-4.3
   * @return static
   */
  public function withUri(UriInterface $uri, RequestURIOptions $options = shape('preserveHost' => false)): this;

  /**
   * Gets the body of the message.
   */
  public function getBody(): IO\ReadHandle;

  /**
   * Return an instance with the specified message body.
   *
   * This method MUST be implemented in such a way as to retain the
   * immutability of the message, and MUST return a new instance that has the
   * new body stream.
   */
  public function withBody(IO\ReadHandle $body): this;
}
