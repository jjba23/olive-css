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

(define-module (olive-css decl effects)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-13)
  #:use-module (ice-9 string-fun)
  #:use-module (olive-css dsl)
  #:use-module (olive-css sizes)
  #:export (effect-classes effect-core-classes opacity mix-blend-mode
                         background-blend-mode text-shadow ring outline
                         inset-ring effect-colors))

(define opacity-scale
  '((0 0) (5 5) (10 10) (15 15) (20 20) (25 25) (30 30) (35 35) (40 40)
    (45 45) (50 50) (55 55) (60 60) (65 65) (70 70) (75 75) (80 80)
    (85 85) (90 90) (95 95) (100 100)))

(define opacity
  (make-parameter (css-rule-variants ".opacity-~a"
                                     #:property 'opacity
                                     #:variants (map (lambda (s)
                                                       (list (car s)
                                                             (format #f "~a"
                                                                     (/ (cadr s)
                                                                        100.0))))
                                                     opacity-scale))))

(define blend-modes
  '((normal normal) (multiply multiply) (screen screen) (overlay overlay)
    (darken darken) (lighten lighten) (color-dodge color-dodge)
    (color-burn color-burn) (hard-light hard-light) (soft-light soft-light)
    (difference difference) (exclusion exclusion) (hue hue)
    (saturation saturation) (color color) (luminosity luminosity)
    (plus-darker plus-darker) (plus-lighter plus-lighter)))

(define mix-blend-mode
  (make-parameter (css-rule-variants ".mix-blend-~a"
                                     #:property 'mix-blend-mode
                                     #:variants blend-modes)))

(define background-blend-mode
  (make-parameter (css-rule-variants ".bg-blend-~a"
                                     #:property 'background-blend-mode
                                     #:variants blend-modes)))

(define text-shadow
  (make-parameter (css-rule-variants ".text-shadow-~a"
                                     #:property 'text-shadow
                                     #:variants '(("2xs" "0 1px 0 rgb(0 0 0 / 0.15)")
                                                  (xs "0 1px 1px rgb(0 0 0 / 0.15)")
                                                  (sm "0 1px 2px rgb(0 0 0 / 0.25)")
                                                  (md "0 2px 4px rgb(0 0 0 / 0.25)")
                                                  (lg "0 4px 8px rgb(0 0 0 / 0.25)")
                                                  (none none)))))

(define ring-widths
  '((0 0) (1 1) (2 2) (4 4) (8 8)))

(define ring
  (make-parameter (append
                   (list (css-rule ".ring"
                                   (css-declaration 'box-shadow
                                                    "var(--olive-ring-inset,) 0 0 0 1px var(--olive-ring-color,rgb(0 0 0 / 0.5))"))
                         (css-rule ".ring-inset"
                                   (css-declaration "--olive-ring-inset"
                                                    "inset")))
                   (css-rule-variants ".ring-~a"
                                      #:property 'box-shadow
                                      #:variants (map (lambda (s)
                                                        (list (car s)
                                                              (format #f
                                                                      "var(--olive-ring-inset,) 0 0 0 ~apx var(--olive-ring-color,rgb(0 0 0 / 0.5))"
                                                                      (cadr s))))
                                                      ring-widths)))))

(define inset-ring
  (make-parameter (css-rule-variants ".inset-ring-~a"
                                     #:property 'box-shadow
                                     #:variants (map (lambda (s)
                                                       (list (car s)
                                                             (format #f
                                                                     "inset 0 0 0 ~apx var(--olive-inset-ring-color,rgb(0 0 0 / 0.5))"
                                                                     (cadr s))))
                                                     ring-widths))))

(define outline
  (make-parameter (append
                   (list (css-rule ".outline-none"
                                   (css-declaration 'outline-style
                                                    'none))
                         (css-rule ".outline-hidden"
                                   (css-declaration 'outline
                                                    "2px solid transparent")
                                   (css-declaration 'outline-offset
                                                    "2px")))
                   (css-rule-variants ".outline-~a"
                                      #:property 'outline-width
                                      #:other-properties '(("outline-style" "solid"))
                                      #:variants (map (lambda (s)
                                                        (css-size s
                                                                  #:conversion
                                                                  to-px))
                                                      '((0 0) (1 1) (2 2)
                                                        (4 4) (8 8))))
                   (css-rule-variants ".outline-offset-~a"
                                      #:property 'outline-offset
                                      #:variants (map (lambda (s)
                                                        (css-size s
                                                                  #:conversion
                                                                  to-px))
                                                      '((0 0) (1 1) (2 2)
                                                        (4 4) (8 8))))
                   (css-rule-variants ".outline-~a"
                                      #:property 'outline-style
                                      #:variants '((solid solid)
                                                   (dashed dashed)
                                                   (dotted dotted)
                                                   (double double))))))

(define (effect-colors palettes)
  "Palette-aware outline/ring color utilities."
  (append
   (css-palette-rules ".outline-~a-~a"
                      #:property 'outline-color
                      #:palettes palettes)
   (css-palette-rules ".ring-~a-~a"
                      #:property "--olive-ring-color"
                      #:palettes palettes)
   (css-palette-rules ".inset-ring-~a-~a"
                      #:property "--olive-inset-ring-color"
                      #:palettes palettes)))

(define (effect-core-classes)
  "Structural effect utilities (no palette-derived colors)."
  (list (opacity)
        (mix-blend-mode)
        (background-blend-mode)
        (text-shadow)
        (ring)
        (inset-ring)
        (outline)))

(define (effect-classes palettes)
  (append (effect-core-classes)
          (list (effect-colors palettes))))
