<?hh // strict
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
 *  This source code is licensed under the BSD-style license found in the
 *  LICENSE file in the root directory of this source tree. An additional grant
 *  of patent rights can be found in the PATENTS file in the same directory.
 */

namespace Facebook\Experimental\Http\Message;

/**
 * Describes a data stream.
 *
 * Typically, an instance will wrap a PHP stream; this interface provides
 * a wrapper around the most common operations, including serialization of
 * the entire stream to a string.
 */
interface StreamInterface {
  /**
   * Reads all data from the stream into a string, from the beginning to end.
   *
   * This method MUST attempt to seek to the beginning of the stream before
   * reading data and read the stream until the end is reached.
   *
   * Warning: This could attempt to load a large amount of data into memory.
   *
   * This method MUST NOT raise an exception in order to conform with PHP's
   * string casting operations.
   */
  public function __toString(): string;

  /**
   * Closes the stream and any underlying resources.
   *
   * @return void
   */
  public function close(): void;

  /**
   * Separates any underlying resources from the stream.
   *
   * After the stream has been detached, the stream is in an unusable state.
   */
  public function detach(): ?resource;

  /**
   * Get the size of the stream if known.
   */
  public function getSize(): ?int;

  /**
   * Returns the current position of the file read/write pointer
   *
   * @throws \RuntimeException on error.
   */
  public function tell(): int;

  /**
   * Returns true if the stream is at the end of the stream.
   */
  public function eof(): bool;

  /**
   * Returns whether or not the stream is seekable.
   */
  public function isSeekable(): bool;

  /**
   * Seek to a position in the stream.
   *
   * @link http://www.php.net/manual/en/function.fseek.php
   * @param int $offset Stream offset
   * @param int $whence Specifies how the cursor position will be calculated
   *     based on the seek offset. Valid values are identical to the built-in
   *     PHP $whence values for `fseek()`.  SEEK_SET: Set position equal to
   *     offset bytes SEEK_CUR: Set position to current location plus offset
   *     SEEK_END: Set position to end-of-stream plus offset.
   * @throws \RuntimeException on failure.
   */
  public function seek(int $offset, int $whence = \SEEK_SET): void;

  /**
   * Seek to the beginning of the stream.
   *
   * If the stream is not seekable, this method will raise an exception;
   * otherwise, it will perform a seek(0).
   *
   * @see seek()
   * @link http://www.php.net/manual/en/function.fseek.php
   * @throws \RuntimeException on failure.
   */
  public function rewind(): void;

  /**
   * Returns whether or not the stream is writable.
   */
  public function isWritable(): bool;

  /**
   * Write data to the stream.
   *
   * @param string $string The string that is to be written.
   * @return int Returns the number of bytes written to the stream.
   * @throws \RuntimeException on failure.
   */
  public function write(string $string): int;

  /**
   * Returns whether or not the stream is readable.
   */
  public function isReadable(): bool;

  /**
   * Read data from the stream.
   *
   * @param int $length Read up to $length bytes from the object and return
   *     them. Fewer than $length bytes may be returned if underlying stream
   *     call returns fewer bytes.
   * @return string Returns the data read from the stream, or an empty string
   *     if no bytes are available.
   * @throws \RuntimeException if an error occurs.
   */
  public function read(int $length): string;

  /**
   * Returns the remaining contents in a string
   *
   * @return string
   * @throws \RuntimeException if unable to read or an error occurs while
   *     reading.
   */
  public function getContents(): string;

  /**
   * Get stream metadata as an associative array or retrieve a specific key.
   *
   * The keys returned are identical to the keys returned from PHP's
   * stream_get_meta_data() function.
   *
   * @link http://php.net/manual/en/function.stream-get-meta-data.php
   * @param string $key Specific metadata to retrieve.
   * @return array|mixed|null Returns an associative array if no key is
   *     provided. Returns a specific key value if a key is provided and the
   *     value is found, or null if the key is not found.
   */
  public function getMetadata(?string $key = null): mixed;
}
