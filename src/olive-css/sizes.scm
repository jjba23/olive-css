;; olive-css
;;
;; SPDX-License-Identifier: MIT
;; Copyright © Josep Bigorra <jjbigorra@gmail.com>

(define-module (olive-css sizes)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-13)
  #:use-module (ice-9 string-fun)
  #:export (tshirt-sizes numeric-sizes positive-numeric-sizes
                         weights
                         alphas
                         color-weights
                         fractions
                         trackings
                         stretches
                         numeric-variants))

(define tshirt-sizes
  `(("2xs" 1)
    ("xs" 2)
    ("sm" 3)
    ("md" 4)
    ("lg" 5)
    ("xl" 6)
    ("2xl" 7)
    ("3xl" 8)
    ("4xl" 9)
    ("5xl" 10)))

(define numeric-sizes
  '((0 0)
    (1 1)
    (2 2)
    (3 3)
    (4 4)
    (5 5)
    (6 6)
    (7 7)
    (8 8)
    (9 9)
    (10 10)
    (12 12)
    (14 14)
    (16 16)
    (20 20)
    (24 24)
    (28 28)
    (32 32)
    (48 48)
    (64 64)
    (72 72)
    (90 90)
    (96 96)
    (100 100)
    (128 128)
    (196 196)
    (212 212)
    (256 256)
    (312 312)
    (360 360)
    (420 420)
    (512 512)))

;; The numeric steps without the leading zero.  A zero count is invalid CSS for
;; grid templates (=repeat(0, ...)=), multi-column flow and line clamping, and a
;; negative zero is meaningless for the =.-translate-*= family, so those use this
;; list instead of `numeric-sizes'.
(define positive-numeric-sizes
  (filter (lambda (s)
            (not (equal? 0 (car s))))
          numeric-sizes))

(define weights
  '((thin 100)
    (extralight 200)
    (light 300)
    (normal 400)
    (medium 500)
    (semibold 600)
    (bold 700)
    (extrabold 800)
    (black 900)))

(define fractions
  '(("2\\/3" "66.6%")
    ("1\\/3" "33.3%")
    ("1\\/2" "50%")
    ("3\\/4" "75%")
    ("1\\/4" "25%")
    ("4\\/5" "80%")
    ("3\\/5" "60%")
    ("2\\/5" "40%")
    ("1\\/5" "20%")
    ("5\\/6" "83.3%")
    ("1\\/6" "16.6%")
    ("1\\/8" "12.5%")))

(define color-weights
  '((100 100)
    (300 300)
    (500 500)
    (700 700)
    (900 900)))

(define alphas
  '((1 0.01)
    (5 0.05)
    (10 0.1)
    (25 0.2)
    (50 0.5)
    (75 0.7)
    (90 0.9)
    (95 0.95)
    ("" 1)))

(define trackings
  '((tighter "-0.05em")
    (tight "-0.025em")
    (normal "0em")
    (wide "0.025em")
    (wider "0.05em")
    (widest "0.1em")))

(define stretches
  '((ultra-condensed ultra-condensed)
    (extra-condensed extra-condensed)
    (condensed condensed)
    (semi-condensed semi-condensed)
    (normal normal)
    (semi-expanded semi-expanded)
    (expanded expanded)
    (extra-expanded extra-expanded)
    (ultra-expanded ultra-expanded)))

(define numeric-variants
  '((normal-nums normal)
    (ordinal ordinal)
    (slashed-zero slashed-zero)
    (lining-nums lining-nums)
    (oldstyle-nums oldstyle-nums)
    (proportional-nums proportional-nums)
    (tabular-nums tabular-nums)
    (diagonal-fractions diagonal-fractions)
    (stacked-fractions stacked-fractions)))
