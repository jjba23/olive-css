;; olive-css - Utility-class CSS framework that is easy to learn and hack

;; Copyright © Josep Bigorra <jjbigorra@gmail.com>

;; olive-css is free software: you can redistribute it and/or modify
;; it under the terms of the Lesser GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; olive-css is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; Lesser GNU General Public License for more details.

;; You should have received a copy of the Lesser GNU General Public License
;; along with olive-css.  If not, see <https://www.gnu.org/licenses/>.

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

  olive-css is free software: you can redistribute it and/or modify
  it under the terms of the Lesser GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  olive-css is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  Lesser GNU General Public License for more details.

  You should have received a copy of the Lesser GNU General Public License
  along with olive-css.  If not, see <https://www.gnu.org/licenses/>."))
