;; olive-css
;;
;; SPDX-License-Identifier: MIT
;; Copyright © Josep Bigorra <jjbigorra@gmail.com>

(define-module (olive-css decl filters)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-13)
  #:use-module (ice-9 string-fun)
  #:use-module (olive-css dsl)
  #:use-module (olive-css sizes)
  #:export (filter-classes blur
                           brightness
                           contrast
                           grayscale
                           sepia
                           saturate
                           invert))

(define blur
  (make-parameter (css-rule-variants ".blur-~a"
                                     #:property 'filter
                                     #:variants (map (lambda (s)
                                                       (css-size s
                                                                 #:conversion
                                                                 to-rem-blur))
                                                     tshirt-sizes))))

(define backdrop-blur
  (make-parameter (css-rule-variants ".backdrop-blur-~a"
                                     #:property 'backdrop-filter
                                     #:variants (map (lambda (s)
                                                       (css-size s
                                                                 #:conversion
                                                                 to-rem-blur))
                                                     tshirt-sizes))))

(define brightness
  (make-parameter (css-rule-variants ".brightness-~a"
                                     #:property 'filter
                                     #:variants (map (lambda (s)
                                                       (css-size s
                                                                 #:conversion (to-percent-function 'brightness)))
                                                     numeric-sizes))))

(define backdrop-brightness
  (make-parameter (css-rule-variants ".backdrop-brightness-~a"
                                     #:property 'backdrop-filter
                                     #:variants (map (lambda (s)
                                                       (css-size s
                                                                 #:conversion (to-percent-function 'brightness)))
                                                     numeric-sizes))))

(define contrast
  (make-parameter (css-rule-variants ".contrast-~a"
                                     #:property 'filter
                                     #:variants (map (lambda (s)
                                                       (css-size s
                                                                 #:conversion (to-percent-function 'contrast)))
                                                     numeric-sizes))))

(define backdrop-contrast
  (make-parameter (css-rule-variants ".backdrop-contrast-~a"
                                     #:property 'backdrop-filter
                                     #:variants (map (lambda (s)
                                                       (css-size s
                                                                 #:conversion (to-percent-function 'contrast)))
                                                     numeric-sizes))))

(define grayscale
  (make-parameter (list (css-rule-variants ".grayscale-~a"
                                           #:property 'filter
                                           #:variants (map (lambda (s)
                                                             (css-size s
                                                                       #:conversion
                                                                       (to-percent-function 'grayscale)))
                                                           numeric-sizes))
                        (css-rule ".grayscale"
                                  (css-declaration 'filter "grayscale(100%)")))))

(define backdrop-grayscale
  (make-parameter (list (css-rule-variants ".backdrop-grayscale-~a"
                                           #:property 'backdrop-filter
                                           #:variants (map (lambda (s)
                                                             (css-size s
                                                                       #:conversion
                                                                       (to-percent-function 'grayscale)))
                                                           numeric-sizes))
                        (css-rule ".backdrop-grayscale"
                                  (css-declaration 'backdrop-filter
                                                   "grayscale(100%)")))))

(define sepia
  (make-parameter (list (css-rule-variants ".sepia-~a"
                                           #:property 'filter
                                           #:variants (map (lambda (s)
                                                             (css-size s
                                                                       #:conversion
                                                                       (to-percent-function 'sepia)))
                                                           numeric-sizes))
                        (css-rule ".sepia"
                                  (css-declaration 'filter "sepia(100%)")))))

(define backdrop-sepia
  (make-parameter (list (css-rule-variants ".backdrop-sepia-~a"
                                           #:property 'backdrop-filter
                                           #:variants (map (lambda (s)
                                                             (css-size s
                                                                       #:conversion
                                                                       (to-percent-function 'sepia)))
                                                           numeric-sizes))
                        (css-rule ".backdrop-sepia"
                                  (css-declaration 'backdrop-filter
                                                   "sepia(100%)")))))

(define saturate
  (make-parameter (list (css-rule-variants ".saturate-~a"
                                           #:property 'filter
                                           #:variants (map (lambda (s)
                                                             (css-size s
                                                                       #:conversion
                                                                       (to-percent-function 'saturate)))
                                                           numeric-sizes))
                        (css-rule ".saturate"
                                  (css-declaration 'filter "saturate(100%)")))))

(define backdrop-saturate
  (make-parameter (list (css-rule-variants ".backdrop-saturate-~a"
                                           #:property 'backdrop-filter
                                           #:variants (map (lambda (s)
                                                             (css-size s
                                                                       #:conversion
                                                                       (to-percent-function 'saturate)))
                                                           numeric-sizes))
                        (css-rule ".backdrop-saturate"
                                  (css-declaration 'backdrop-filter
                                                   "saturate(100%)")))))

(define invert
  (make-parameter (list (css-rule-variants ".invert-~a"
                                           #:property 'filter
                                           #:variants (map (lambda (s)
                                                             (css-size s
                                                                       #:conversion
                                                                       (to-percent-function 'invert)))
                                                           numeric-sizes))
                        (css-rule ".invert"
                                  (css-declaration 'filter "invert(100%)")))))

(define backdrop-invert
  (make-parameter (list (css-rule-variants ".backdrop-invert-~a"
                                           #:property 'backdrop-filter
                                           #:variants (map (lambda (s)
                                                             (css-size s
                                                                       #:conversion
                                                                       (to-percent-function 'invert)))
                                                           numeric-sizes))
                        (css-rule ".backdrop-invert"
                                  (css-declaration 'backdrop-filter
                                                   "invert(100%)")))))

(define filter-classes
  (make-parameter (list (blur)
                        (backdrop-blur)
                        (brightness)
                        (backdrop-brightness)
                        (contrast)
                        (backdrop-contrast)
                        (grayscale)
                        (backdrop-grayscale)
                        (sepia)
                        (backdrop-sepia)
                        (saturate)
                        (backdrop-saturate)
                        (invert)
                        (backdrop-invert))))
