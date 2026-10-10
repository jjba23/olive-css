;; olive-css - Utility-class CSS framework that is easy to learn and hack

;; Copyright © 2026 Oliver Fox <southfoxdreamer@gmail.com>

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
;;; Command-line front-end for the content-aware tree-shaker.  The pruning
;;; logic itself lives in @code{(olive-css tree-shaking)}; this script only
;;; runs it and prints a report.
;;;
;;; Every option is a Guile parameter, so a non-default layout is a matter of
;;; `parameterize' rather than editing anything:
;;;
;;;   (parameterize ((artifact-path "_site")
;;;                  (base-stylesheet-path "resources/css/olive.min.css")
;;;                  (output-css-target "app.min.css"))
;;;     (tree-shake))
;;;
;;;
;;; Code:

(use-modules (ice-9 format)
             (olive-css tree-shaking))

(define (report result)
  (format #t "Tree-shaking: ~a used classes~%"
          (assoc-ref result
                     'used-classes))
  (format #t "  ~a: ~a bytes~%"
          (assoc-ref result
                     'stylesheet)
          (assoc-ref result
                     'input-bytes))
  (format #t "  ~a: ~a bytes~%"
          (assoc-ref result
                     'destination)
          (assoc-ref result
                     'output-bytes)))

(report (tree-shake))
