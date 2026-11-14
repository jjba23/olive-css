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
                                  divide-classes divide-multiplier
                                  divide-colors))

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
                                (css-rule ".border-s"
                                          (css-declaration
                                           'border-inline-start-width
                                           "1px"))
                                (css-rule ".border-e"
                                          (css-declaration
                                           'border-inline-end-width
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
                                              (border-s
                                               border-inline-start-width)
                                              (border-e border-inline-end-width)
                                              (border-x border-inline-width)
                                              (border-y border-block-width))))))

(define (divider-selector class-name)
  "The child selector of a divider utility: every child but the first."
  (format #f ".~a > :not([hidden])~~:not([hidden])" class-name))

(define (divide-rules axis)
  "Build child-divider rules for AXIS (`x' or `y').

Both logical edges are written, one multiplied by the reverse variable and the
other by its complement, so =.divide-x-reverse= only has to set that variable
on the parent for the children to swap edges."
  (let ((start (if (equal? axis
                          'x) 'border-inline-start-width
                   'border-block-start-width))
        (end (if (equal? axis
                        'x) 'border-inline-end-width
                 'border-block-end-width))
        (variable (format #f "--olive-divide-~a-reverse" axis)))
    (append (map (lambda (s)
                   (css-rule (divider-selector (format #f "divide-~a-~a" axis
                                                       (car s)))
                             (css-declaration end
                                              (format #f
                                                      "calc(~a * var(~a, 0))"
                                                      (to-px (cadr s))
                                                      variable))
                             (css-declaration start
                                              (format #f
                                                      "calc(~a * calc(1 - var(~a, 0)))"
                                                      (to-px (cadr s))
                                                      variable))))
                 numeric-sizes)
            (list (css-rule (divider-selector (format #f "divide-~a-reverse"
                                                      axis))
                            (css-declaration variable 1))))))

;; Palette-derived divide colours.  The colour lands on the same child selector
;; as the width, so `.divide-x-2' and `.divide-onyx-100' are one rule each and
;; the tree-shaker sees a single class per selector.
(define (divide-colors palettes)
  (append-map (lambda (palette)
                (map (lambda (shade)
                       (css-rule (divider-selector (format #f "divide-~a-~a"
                                                           (car palette)
                                                           (car shade)))
                                 (css-declaration 'border-color
                                                  (apply format
                                                         #f
                                                         "oklch(~a ~a ~a / 1)"
                                                         (cadr shade)))))
                     (cdr palette)))
              palettes))

(define divide-classes
  (make-parameter (append (divide-rules 'x)
                          (divide-rules 'y))))

(define border-extras-classes
  (make-parameter (list (border-width-sides)
                        (border-styles)
                        (divide-classes))))
