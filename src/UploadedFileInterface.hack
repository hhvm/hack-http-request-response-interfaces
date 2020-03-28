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

enum UploadedFileError: int {
	ERROR_EXCEEDS_MAX_INI_SIZE = 1;
	ERROR_EXCEEDS_MAX_FORM_SIZE = 2;
	ERROR_INCOMPLETE = 3;
	ERROR_NO_FILE = 4;
	ERROR_TMP_DIR_NOT_SPECIFIED = 6;
	ERROR_TMP_DIR_NOT_WRITEABLE = 7;
	ERROR_CANCELED_BY_EXTENSION = 8;
}

/**
 * Value object representing a file uploaded through an HTTP request.
 *
 * Instances of this interface are considered immutable; all methods that
 * might change state MUST be implemented such that they retain the internal
 * state of the current instance and return an instance that contains the
 * changed state.
 */
interface UploadedFileInterface {
  /**
   * Retrieve a stream representing the uploaded file.
   *
   * This method MUST return a StreamInterface instance, representing the
   * uploaded file. The purpose of this method is to allow utilizing native PHP
   * stream functionality to manipulate the file upload, such as
   * stream_copy_to_stream() (though the result will need to be decorated in a
   * native PHP stream wrapper to work with such functions).
   *
   * If the moveTo() method has been called previously, this method MUST raise
   * an exception.
   *
   * @throws \RuntimeException in cases when no stream is available or can be
   *     created.
   */
  public function getStream(): IO\ReadHandle;

  /**
   * Move the uploaded file to a new location.
   *
   * Use this method as an alternative to move_uploaded_file(). This method is
   * guaranteed to work in both SAPI and non-SAPI environments.
   * Implementations must determine which environment they are in, and use the
   * appropriate method (move_uploaded_file(), rename(), or a stream
   * operation) to perform the operation.
   *
   * $targetPath may be an absolute path, or a relative path. If it is a
   * relative path, resolution should be the same as used by PHP's rename()
   * function.
   *
   * The original file or stream MUST be removed on completion.
   *
   * If this method is called more than once, any subsequent calls MUST raise
   * an exception.
   *
   * When used in an SAPI environment where $_FILES is populated, when writing
   * files via moveTo(), is_uploaded_file() and move_uploaded_file() SHOULD be
   * used to ensure permissions and upload status are verified correctly.
   *
   * If you wish to move to a stream, use getStream(), as SAPI operations
   * cannot guarantee writing to stream destinations.
   *
   * @see http://php.net/is_uploaded_file
   * @see http://php.net/move_uploaded_file
   * @param string $targetPath Path to which to move the uploaded file.
   * @throws \InvalidArgumentException if the $targetPath specified is invalid.
   * @throws \RuntimeException on any error during the move operation, or on
   *     the second or subsequent call to the method.
   */
  public function moveTo(string $targetPath): void;

  /**
   * Retrieve the file size.
   *
   * Implementations SHOULD return the value stored in the "size" key of
   * the file in the $_FILES array if available, as PHP calculates this based
   * on the actual size transmitted.
   *
   * @return int|null The file size in bytes or null if unknown.
   */
  public function getSize(): ?int;

  /**
   * Retrieve the error associated with the uploaded file.
   *
   * If the file was uploaded successfully, this method MUST return
   * null.
   *
   * @return ?UploadedFileError
   */
  public function getError(): ?UploadedFileError;

  /**
   * Retrieve the filename sent by the client.
   *
   * Do not trust the value returned by this method. A client could send
   * a malicious filename with the intention to corrupt or hack your
   * application.
   *
   * Implementations SHOULD return the value stored in the "name" key of
   * the file in the $_FILES array.
   */
  public function getClientFilename(): string;

  /**
   * Retrieve the media type sent by the client.
   *
   * Do not trust the value returned by this method. A client could send
   * a malicious media type with the intention to corrupt or hack your
   * application.
   *
   * This may be the empty string.
   */
  public function getClientMediaType(): string;
}
