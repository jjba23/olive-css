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

(define-module (olive-css decl svg)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-13)
  #:use-module (ice-9 string-fun)
  #:use-module (olive-css dsl)
  #:use-module (olive-css sizes)
  #:export (svg-classes svg-core-classes svg-colors fill stroke))

(define fill
  (make-parameter (list (css-rule ".fill-none"
                                  (css-declaration 'fill
                                                   'none))
                        (css-rule ".fill-current"
                                  (css-declaration 'fill "currentColor")))))

(define stroke-basics
  (list (css-rule ".stroke-none"
                  (css-declaration 'stroke
                                   'none))
        (css-rule ".stroke-current"
                  (css-declaration 'stroke "currentColor"))))

(define stroke
  (make-parameter (append stroke-basics
                          (css-rule-variants ".stroke-~a"
                                             #:property 'stroke-width
                                             #:variants (map (lambda (s)
                                                               (css-size s
                                                                #:conversion
                                                                to-px))
                                                             numeric-sizes)))))

(define (svg-colors palettes)
  "Generate palette-aware @code{fill-*} and @code{stroke-*} color utilities."
  (append (css-palette-rules ".fill-~a-~a"
                             #:property 'fill
                             #:palettes palettes)
          (css-palette-rules ".stroke-~a-~a"
                             #:property 'stroke
                             #:palettes palettes)))

(define (svg-core-classes)
  "Structural SVG utilities (no palette-derived colors)."
  (list (fill)
        (stroke)))

(define (svg-classes palettes)
  (append (svg-core-classes)
          (list (svg-colors palettes))))
