;; olive-css
;;
;; SPDX-License-Identifier: MIT
;; Copyright © Josep Bigorra <jjbigorra@gmail.com>

(define-module (olive-css decl spacing)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-13)
  #:use-module (ice-9 string-fun)
  #:use-module (olive-css dsl)
  #:use-module (olive-css sizes)
  #:export (spacing-classes margin padding space-between scroll-margin
                            scroll-padding margin-multiplier
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
                         (pr padding-right)
                         (ps padding-inline-start)
                         (pe padding-inline-end)))))

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
         (mr margin-right)
         (ms margin-inline-start)
         (me margin-inline-end))))

(define (negative-margin-rules)
  "Negative margins on the same scale, including the logical sides."
  (map (lambda (d)
         (css-rule-variants (string-append ".\\-"
                                           (symbol->string (car d))
                                           "-~a")
                            #:property (cadr d)
                            #:variants (map (lambda (s)
                                              (css-size s
                                                        #:conversion to-rem
                                                        #:multiplier (- (margin-multiplier))))
                                            (append positive-numeric-sizes
                                                    tshirt-sizes))))
       '((m margin)
         (mx margin-inline)
         (my margin-block)
         (mt margin-top)
         (mb margin-bottom)
         (ml margin-left)
         (mr margin-right)
         (ms margin-inline-start)
         (me margin-inline-end))))

(define margin
  (make-parameter (append (margin-auto-rules)
                          (negative-margin-rules)
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
                                 (mr margin-right)
                                 (ms margin-inline-start)
                                 (me margin-inline-end))))))

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

(define (scroll-spacing-rules declarations multiplier)
  "Scroll snap clearance on the spacing scale."
  (map (lambda (d)
         (css-rule-variants (format #f ".scroll-~a-~a" (car d) "~a")
                            #:property (cadr d)
                            #:variants (map (lambda (s)
                                              (css-size s
                                                        #:conversion
                                                        to-rem
                                                        #:multiplier
                                                        multiplier))
                                            (append numeric-sizes
                                                    tshirt-sizes))))
       declarations))

(define scroll-margin
  (make-parameter (scroll-spacing-rules
                   '((m scroll-margin)
                     (mx scroll-margin-inline)
                     (my scroll-margin-block)
                     (mt scroll-margin-top)
                     (mb scroll-margin-bottom)
                     (ml scroll-margin-left)
                     (mr scroll-margin-right))
                   (margin-multiplier))))

(define scroll-padding
  (make-parameter (scroll-spacing-rules
                   '((p scroll-padding)
                     (px scroll-padding-inline)
                     (py scroll-padding-block)
                     (pt scroll-padding-top)
                     (pb scroll-padding-bottom)
                     (pl scroll-padding-left)
                     (pr scroll-padding-right))
                   (padding-multiplier))))

(define spacing-classes
  (make-parameter (list (margin)
                        (padding)
                        (space-between)
                        (scroll-margin)
                        (scroll-padding))))
