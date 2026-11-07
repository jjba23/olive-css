;; olive-css
;;
;; SPDX-License-Identifier: MIT
;; Copyright © Josep Bigorra <jjbigorra@gmail.com>

(define-module (olive-css decl tables)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-13)
  #:use-module (ice-9 string-fun)
  #:use-module (olive-css dsl)
  #:use-module (olive-css sizes)
  #:export (table-classes table-layout table-collapse border-spacing
                          caption-side))

(define table-layout
  (make-parameter (css-rule-variants ".table-~a"
                                     #:property 'table-layout
                                     #:variants '((auto auto)
                                                  (fixed fixed)))))

(define table-collapse
  (make-parameter (list (css-rule ".border-collapse"
                                  (css-declaration 'border-collapse
                                                   'collapse))
                        (css-rule ".border-separate"
                                  (css-declaration 'border-collapse
                                                   'separate)))))

(define border-spacing
  (make-parameter (append (css-rule-variants ".border-spacing-~a"
                                             #:property 'border-spacing
                                             #:variants (map (lambda (s)
                                                               (css-size s
                                                                #:conversion
                                                                to-rem))
                                                             numeric-sizes))
                          (css-rule-variants ".border-spacing-x-~a"
                                             #:property 'border-spacing
                                             #:variants (map (lambda (s)
                                                               (list (car s)
                                                                     (format
                                                                             #f
                                                                             "~a 0"
                                                                             (to-rem
                                                                              (cadr
                                                                               s)))))
                                                             numeric-sizes))
                          (css-rule-variants ".border-spacing-y-~a"
                                             #:property 'border-spacing
                                             #:variants (map (lambda (s)
                                                               (list (car s)
                                                                     (format
                                                                             #f
                                                                             "0 ~a"
                                                                             (to-rem
                                                                              (cadr
                                                                               s)))))
                                                             numeric-sizes)))))

(define caption-side
  (make-parameter (css-rule-variants ".caption-~a"
                                     #:property 'caption-side
                                     #:variants '((top top)
                                                  (bottom bottom)))))

(define table-classes
  (make-parameter (list (table-layout)
                        (table-collapse)
                        (border-spacing)
                        (caption-side))))
