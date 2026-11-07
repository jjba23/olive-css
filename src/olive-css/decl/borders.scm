;; olive-css
;;
;; SPDX-License-Identifier: MIT
;; Copyright © Josep Bigorra <jjbigorra@gmail.com>

(define-module (olive-css decl borders)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-13)
  #:use-module (ice-9 string-fun)
  #:use-module (olive-css dsl)
  #:use-module (olive-css sizes)
  #:export (border-extras-classes border-styles border-width-sides
                                  divide-classes divide-multiplier))

(define divide-multiplier
  (make-parameter 0.28))

(define border-styles
  (make-parameter (css-rule-variants ".border-~a"
                                     #:property 'border-style
                                     #:variants '((solid solid)
                                                  (dashed dashed)
                                                  (dotted dotted)
                                                  (double double)
                                                  (hidden hidden)
                                                  (none none)))))

(define (side-width-rules prefixes)
  "Build @code{.border-<side>-<n>} width rules for each (name property) pair."
  (map (lambda (d)
         (css-rule-variants (string-append "."
                                           (symbol->string (car d)) "-~a")
                            #:property (cadr d)
                            #:variants (map (lambda (s)
                                              (css-size s
                                                        #:conversion to-px))
                                            numeric-sizes))) prefixes))

(define border-width-sides
  (make-parameter (append (list (css-rule ".border"
                                          (css-declaration 'border-width "1px"))
                                (css-rule ".border-t"
                                          (css-declaration 'border-top-width
                                                           "1px"))
                                (css-rule ".border-r"
                                          (css-declaration 'border-right-width
                                                           "1px"))
                                (css-rule ".border-b"
                                          (css-declaration 'border-bottom-width
                                                           "1px"))
                                (css-rule ".border-l"
                                          (css-declaration 'border-left-width
                                                           "1px"))
                                (css-rule ".border-x"
                                          (css-declaration 'border-inline-width
                                                           "1px"))
                                (css-rule ".border-y"
                                          (css-declaration 'border-block-width
                                                           "1px")))
                          (side-width-rules '((border-t border-top-width)
                                              (border-r border-right-width)
                                              (border-b border-bottom-width)
                                              (border-l border-left-width)
                                              (border-x border-inline-width)
                                              (border-y border-block-width))))))

(define (divide-rules axis)
  "Build child-divider rules for @var{axis} (`x' or `y')."
  (map (lambda (s)
         (css-rule (format #f ".divide-~a-~a > :not([hidden])~~:not([hidden])"
                           axis
                           (car s))
                   (css-declaration (if (equal? axis
                                                'x)
                                        'border-inline-start-width
                                        'border-block-start-width)
                                    (to-px (cadr s))))) numeric-sizes))

(define divide-classes
  (make-parameter (append (divide-rules 'x)
                          (divide-rules 'y))))

(define border-extras-classes
  (make-parameter (list (border-width-sides)
                        (border-styles)
                        (divide-classes))))
