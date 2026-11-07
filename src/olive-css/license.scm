;; olive-css
;;
;; SPDX-License-Identifier: MIT
;; Copyright © Josep Bigorra <jjbigorra@gmail.com>

;;; Commentary:
;;;
;;; The header written at the top of every generated stylesheet.  It lives in
;;; its own dependency-free module so that tools which only need the text - the
;;; tree-shaker, for instance - can import this instead of loading the whole
;;; generator.
;;;
;;; The value is a parameter: bind it with `parameterize' to change or drop the
;;; header (the empty string omits it entirely).
;;;
;;;
;;; Code:

(define-module (olive-css license)
  #:export (license-header))

(define license-header
  (make-parameter
   "olive-css - Utility-class CSS framework that is easy to learn and hack

  Copyright © Josep Bigorra <jjbigorra@gmail.com>

  SPDX-License-Identifier: MIT

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the \"Software\"), to
  deal in the Software without restriction, including without limitation the
  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
  sell copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the condition that the copyright notice and
  this permission notice are included in all copies or substantial portions of
  the Software.

  THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  SOFTWARE."))
