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

(define-module (olive-css decl spacing)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-13)
  #:use-module (ice-9 string-fun)
  #:use-module (olive-css dsl)
  #:use-module (olive-css sizes)
  #:export (spacing-classes margin padding space-between margin-multiplier
                            padding-multiplier))

(define margin-multiplier
  (make-parameter 0.28))
(define padding-multiplier
  (make-parameter 0.28))

(define padding
  (make-parameter (map (lambda (d)
                         (map (lambda (p)
                                (css-rule-variants (string-append "."
                                                                  (format #f
                                                                   "~a"
                                                                   (car d))
                                                                  "-" "~a")
                                                   #:property p
                                                   #:variants (map (lambda (s)
                                                                     (css-size
                                                                      s
                                                                      #:conversion
                                                                      to-rem
                                                                      #:multiplier
                                                                      (padding-multiplier)))
                                                                   (append
                                                                    numeric-sizes
                                                                    tshirt-sizes))))
                              (cdr d)))
                       '((p padding)
                         (px padding-inline)
                         (py padding-block)
                         (pt padding-top)
                         (pb padding-bottom)
                         (pl padding-left)
                         (pr padding-right)))))

(define (margin-auto-rules)
  "Generate the =*-auto= margin utilities (e.g. =.mx-auto= center-alignment)."
  (map (lambda (d)
         (css-rule-variants (string-append "."
                                           (format #f "~a"
                                                   (car d)) "-~a")
                            #:property (cadr d)
                            #:variants '((auto auto))))
       '((m margin)
         (mx margin-inline)
         (my margin-block)
         (mt margin-top)
         (mb margin-bottom)
         (ml margin-left)
         (mr margin-right))))

(define margin
  (make-parameter (append (margin-auto-rules)
                          (map (lambda (d)
                                 (map (lambda (p)
                                        (css-rule-variants (string-append "."
                                                            (format #f "~a"
                                                                    (car d))
                                                            "-" "~a")
                                                           #:property p
                                                           #:variants (map (lambda 
                                                                                   (s)
                                                                             (css-size
                                                                              s
                                                                              #:conversion
                                                                              to-rem
                                                                              #:multiplier
                                                                              (margin-multiplier)))
                                                                           (append
                                                                            numeric-sizes
                                                                            tshirt-sizes))))
                                      (cdr d)))
                               '((m margin)
                                 (mx margin-inline)
                                 (my margin-block)
                                 (mt margin-top)
                                 (mb margin-bottom)
                                 (ml margin-left)
                                 (mr margin-right))))))

(define (space-rules axis)
  "Generate child-spacing rules for @var{axis} (`x' or `y').

Selectors are built directly (rather than through @code{css-rule-variants})
because the general-sibling combinator `~' would otherwise collide with a
format directive."
  (map (lambda (s)
         (css-rule (format #f ".space-~a-~a > :not([hidden])~~:not([hidden])"
                           axis
                           (car s))
                   (css-declaration (if (equal? axis
                                                'x)
                                        'margin-inline-start
                                        'margin-block-start)
                                    (to-rem (* (cadr s)
                                               (margin-multiplier))))))
       (append numeric-sizes tshirt-sizes)))

(define space-between
  (make-parameter (append (space-rules 'x)
                          (space-rules 'y))))

(define spacing-classes
  (make-parameter (list (margin)
                        (padding)
                        (space-between))))
