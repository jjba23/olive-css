;; olive-css
;;
;; SPDX-License-Identifier: MIT
;; Copyright © Josep Bigorra <jjbigorra@gmail.com>

(define-module (olive-css decl transforms)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-13)
  #:use-module (ice-9 string-fun)
  #:use-module (olive-css dsl)
  #:use-module (olive-css sizes)
  #:export (transform-classes transform
                              transform-composition
                              translate
                              translate-z
                              rotate
                              rotate-3d
                              scale
                              skew
                              perspective
                              backface
                              transform-style
                              transform-origin
                              will-change
                              translate-multiplier))

(define translate-multiplier
  (make-parameter 0.28))

;; `translate', `rotate' and `scale' are properties of their own, so the two
;; axes of each compose without help.  `transform' is not: the families that
;; must share it (the skews and the per-axis 3D rotations) write their function
;; into a custom property and re-declare `transform' as the composition, which
;; reads every variable with an empty fallback.
(define transform-variables
  '("--olive-translate-z"
    "--olive-rotate-x"
    "--olive-rotate-y"
    "--olive-rotate-z"
    "--olive-skew-x"
    "--olive-skew-y"))

(define (transform-composition)
  "The value that composes every `transform' family, empty when unset."
  (string-join (map (lambda (variable)
                      (format #f "var(~a,)" variable))
                    transform-variables) " "))

(define* (transform-utilities class-prefix variable variants)
  "One rule per (NAME VALUE) pair in VARIANTS: the function in VARIABLE, plus
`transform' composed from every family variable."
  (map (lambda (variant)
         (css-rule (format #f ".~a-~a" class-prefix (car variant))
                   (css-declaration variable (cadr variant))
                   (css-declaration 'transform
                                    (transform-composition))))
       variants))

(define (translate-utilities axis)
  "The two axes of the independent `translate' property, which composes them
through custom properties."
  (let ((variable (if (equal? axis
                              'x) "--olive-tx" "--olive-ty")))
    (append (css-rule-variants (format #f ".translate-~a-~a" axis "~a")
                               #:property variable
                               #:other-properties `((translate
                                                     ,(format #f
                                                              "var(--olive-tx, 0) var(--olive-ty, 0)")))
                               #:variants (append (map (lambda (s)
                                                         (css-size s
                                                                   #:conversion
                                                                   to-rem
                                                                   #:multiplier
                                                                   (translate-multiplier)))
                                                       (append numeric-sizes
                                                               tshirt-sizes))
                                                  (map css-size fractions)))
            (css-rule-variants (format #f ".-translate-~a-~a" axis "~a")
                               #:property variable
                               #:other-properties `((translate
                                                     ,(format #f
                                                              "var(--olive-tx, 0) var(--olive-ty, 0)")))
                               #:variants (append (map (lambda (s)
                                                         (list (car s)
                                                               (format #f
                                                                       "-~a"
                                                                       (to-rem
                                                                        (cadr
                                                                         s)))))
                                                       positive-numeric-sizes)
                                                  (map (lambda (s)
                                                         (list (car s)
                                                               (format #f
                                                                       "-~a"
                                                                       (cadr s))))
                                                       fractions))))))

(define translate
  (make-parameter (append (translate-utilities 'x)
                          (translate-utilities 'y))))

;; translateZ moves the element towards the viewer, which is what a 3D
;; transform stack needs next to rotate-x and rotate-y.
(define translate-z-scale
  '((0 0)
    (1 1)
    (2 2)
    (3 3)
    (4 4)
    (6 6)
    (8 8)
    (12 12)
    (16 16)
    (24 24)))

(define translate-z
  (make-parameter (append (transform-utilities "translate-z" "--olive-translate-z"
                                               (map (lambda (s)
                                                      (list (car s)
                                                            (format #f
                                                                    "translateZ(~apx)"
                                                                    (cadr s))))
                                                    translate-z-scale))
                          (transform-utilities "-translate-z" "--olive-translate-z"
                                               (map (lambda (s)
                                                      (list (car s)
                                                            (format #f
                                                                    "translateZ(-~apx)"
                                                                    (cadr s))))
                                                    (cdr translate-z-scale))))))

(define degree-scale
  '((0 0)
    (1 1)
    (2 2)
    (3 3)
    (6 6)
    (12 12)
    (45 45)
    (90 90)
    (180 180)))

(define rotate
  (make-parameter (append (css-rule-variants ".rotate-~a"
                                             #:property 'rotate
                                             #:variants (map (lambda (s)
                                                               (list (car s)
                                                                     (format
                                                                             #f
                                                                             "~adeg"
                                                                             (cadr
                                                                              s))))
                                                             degree-scale))
                          (css-rule-variants ".-rotate-~a"
                                             #:property 'rotate
                                             #:variants (map (lambda (s)
                                                               (list (car s)
                                                                     (format
                                                                             #f
                                                                             "-~adeg"
                                                                             (cadr
                                                                              s))))
                                                             (cdr degree-scale))))))

;; The 3D rotations have no property of their own, so they accumulate into
;; `transform' through `--olive-rotate-x' and friends.
(define (rotate-axis axis)
  (let* ((function (format #f "rotate~a" (string-upcase axis)))
         (variable (format #f "--olive-rotate-~a" axis))
         (degrees (map (lambda (s)
                         (list (car s)
                               (format #f "~a(~adeg)" function (cadr s))))
                       degree-scale))
         (negatives (map (lambda (s)
                           (list (car s)
                                 (format #f "~a(-~adeg)" function (cadr s))))
                         (cdr degree-scale))))
    (append (transform-utilities (format #f "rotate-~a" axis) variable
                                 degrees)
            (transform-utilities (format #f "-rotate-~a" axis) variable
                                 negatives))))

(define rotate-3d
  (make-parameter (append (rotate-axis "x")
                          (rotate-axis "y")
                          (rotate-axis "z"))))

(define scale-scale
  '((0 0)
    (50 50)
    (75 75)
    (90 90)
    (95 95)
    (100 100)
    (105 105)
    (110 110)
    (125 125)
    (150 150)))

(define (percent x)
  (format #f "~a"
          (/ x 100.0)))

(define scale
  (make-parameter (append (css-rule-variants ".scale-~a"
                                             #:property 'scale
                                             #:variants (map (lambda (s)
                                                               (list (car s)
                                                                     (percent (cadr
                                                                               s))))
                                                             scale-scale))
                          (css-rule-variants ".scale-x-~a"
                                             #:property 'scale
                                             #:variants (map (lambda (s)
                                                               (list (car s)
                                                                     (format
                                                                             #f
                                                                             "~a 1"
                                                                             (percent
                                                                              (cadr
                                                                               s)))))
                                                             scale-scale))
                          (css-rule-variants ".scale-y-~a"
                                             #:property 'scale
                                             #:variants (map (lambda (s)
                                                               (list (car s)
                                                                     (format
                                                                             #f
                                                                             "1 ~a"
                                                                             (percent
                                                                              (cadr
                                                                               s)))))
                                                             scale-scale))
                          (css-rule-variants ".scale-z-~a"
                                             #:property 'scale
                                             #:variants (map (lambda (s)
                                                               (list (car s)
                                                                     (format
                                                                             #f
                                                                             "1 1 ~a"
                                                                             (percent
                                                                              (cadr
                                                                               s)))))
                                                             scale-scale)))))

(define skew-degrees
  '((0 0)
    (1 1)
    (2 2)
    (3 3)
    (6 6)
    (12 12)))

(define (skew-axis axis)
  (let* ((function (format #f "skew~a" (string-upcase axis)))
         (variable (format #f "--olive-skew-~a" axis))
         (degrees (map (lambda (s)
                         (list (car s)
                               (format #f "~a(~adeg)" function (cadr s))))
                       skew-degrees))
         (negatives (map (lambda (s)
                           (list (car s)
                                 (format #f "~a(-~adeg)" function (cadr s))))
                         (cdr skew-degrees))))
    (append (transform-utilities (format #f "skew-~a" axis) variable
                                 degrees)
            (transform-utilities (format #f "-skew-~a" axis) variable
                                 negatives))))

(define skew
  (make-parameter (append (skew-axis "x")
                          (skew-axis "y"))))

;; `perspective' is a property of its own: it applies to the children of the
;; element, so it is not part of the `transform' composition.
(define perspective-scale
  '(("dramatic" "100px")
    (near "300px")
    (normal "500px")
    (midrange "800px")
    (distant "1200px")))

(define perspective
  (make-parameter (append (css-rule-variants ".perspective-~a"
                                             #:property 'perspective
                                             #:variants perspective-scale)
                          (list (css-rule ".perspective-none"
                                          (css-declaration 'perspective
                                                           'none))))))

(define backface
  (make-parameter (css-rule-variants ".backface-~a"
                                     #:property 'backface-visibility
                                     #:variants '((hidden hidden)
                                                  (visible visible)))))

(define transform-style
  (make-parameter (css-rule-variants ".transform-~a"
                                     #:property 'transform-style
                                     #:variants '(("3d" preserve-3d)
                                                  (flat flat)))))

(define transform
  (make-parameter (list (css-rule ".transform-none"
                                  (css-declaration 'transform
                                                   'none))
                        (css-rule ".transform-gpu"
                                  (css-declaration 'transform "translateZ(0)"))
                        (css-rule ".transform-cpu"
                                  (css-declaration 'transform "translateZ(0)")))))

(define transform-origin
  (make-parameter (css-rule-variants ".origin-~a"
                                     #:property 'transform-origin
                                     #:variants '((center center)
                                                  (top top)
                                                  (top-right "top right")
                                                  (right right)
                                                  (bottom-right "bottom right")
                                                  (bottom bottom)
                                                  (bottom-left "bottom left")
                                                  (left left)
                                                  (top-left "top left")))))

(define will-change
  (make-parameter (css-rule-variants ".will-change-~a"
                                     #:property 'will-change
                                     #:variants '((auto auto)
                                                  (scroll scroll-position)
                                                  (contents contents)
                                                  (transform transform)
                                                  (opacity opacity)))))

(define transform-classes
  (make-parameter (list (translate)
                        (translate-z)
                        (rotate)
                        (rotate-3d)
                        (scale)
                        (skew)
                        (perspective)
                        (backface)
                        (transform-style)
                        (transform)
                        (transform-origin)
                        (will-change))))
