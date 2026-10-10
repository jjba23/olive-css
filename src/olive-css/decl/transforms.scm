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

(define-module (olive-css decl transforms)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-13)
  #:use-module (ice-9 string-fun)
  #:use-module (olive-css dsl)
  #:use-module (olive-css sizes)
  #:export (transform-classes transform
                              translate
                              rotate
                              scale
                              skew
                              transform-origin
                              will-change
                              translate-multiplier))

(define translate-multiplier
  (make-parameter 0.28))

;; The independent `translate' property composes the two axes through custom
;; properties, so `.translate-x-4 .translate-y-2' both survive.
(define translate-composition
  "var(--olive-tx, 0) var(--olive-ty, 0)")

(define (axis-translate axis)
  (let ((var (if (equal? axis
                         'x) "--olive-tx" "--olive-ty")))
    (append (css-rule-variants (format #f ".translate-~a-~a" axis "~a")
                               #:property var
                               #:other-properties `((translate ,translate-composition))
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
                               #:property var
                               #:other-properties `((translate ,translate-composition))
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
  (make-parameter (append (axis-translate 'x)
                          (axis-translate 'y))))

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
                                                             scale-scale)))))

(define skew-degrees
  '((0 0)
    (1 1)
    (2 2)
    (3 3)
    (6 6)
    (12 12)))

(define skew
  (make-parameter (append (css-rule-variants ".skew-x-~a"
                                             #:property 'transform
                                             #:variants (map (lambda (s)
                                                               (list (car s)
                                                                     (format
                                                                             #f
                                                                             "skewX(~adeg)"
                                                                             (cadr
                                                                              s))))
                                                             skew-degrees))
                          (css-rule-variants ".skew-y-~a"
                                             #:property 'transform
                                             #:variants (map (lambda (s)
                                                               (list (car s)
                                                                     (format
                                                                             #f
                                                                             "skewY(~adeg)"
                                                                             (cadr
                                                                              s))))
                                                             skew-degrees))
                          (css-rule-variants ".-skew-x-~a"
                                             #:property 'transform
                                             #:variants (map (lambda (s)
                                                               (list (car s)
                                                                     (format
                                                                             #f
                                                                             "skewX(-~adeg)"
                                                                             (cadr
                                                                              s))))
                                                             (cdr skew-degrees)))
                          (css-rule-variants ".-skew-y-~a"
                                             #:property 'transform
                                             #:variants (map (lambda (s)
                                                               (list (car s)
                                                                     (format
                                                                             #f
                                                                             "skewY(-~adeg)"
                                                                             (cadr
                                                                              s))))
                                                             (cdr skew-degrees))))))

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
                        (rotate)
                        (scale)
                        (skew)
                        (transform)
                        (transform-origin)
                        (will-change))))
