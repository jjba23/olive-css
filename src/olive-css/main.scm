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

(define-module (olive-css main)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-13)
  #:use-module (ice-9 string-fun)
  #:use-module (olive-css dsl)
  #:use-module (olive-css sizes)
  #:use-module (olive-css decl colors)
  #:use-module (olive-css decl layout)
  #:use-module (olive-css decl flexbox)
  #:use-module (olive-css decl spacing)
  #:use-module (olive-css decl sizing)
  #:use-module (olive-css decl filters)
  #:use-module (olive-css decl typography)
  #:use-module (olive-css decl animation)
  #:use-module (olive-css decl reset)
  #:use-module (olive-css decl borders)
  #:use-module (olive-css decl grid)
  #:use-module (olive-css decl tables)
  #:use-module (olive-css decl svg)
  #:use-module (olive-css decl effects)
  #:use-module (olive-css decl transforms)
  #:use-module (olive-css decl transitions)
  #:use-module (olive-css decl interactivity)
  #:export (rounded-multiplier olive-css-gen
                               all-responsive
                               reduced-responsive
                               palettes
                               responsive
                               border-radius
                               scroll-snap-aligns
                               scroll-snap-types
                               colors
                               font-family
                               responsive-classes
                               with-dark-mode?
                               mono-font-family
                               sans-font-family
                               serif-font-family
                               write-docs-to-file
                               write-css-to-file
                               minified?
                               core-utility-classes
                               lean-responsive-classes
                               palette-utility-classes
                               color-base-classes
                               utility-classes
                               state-variants
                               state-variant-targets
                               interactive-state-variants
                               interactive-state-targets
                               state-variant-classes))

(define mono-font-family
  (make-parameter '("'Intel One Mono'" "'IBM Plex Mono'" "monospace")))

(define serif-font-family
  (make-parameter '("'DejaVu Serif'" "'IBM Plex Serif'" "ui-serif" "serif"
                    "'Times New Roman'")))

(define sans-font-family
  (make-parameter '("'Lucida Sans'"
                    "'Plus Jakarta Sans'"
                    "'IBM Plex Sans'"
                    "ui-sans-serif"
                    "system-ui"
                    "sans-serif"
                    "'Apple Color Emoji'"
                    "'Segoe UI Emoji'"
                    "'Segoe UI Symbol'"
                    "'Noto Color Emoji'")))

(define (font-family)
  (let* ((rules (list (css-rule ".font-sans"
                                (css-declaration 'font-family
                                                 (string-join (sans-font-family)
                                                              ", ")))
                      (css-rule ".font-mono"
                                (css-declaration 'font-family
                                                 (string-join (mono-font-family)
                                                              ", ")))
                      (css-rule ".font-serif"
                                (css-declaration 'font-family
                                                 (string-join (serif-font-family)
                                                              ", "))))))
    rules))

(define rounded-multiplier
  (make-parameter 0.16))

(define shadow-multiplier
  (make-parameter 0.3))

(define sm-breakpoint
  (make-parameter "640px"))

(define md-breakpoint
  (make-parameter "768px"))

(define lg-breakpoint
  (make-parameter "1024px"))

(define xl-breakpoint
  (make-parameter "1280px"))

(define breakpoints
  (make-parameter `((sm ,(sm-breakpoint))
                    (md ,(md-breakpoint))
                    (lg ,(lg-breakpoint))
                    (xl ,(xl-breakpoint)))))

(define palettes
  (make-parameter (list (cons 'apple-green
                              (apple-green))
                        (cons 'ash-gray
                              (ash-gray))
                        (cons 'asparagus
                              (asparagus))
                        (cons 'beaver
                              (beaver))
                        (cons 'bistre
                              (bistre))
                        (cons 'black-bean
                              (black-bean))
                        (cons 'black-olive
                              (black-olive))
                        (cons 'buff
                              (buff))
                        (cons 'terra
                              (terra))
                        (cons 'cadet-gray
                              (cadet-gray))
                        (cons 'cambridge-green
                              (cambridge-green))
                        (cons 'castleton-green
                              (castleton-green))
                        (cons 'charcoal
                              (charcoal))
                        (cons 'china-rose
                              (china-rose))
                        (cons 'china-violet
                              (china-violet))
                        (cons 'claret
                              (claret))
                        (cons 'coffee
                              (coffee))
                        (cons 'dark-purple
                              (dark-purple))
                        (cons 'ferrari-red
                              (ferrari-red))
                        (cons 'floral-white
                              (floral-white))
                        (cons 'glaucous
                              (glaucous))
                        (cons 'iris
                              (iris))
                        (cons 'jeans-blue
                              (jeans-blue))
                        (cons 'lapis-lazuli
                              (lapis-lazuli))
                        (cons 'light-coral
                              (light-coral))
                        (cons 'mantis
                              (mantis))
                        (cons 'melon
                              (melon))
                        (cons 'midnight-green
                              (midnight-green))
                        (cons 'mikado-yellow
                              (mikado-yellow))
                        (cons 'moonstone
                              (moonstone))
                        (cons 'naples-yellow
                              (naples-yellow))
                        (cons 'onyx
                              (onyx))
                        (cons 'orange
                              (orange))
                        (cons 'olive
                              (olive))
                        (cons 'dark-khaki
                              (dark-khaki))
                        (cons 'pale-dogwood
                              (pale-dogwood))
                        (cons 'papaya-whip
                              (papaya-whip))
                        (cons 'persia-pink
                              (persia-pink))
                        (cons 'pomp-and-power
                              (pomp-and-power))
                        (cons 'prussian-blue
                              (prussian-blue))
                        (cons 'raisin-black
                              (raisin-black))
                        (cons 'redwood
                              (redwood))
                        (cons 'russia-violet
                              (russia-violet))
                        (cons 'sienna
                              (sienna))
                        (cons 'spiced-terracotta
                              (spiced-terracotta))
                        (cons 'stone
                              (stone))
                        (cons 'tawny
                              (tawny))
                        (cons 'tyrian
                              (tyrian))
                        (cons 'umber
                              (umber))
                        (cons 'van-dyke
                              (van-dyke))
                        (cons 'white-smoke
                              (white-smoke))
                        (cons 'wine
                              (wine)))))

(define shadows
  (make-parameter (css-rule-variants ".shadow-~a"
                                     #:property 'box-shadow
                                     #:variants '(("2xs"
                                                   "0 1px rgb(0 0 0 / 0.05)")
                                                  (xs
                                                   "0 1px 2px 0 rgb(0 0 0 / 0.05)")
                                                  (sm
                                                   "0 1px 3px 0 rgb(0 0 0 / 0.1), 0 1px 2px -1px rgb(0 0 0 / 0.1)")
                                                  (md
                                                   "0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1)")
                                                  (lg
                                                   "0 10px 15px -3px rgb(0 0 0 / 0.1), 0 4px 6px -4px rgb(0 0 0 / 0.1)")
                                                  (xl
                                                   "0 20px 25px -5px rgb(0 0 0 / 0.1), 0 8px 10px -6px rgb(0 0 0 / 0.1)")
                                                  ("2xl"
                                                   "0 25px 50px -12px rgb(0 0 0 / 0.25)")
                                                  (none "0 0 #0000")))))

(define scroll-snap-type
  (make-parameter "proximity"))

(define scroll-snap-types
  (make-parameter (css-rule-variants ".snap-~a"
                                     #:property 'scroll-snap-type
                                     #:variants `((none none)
                                                  (x ,(format #f "x ~a"
                                                              (scroll-snap-type)))
                                                  (y ,(format #f "y ~a"
                                                              (scroll-snap-type)))
                                                  (both ,(format #f "both ~a"
                                                                 (scroll-snap-type)))))))

(define scroll-snap-aligns
  (make-parameter (css-rule-variants ".snap-~a"
                                     #:property 'scroll-snap-align
                                     #:variants '((start start)
                                                  (end end)
                                                  (center center)
                                                  (none none)))))

(define (colors palettes)
  (append (css-rule-variants ".bg-~a"
                             #:property 'background
                             #:variants '((inherit inherit)
                                          (white white)
                                          (black black)
                                          (transparent transparent)))
          (css-rule-variants ".text-~a"
                             #:property 'color
                             #:variants '((inherit inherit)
                                          (white white)
                                          (black black)
                                          (transparent transparent)))
          (css-rule-variants ".border-~a"
                             #:property 'border-color
                             #:variants '((inherit inherit)
                                          (white white)
                                          (black black)
                                          (transparent transparent)))
          (css-rule-variants ".decoration-~a"
                             #:property 'text-decoration-color
                             #:variants '((inherit inherit)
                                          (white white)
                                          (black black)
                                          (transparent transparent)))

          (css-color-rules ".bg-~a-~a~a"
                           #:property 'background
                           #:variants (list-combinations alphas color-weights)
                           #:palettes palettes)
          (css-color-rules ".text-~a-~a~a"
                           #:property 'color
                           #:variants (list-combinations alphas color-weights)
                           #:palettes palettes)
          (css-color-rules ".border-~a-~a~a"
                           #:property 'border-color
                           #:variants (list-combinations alphas color-weights)
                           #:palettes palettes)
          (css-color-rules ".decoration-~a-~a~a"
                           #:property 'text-decoration-color
                           #:variants (list-combinations alphas color-weights)
                           #:palettes palettes)))

(define (dark-mode)
  (list '("")
        (css-comment "Load Olive CSS Dark mode")
        ;; A single `:where(...)` scope (rather than a bare top-level `&`) keeps
        ;; the dark-mode block compact while remaining valid CSS nesting.
        (list (format #f "~a {" dark-selector-prefix))
        (add-media-query-prefix 'dark
                                (font-family))
        (add-media-query-prefix 'dark
                                (colors (palettes)))
        (add-media-query-prefix 'dark
                                (filter-classes))
        '("")
        (css-comment "Load Olive CSS Dark mode hover colors")
        ;; The canonical Tailwind order is `dark:hover:'.  Generating both
        ;; orders would double the (large) dark color section, so only this one
        ;; is emitted; `variant-classes' can add alternatives if needed.
        (add-hover-variant "dark\\:hover"
                           (colors (palettes)))
        '("}")))

(define display-utilities
  (make-parameter (list (css-rule ".overflow-x-scroll"
                                  (css-declaration 'overflow-x
                                                   'scroll))
                        (css-rule ".overflow-y-scroll"
                                  (css-declaration 'overflow-y
                                                   'scroll))
                        (css-rule ".cursor-pointer"
                                  (css-declaration 'cursor
                                                   'pointer)))))

(define border-radius
  (make-parameter (append (list (css-rule ".rounded-none"
                                          (css-declaration 'border-radius 0))
                                (css-rule ".rounded-full"
                                          (css-declaration 'border-radius
                                                           "9999px")))
                          (css-rule-variants ".rounded-~a"
                                             #:property 'border-radius
                                             #:variants (map (lambda (s)
                                                               (css-size s
                                                                #:conversion
                                                                to-rem
                                                                #:multiplier (rounded-multiplier)))
                                                             (append
                                                              numeric-sizes
                                                              tshirt-sizes)))

                          (css-rule-variants ".rounded-tl-~a"
                                             #:property 'border-start-start-radius
                                             #:variants (map (lambda (s)
                                                               (css-size s
                                                                #:conversion
                                                                to-rem
                                                                #:multiplier (rounded-multiplier)))
                                                             (append
                                                              numeric-sizes
                                                              tshirt-sizes)))

                          (css-rule-variants ".rounded-tr-~a"
                                             #:property 'border-start-end-radius
                                             #:variants (map (lambda (s)
                                                               (css-size s
                                                                #:conversion
                                                                to-rem
                                                                #:multiplier (rounded-multiplier)))
                                                             (append
                                                              numeric-sizes
                                                              tshirt-sizes)))

                          (css-rule-variants ".rounded-bl-~a"
                                             #:property 'border-end-start-radius
                                             #:variants (map (lambda (s)
                                                               (css-size s
                                                                #:conversion
                                                                to-rem
                                                                #:multiplier (rounded-multiplier)))
                                                             (append
                                                              numeric-sizes
                                                              tshirt-sizes)))

                          (css-rule-variants ".rounded-br-~a"
                                             #:property 'border-end-end-radius
                                             #:variants (map (lambda (s)
                                                               (css-size s
                                                                #:conversion
                                                                to-rem
                                                                #:multiplier (rounded-multiplier)))
                                                             (append
                                                              numeric-sizes
                                                              tshirt-sizes))))))

(define border-style
  (make-parameter 'solid))

(define borders
  (make-parameter (css-rule-variants ".border-~a"
                                     #:property 'border-width
                                     #:other-properties `((border-style ,(border-style)))
                                     #:variants (map (lambda (s)
                                                       (css-size s
                                                                 #:conversion
                                                                 to-px))
                                                     numeric-sizes))))

(define license-header
  (make-parameter
   "olive-css - Utility-class CSS framework that is easy to learn and hack

  Copyright © Josep Bigorra <jjbigorra@gmail.com>

  olive-css is free software: you can redistribute it and/or modify
  it under the terms of the Lesser GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  olive-css is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  Lesser GNU General Public License for more details.

  You should have received a copy of the Lesser GNU General Public License
  along with olive-css.  If not, see <https://www.gnu.org/licenses/>."))

;; ============ Stylesheet Generation Entry-point =========================

(define (visibility-classes)
  (visibility))

(define (core-utility-classes)
  "All structural utility families.

These contain no palette-derived colors and no @code{@keyframes}, so they are
safe to duplicate under media queries and state variants.  Palette-derived
families live in @code{palette-utility-classes} and the main color system is
generated separately by @code{colors}."
  (append (font-family)
          (layout-classes)
          (visibility-classes)
          (filter-classes)
          (flexbox-classes)
          (grid-classes)
          (spacing-classes)
          (sizing-classes)
          (typography-classes)
          (border-radius)
          (borders)
          (border-extras-classes)
          (scroll-snap-aligns)
          (scroll-snap-types)
          (shadows)
          (display-utilities)
          (transform-classes)
          (table-classes)
          (transition-classes)
          (effect-core-classes)
          (interactivity-core-classes)
          (svg-core-classes)))

(define (palette-utility-classes palettes)
  "Palette-derived utilities: ring/outline/accent/caret colors and SVG fill/stroke."
  (append (effect-colors palettes)
          (interactivity-colors palettes)
          (svg-colors palettes)))

(define (color-base-classes palettes)
  "Solid palette colors for bg/text/border/decoration.

Used to give the complete build responsive color parity (e.g. @code{md:bg-x})
without expanding the large opacity-modifier cross-product under every
breakpoint.  The full @code{bg-<color>-<shade>/<opacity>} family is generated
only once by @code{colors}."
  (append (css-palette-rules ".bg-~a-~a"
                             #:property 'background
                             #:palettes palettes)
          (css-palette-rules ".text-~a-~a"
                             #:property 'color
                             #:palettes palettes)
          (css-palette-rules ".border-~a-~a"
                             #:property 'border-color
                             #:palettes palettes)
          (css-palette-rules ".decoration-~a-~a"
                             #:property 'text-decoration-color
                             #:palettes palettes)))

(define (utility-classes palettes)
  "Every utility family generated by olive-css (structural + palette colors)."
  (append (core-utility-classes)
          (palette-utility-classes palettes)
          (colors palettes)))

;; State variants (pseudo-classes) that can be enabled via `state-variants'.
(define state-pseudos
  '((hover . ":hover")
    (focus . ":focus")
    (focus-within . ":focus-within")
    (focus-visible . ":focus-visible")
    (active . ":active")
    (visited . ":visited")
    (target . ":target")
    (disabled . ":disabled")
    (enabled . ":enabled")
    (checked . ":checked")
    (required . ":required")
    (invalid . ":invalid")
    (valid . ":valid")
    (first . ":first-child")
    (last . ":last-child")
    (only . ":only-child")
    (odd . ":nth-child(odd)")
    (even . ":nth-child(even)")
    (empty . ":empty")))

(define state-variants
  (make-parameter '(hover)))

;; When unset, these state variants are generated for fonts, typography,
;; colors, transforms and effects.  Bind it to `core-utility-classes' (or any
;; list of rules) to widen coverage.
(define state-variant-targets
  (make-parameter #f))

(define (default-state-targets)
  (append (font-family)
          (typography-classes)
          (transform-classes)
          (effect-core-classes)
          (shadows)
          (colors (palettes))))

;; A second, lighter tier: focus/active/etc. only need to apply to the
;; interactive utilities (effects, transforms, typography), not to the whole
;; color system, which keeps builds affordable.
(define interactive-state-variants
  (make-parameter '(focus focus-visible active)))

(define interactive-state-targets
  (make-parameter #f))

(define (default-interactive-targets)
  (append (typography-classes)
          (transform-classes)
          (effect-core-classes)))

(define (state-rules states targets)
  (append-map (lambda (state)
                (let ((pseudo (assq state state-pseudos)))
                  (if pseudo
                      (add-state-variant (symbol->string state)
                                         (cdr pseudo) targets)
                      '())))
              states))

(define (state-variant-classes)
  "Generate one rule per enabled state variant over the configured targets."
  (append (state-rules (state-variants)
                       (or (state-variant-targets)
                           (default-state-targets)))
          (state-rules (interactive-state-variants)
                       (or (interactive-state-targets)
                           (default-interactive-targets)))))

(define (lean-responsive-classes)
  "The lean default responsive set.

Historically only a subset of families was duplicated under each breakpoint;
keeping that default means per-project builds stay small.  Bind
@code{responsive-classes} to @code{core-utility-classes} for full responsive
parity (this is what the complete build does)."
  (append (layout-classes)
          (filter-classes)
          (flexbox-classes)
          (spacing-classes)
          (sizing-classes)
          (typography-classes)
          (border-radius)
          (scroll-snap-aligns)
          (scroll-snap-types)
          (font-family)))

(define (get-responsive-classes)
  "Helper to safely get current or default responsive classes dynamically."
  (or (responsive-classes)
      (lean-responsive-classes)))

(define responsive-classes
  (make-parameter #f))

(define (reduced-responsive)
  (append (media-query "width >= 40rem"
                       (map (lambda (r)
                              (add-media-query-prefix 'sm r))
                            (get-responsive-classes)))
          (media-query "width >= 48rem"
                       (map (lambda (r)
                              (add-media-query-prefix 'md r))
                            (get-responsive-classes)))
          (media-query "width >= 64rem"
                       (map (lambda (r)
                              (add-media-query-prefix 'lg r))
                            (get-responsive-classes)))
          (media-query "width >= 80rem"
                       (map (lambda (r)
                              (add-media-query-prefix 'xl r))
                            (get-responsive-classes)))))

(define (all-responsive)
  (append (reduced-responsive)
          (media-query "width >= 96rem"
                       (map (lambda (r)
                              (add-media-query-prefix "2xl" r))
                            (get-responsive-classes)))))

(define responsive
  (make-parameter all-responsive))

(define with-dark-mode?
  (make-parameter #t))

(define* (olive-css-gen)
  (append (css-comment (license-header))
          '("")
          (css-comment "Load CSS browser reset - should be first")
          (reset-css)
          '("")
          (css-comment "Load Olive CSS Hygge Style Sheets")
          (core-utility-classes)
          (palette-utility-classes (palettes))
          (animations)
          (animation-classes)
          '("")
          (css-comment "Load Olive CSS state variants (hover:, focus:, ...)")
          (state-variant-classes)
          '("")
          (css-comment "Load Olive CSS colors")
          (colors (palettes))
          (if (with-dark-mode?)
              (dark-mode)
              '())
          '("")
          (css-comment "Load responsive classes")
          ((responsive))))

;; When true (the default) stylesheets are written minified: no indentation,
;; no newlines between rules and no whitespace after separators.  Bind it to
;; #f (via `parameterize') when debugging generated output.
(define minified?
  (make-parameter #t))

(define* (write-css-to-file #:key file css-lines)
  (catch #t
         (lambda ()
           (delete-file file))
         (lambda _
           (display "")))
  (let ((css (string-join (flatten-list (map format-css css-lines))
                          "\n")))
    (with-output-to-file file
      (lambda ()
        (display (if (minified?)
                     (minify-css css) css))))))

(define* (write-docs-to-file #:key file lines)
  (catch #t
         (lambda ()
           (delete-file file))
         (lambda _
           (display "")))
  (with-output-to-file file
    (lambda ()
      (display (string-join (flatten-list (map format-css lines)) "\n")))))
