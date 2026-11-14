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
  #:export (filter-classes filter-composition
                           blur
                           brightness
                           contrast
                           drop-shadow
                           grayscale
                           hue-rotate
                           invert
                           saturate
                           sepia
                           backdrop-blur
                           backdrop-brightness
                           backdrop-contrast
                           backdrop-grayscale
                           backdrop-hue-rotate
                           backdrop-invert
                           backdrop-opacity
                           backdrop-saturate
                           backdrop-sepia))

;; `filter' and `backdrop-filter' are one property each, so two utilities from
;; different axes would overwrite each other in declaration order.  Every
;; utility writes its own function into a custom property and re-declares the
;; composed property, which reads each variable with an empty fallback: an
;; unset function then contributes nothing and `.blur-sm .brightness-50'
;; applies both.
(define filter-variables
  '("--olive-blur"
    "--olive-brightness"
    "--olive-contrast"
    "--olive-drop-shadow"
    "--olive-grayscale"
    "--olive-hue-rotate"
    "--olive-invert"
    "--olive-saturate"
    "--olive-sepia"))

(define backdrop-variables
  '("--olive-backdrop-blur"
    "--olive-backdrop-brightness"
    "--olive-backdrop-contrast"
    "--olive-backdrop-grayscale"
    "--olive-backdrop-hue-rotate"
    "--olive-backdrop-invert"
    "--olive-backdrop-opacity"
    "--olive-backdrop-saturate"
    "--olive-backdrop-sepia"))

(define (filter-composition variables)
  "The value that composes every variable in VARIABLES, empty when unset."
  (string-join (map (lambda (variable)
                      (format #f "var(~a,)" variable))
                    variables) " "))

(define (composed-variables property)
  "The family variables PROPERTY composes: `filter' or `backdrop-filter'."
  (if (eq? property 'filter) filter-variables backdrop-variables))

(define (filter-utilities class-prefix variable property variants)
  "One rule per (NAME VALUE) pair in VARIANTS: the function goes in VARIABLE
and PROPERTY is re-declared as the composition of its whole family."
  (map (lambda (variant)
         (css-rule (format #f ".~a-~a" class-prefix (car variant))
                   (css-declaration variable (cadr variant))
                   (css-declaration property
                                    (filter-composition
                                     (composed-variables property)))))
       variants))

(define* (function-values function scale)
  "Scale entries whose value is written as FUNCTION of the angle or ratio."
  (map (lambda (entry)
         (list (car entry)
               (format #f "~a(~a)" function (cadr entry))))
       scale))

(define* (percent-values function #:key (scale numeric-sizes))
  "Scale entries whose value is a percentage inside FUNCTION."
  (map (lambda (entry)
         (css-size entry
                   #:conversion (to-percent-function function)))
       scale))

;; Angles are a smaller vocabulary than the numeric scale: hue rotations beyond
;; half a turn repeat, and a degree unit is required.
(define (degree-values function scale)
  (map (lambda (entry)
         (list (car entry)
               (format #f "~a(~adeg)" function (cadr entry))))
       scale))

(define (negated scale)
  "The same names with the value negated, for the -FUNCTION-* family."
  (map (lambda (entry)
         (list (car entry) (- (cadr entry))))
       scale))

(define (bare-rule class variable function property)
  "The 100% form of a family, e.g. =grayscale= without a value."
  (css-rule class
            (css-declaration variable function)
            (css-declaration property
                             (filter-composition (composed-variables property)))))

(define (backdrop-rules class-prefix variable variants)
  (filter-utilities class-prefix variable 'backdrop-filter variants))

(define (foreground-rules class-prefix variable variants)
  (filter-utilities class-prefix variable 'filter variants))

(define blur
  (make-parameter (append (foreground-rules "blur" "--olive-blur"
                                            (map (lambda (s)
                                                   (css-size s
                                                             #:conversion
                                                             to-rem-blur))
                                                 tshirt-sizes))
                          (list (css-rule ".filter-none"
                                          (css-declaration 'filter 'none))))))

(define brightness
  (make-parameter (foreground-rules "brightness" "--olive-brightness"
                                    (percent-values 'brightness))))

(define contrast
  (make-parameter (foreground-rules "contrast" "--olive-contrast"
                                    (percent-values 'contrast))))

(define drop-shadow-geometries
  '(("2xs" "0 1px 0 rgb(0 0 0 / 0.05)")
    (xs "0 1px 1px rgb(0 0 0 / 0.05)")
    (sm "0 1px 2px rgb(0 0 0 / 0.15)")
    (md "0 2px 4px rgb(0 0 0 / 0.15)")
    (lg "0 4px 8px rgb(0 0 0 / 0.15)")
    (xl "0 8px 16px rgb(0 0 0 / 0.15)")
    ("2xl" "0 16px 32px rgb(0 0 0 / 0.15)")))

(define drop-shadow
  (make-parameter (append (foreground-rules "drop-shadow" "--olive-drop-shadow"
                                            (function-values 'drop-shadow
                                                             drop-shadow-geometries))
                          (list (foreground-rules "drop-shadow" "--olive-drop-shadow"
                                                  '(("none" "drop-shadow(0 0 #0000)")))))))

(define grayscale
  (make-parameter (append (foreground-rules "grayscale" "--olive-grayscale"
                                            (percent-values 'grayscale))
                          (list (bare-rule ".grayscale" "--olive-grayscale"
                                           "grayscale(100%)" 'filter)))))

(define hue-rotate-scale
  '((0 0)
    (15 15)
    (30 30)
    (60 60)
    (90 90)
    (180 180)))

(define hue-rotate
  (make-parameter (append (foreground-rules "hue-rotate" "--olive-hue-rotate"
                                            (degree-values 'hue-rotate
                                                           hue-rotate-scale))
                          (foreground-rules "-hue-rotate" "--olive-hue-rotate"
                                            (degree-values 'hue-rotate
                                                           (negated
                                                            (cdr hue-rotate-scale)))))))

(define invert
  (make-parameter (append (foreground-rules "invert" "--olive-invert"
                                            (percent-values 'invert))
                          (list (bare-rule ".invert" "--olive-invert"
                                           "invert(100%)" 'filter)))))

(define saturate
  (make-parameter (append (foreground-rules "saturate" "--olive-saturate"
                                            (percent-values 'saturate))
                          (list (bare-rule ".saturate" "--olive-saturate"
                                           "saturate(100%)" 'filter)))))

(define sepia
  (make-parameter (append (foreground-rules "sepia" "--olive-sepia"
                                            (percent-values 'sepia))
                          (list (bare-rule ".sepia" "--olive-sepia"
                                           "sepia(100%)" 'filter)))))

(define backdrop-blur
  (make-parameter (append (backdrop-rules "backdrop-blur" "--olive-backdrop-blur"
                                          (map (lambda (s)
                                                 (css-size s
                                                           #:conversion
                                                           to-rem-blur))
                                               tshirt-sizes))
                          (list (css-rule ".backdrop-filter-none"
                                          (css-declaration 'backdrop-filter
                                                           'none))))))

(define backdrop-brightness
  (make-parameter (backdrop-rules "backdrop-brightness"
                                  "--olive-backdrop-brightness"
                                  (percent-values 'brightness))))

(define backdrop-contrast
  (make-parameter (backdrop-rules "backdrop-contrast"
                                  "--olive-backdrop-contrast"
                                  (percent-values 'contrast))))

(define backdrop-grayscale
  (make-parameter (append (backdrop-rules "backdrop-grayscale"
                                          "--olive-backdrop-grayscale"
                                          (percent-values 'grayscale))
                          (list (bare-rule ".backdrop-grayscale"
                                           "--olive-backdrop-grayscale"
                                           "grayscale(100%)" 'backdrop-filter)))))

(define backdrop-hue-rotate
  (make-parameter (append (backdrop-rules "backdrop-hue-rotate"
                                          "--olive-backdrop-hue-rotate"
                                          (degree-values 'hue-rotate
                                                         hue-rotate-scale))
                          (backdrop-rules "-backdrop-hue-rotate"
                                          "--olive-backdrop-hue-rotate"
                                          (degree-values 'hue-rotate
                                                         (negated
                                                          (cdr hue-rotate-scale)))))))

(define backdrop-invert
  (make-parameter (append (backdrop-rules "backdrop-invert"
                                          "--olive-backdrop-invert"
                                          (percent-values 'invert))
                          (list (bare-rule ".backdrop-invert"
                                           "--olive-backdrop-invert"
                                           "invert(100%)" 'backdrop-filter)))))

(define backdrop-opacity-scale
  '((0 0)
    (5 5)
    (10 10)
    (20 20)
    (25 25)
    (30 30)
    (40 40)
    (50 50)
    (60 60)
    (70 70)
    (75 75)
    (80 80)
    (90 90)
    (95 95)
    (100 100)))

(define backdrop-opacity
  (make-parameter (backdrop-rules "backdrop-opacity"
                                  "--olive-backdrop-opacity"
                                  (percent-values 'opacity
                                                  #:scale
                                                  backdrop-opacity-scale))))

(define backdrop-saturate
  (make-parameter (append (backdrop-rules "backdrop-saturate"
                                          "--olive-backdrop-saturate"
                                          (percent-values 'saturate))
                          (list (bare-rule ".backdrop-saturate"
                                           "--olive-backdrop-saturate"
                                           "saturate(100%)" 'backdrop-filter)))))

(define backdrop-sepia
  (make-parameter (append (backdrop-rules "backdrop-sepia"
                                          "--olive-backdrop-sepia"
                                          (percent-values 'sepia))
                          (list (bare-rule ".backdrop-sepia" "--olive-backdrop-sepia"
                                           "sepia(100%)" 'backdrop-filter)))))

(define filter-classes
  (make-parameter (list (blur)
                        (brightness)
                        (contrast)
                        (drop-shadow)
                        (grayscale)
                        (hue-rotate)
                        (invert)
                        (saturate)
                        (sepia)
                        (backdrop-blur)
                        (backdrop-brightness)
                        (backdrop-contrast)
                        (backdrop-grayscale)
                        (backdrop-hue-rotate)
                        (backdrop-invert)
                        (backdrop-opacity)
                        (backdrop-saturate)
                        (backdrop-sepia))))
