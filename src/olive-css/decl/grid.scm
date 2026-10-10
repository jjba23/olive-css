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

(define-module (olive-css decl grid)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-13)
  #:use-module (ice-9 string-fun)
  #:use-module (olive-css dsl)
  #:use-module (olive-css sizes)
  #:use-module (olive-css decl flexbox)
  #:export (grid-classes grid-track-scale col-span row-span column-gap row-gap))

;; Grid placement is usually expressed over a small, fixed track count.
(define grid-track-scale
  (map (lambda (n)
         (list n n))
       '(1 2 3 4 5 6 7 8 9 10 11 12)))

(define col-span
  (make-parameter (append (css-rule-variants ".col-span-~a"
                                             #:property 'grid-column
                                             #:variants (map (lambda (s)
                                                               (list (car s)
                                                                     (format #f
                                                                             "span ~a / span ~a"
                                                                             (cadr s)
                                                                             (cadr s))))
                                                             grid-track-scale))
                         (list (css-rule ".col-span-full"
                                         (css-declaration 'grid-column
                                                          "1 / -1"))
                               (css-rule ".col-auto"
                                         (css-declaration 'grid-column
                                                          'auto))))))

(define row-span
  (make-parameter (append (css-rule-variants ".row-span-~a"
                                             #:property 'grid-row
                                             #:variants (map (lambda (s)
                                                               (list (car s)
                                                                     (format #f
                                                                             "span ~a / span ~a"
                                                                             (cadr s)
                                                                             (cadr s))))
                                                             grid-track-scale))
                         (list (css-rule ".row-span-full"
                                         (css-declaration 'grid-row
                                                          "1 / -1"))
                               (css-rule ".row-auto"
                                         (css-declaration 'grid-row
                                                          'auto))))))

(define grid-column-lines
  (make-parameter (append (css-rule-variants ".col-start-~a"
                                             #:property 'grid-column-start
                                             #:variants (append grid-track-scale
                                                                '((auto auto))))
                          (css-rule-variants ".col-end-~a"
                                             #:property 'grid-column-end
                                             #:variants (append grid-track-scale
                                                                '((auto auto))))
                          (css-rule-variants ".row-start-~a"
                                             #:property 'grid-row-start
                                             #:variants (append grid-track-scale
                                                                '((auto auto))))
                          (css-rule-variants ".row-end-~a"
                                             #:property 'grid-row-end
                                             #:variants (append grid-track-scale
                                                                '((auto auto)))))))

(define column-gap
  (make-parameter (css-rule-variants ".gap-x-~a"
                                     #:property 'column-gap
                                     #:variants (map (lambda (s)
                                                       (css-size s
                                                                 #:conversion
                                                                 to-rem
                                                                 #:multiplier
                                                                 (gap-multiplier)))
                                                     (append numeric-sizes
                                                             tshirt-sizes)))))

(define row-gap
  (make-parameter (css-rule-variants ".gap-y-~a"
                                     #:property 'row-gap
                                     #:variants (map (lambda (s)
                                                       (css-size s
                                                                 #:conversion
                                                                 to-rem
                                                                 #:multiplier
                                                                 (gap-multiplier)))
                                                     (append numeric-sizes
                                                             tshirt-sizes)))))

(define auto-rows
  (make-parameter (list (css-rule ".auto-rows-auto"
                                  (css-declaration 'grid-auto-rows 'auto))
                        (css-rule ".auto-rows-min"
                                  (css-declaration 'grid-auto-rows
                                                   'min-content))
                        (css-rule ".auto-rows-max"
                                  (css-declaration 'grid-auto-rows
                                                   'max-content))
                        (css-rule ".auto-rows-fr"
                                  (css-declaration 'grid-auto-rows
                                                   "minmax(0, 1fr)")))))

(define grid-classes
  (make-parameter (list (col-span)
                        (row-span)
                        (grid-column-lines)
                        (column-gap)
                        (row-gap)
                        (auto-rows))))
