;; olive-css
;;
;; SPDX-License-Identifier: MIT
;; Copyright © Josep Bigorra <jjbigorra@gmail.com>

(define-module (olive-css main)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-13)
  #:use-module (ice-9 string-fun)
  #:use-module (olive-css dsl)
  #:use-module (olive-css sizes)
  #:use-module (olive-css decl colors)
  #:use-module (olive-css decl layout)
  #:use-module (olive-css decl backgrounds)
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
  #:use-module (olive-css decl masks)
  #:use-module (olive-css decl transforms)
  #:use-module (olive-css decl transitions)
  #:use-module (olive-css decl interactivity)
  #:use-module (olive-css license)
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
                               shadows
                               shadow-colors
                               utility-classes
                               state-variants
                               state-variant-targets
                               interactive-state-variants
                               interactive-state-targets
                               state-variant-classes
                               selector-variants
                               selector-variant-targets
                               selector-variant-classes
                               default-selector-variant-targets
                               at-rule-variants
                               at-rule-variant-targets
                               at-rule-variant-classes
                               default-at-rule-variant-targets
                               aria-variants
                               data-variants
                               container-breakpoints
                               container-variants
                               variant-classes)
  #:re-export (license-header background-classes gradient-classes
                           gradient-color-classes color-scheme
                           forced-color-adjust mask-classes))

;; The three families Olive CSS reaches for by default: JuliaMono for code,
;; Work Sans for prose and Source Serif 4 for long-form reading.  All three are
;; libre (SIL Open Font License) and self-hosted by the project that uses them;
;; the faces are declared in a `fonts.css' beside the stylesheet, see
;; "Fonts" in the README.
(define mono-font-family
  (make-parameter '("'JuliaMono'" "ui-monospace" "'SFMono-Regular'"
                    "'Cascadia Mono'" "monospace")))

(define serif-font-family
  (make-parameter '("'Source Serif 4'" "ui-serif" "'Source Serif Pro'"
                    "Georgia" "'Times New Roman'" "serif")))

(define sans-font-family
  (make-parameter '("'Work Sans'" "ui-sans-serif" "system-ui" "sans-serif"
                    "'Apple Color Emoji'" "'Segoe UI Emoji'"
                    "'Segoe UI Symbol'" "'Noto Color Emoji'")))

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

;; Every shadow colour reads `--olive-shadow-color' with its own black as the
;; fallback, so `.shadow-<palette>-<shade>' only has to set the variable and
;; the geometry, blur and spread of the shadow stay as they were.
(define (shadow-color color)
  (format #f "var(--olive-shadow-color, ~a)" color))

(define shadows
  (make-parameter (css-rule-variants ".shadow-~a"
                                     #:property 'box-shadow
                                     #:variants (list (list "2xs"
                                                            (format #f
                                                                    "0 1px ~a"
                                                                    (shadow-color
                                                                     "rgb(0 0 0 / 0.05)")))
                                                      (list 'xs
                                                            (format #f
                                                                    "0 1px 2px 0 ~a"
                                                                    (shadow-color
                                                                     "rgb(0 0 0 / 0.05)")))
                                                      (list 'sm
                                                            (format #f
                                                                    "0 1px 3px 0 ~a, 0 1px 2px -1px ~a"
                                                                    (shadow-color
                                                                     "rgb(0 0 0 / 0.1)")
                                                                    (shadow-color
                                                                     "rgb(0 0 0 / 0.1)")))
                                                      (list 'md
                                                            (format #f
                                                                    "0 4px 6px -1px ~a, 0 2px 4px -2px ~a"
                                                                    (shadow-color
                                                                     "rgb(0 0 0 / 0.1)")
                                                                    (shadow-color
                                                                     "rgb(0 0 0 / 0.1)")))
                                                      (list 'lg
                                                            (format #f
                                                                    "0 10px 15px -3px ~a, 0 4px 6px -4px ~a"
                                                                    (shadow-color
                                                                     "rgb(0 0 0 / 0.1)")
                                                                    (shadow-color
                                                                     "rgb(0 0 0 / 0.1)")))
                                                      (list 'xl
                                                            (format #f
                                                                    "0 20px 25px -5px ~a, 0 8px 10px -6px ~a"
                                                                    (shadow-color
                                                                     "rgb(0 0 0 / 0.1)")
                                                                    (shadow-color
                                                                     "rgb(0 0 0 / 0.1)")))
                                                      (list "2xl"
                                                            (format #f
                                                                    "0 25px 50px -12px ~a"
                                                                    (shadow-color
                                                                     "rgb(0 0 0 / 0.25)")))
                                                      (list 'none "0 0 #0000")))))

(define (shadow-colors palettes)
  "Palette shadow colours: `.shadow-onyx-500' recolours every shadow utility."
  (css-palette-rules ".shadow-~a-~a"
                     #:property '--olive-shadow-color
                     #:palettes palettes))

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

;; ============ Stylesheet Generation Entry-point =========================

(define (visibility-classes)
  (visibility))

(define (core-utility-classes)
  "All structural utility families.

These contain no palette-derived colors and no @code{@@keyframes}, so they are
safe to duplicate under media queries and state variants.  Palette-derived
families live in @code{palette-utility-classes} and the main color system is
generated separately by @code{colors}."
  (append (font-family)
          (layout-classes)
          (background-classes)
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
          (mask-classes)
          (interactivity-core-classes)
          (svg-core-classes)))

(define (palette-utility-classes palettes)
  "Palette-derived utilities.

Ring, outline, accent and caret colors, SVG fill and stroke, the gradient
stops, the shadow colour and the child-divider colours.  They all come from the
same palettes but are generated once, since none of them is duplicated under a
breakpoint."
  (append (effect-colors palettes)
          (interactivity-colors palettes)
          (gradient-color-classes palettes)
          (shadow-colors palettes)
          (divide-colors palettes)
          (svg-colors palettes)))

(define (color-base-classes palettes)
  "Solid palette colors for bg/text/border/decoration.

Used to give the complete build responsive color parity (e.g. @code{md:bg-x})
and the variant layers a palette to work with, without expanding the large
opacity-modifier cross-product under every breakpoint or variant.  The full
@code{bg-<color>-<shade>/<opacity>} family is generated only once by
@code{colors}."
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
;; The pseudo-elements at the end are what `before:content-empty' and friends
;; are written with; a state variant appends its pseudo, so they compose with
;; any of the classes above.
(define state-pseudos
  '((hover . ":hover") (focus . ":focus")
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
    (empty . ":empty")
    (before . "::before")
    (after . "::after")
    (placeholder . "::placeholder")
    (marker . "::marker")
    (selection . "::selection")
    (file . "::file-selector-button")
    (first-line . "::first-line")
    (first-letter . "::first-letter")))

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
;; color system, which keeps builds affordable.  `before' and `after' are here
;; because that is how the `content-*' utilities reach a pseudo-element.
(define interactive-state-variants
  (make-parameter '(focus focus-visible active before after)))

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
                      '()))) states))

(define (state-variant-classes)
  "Generate one rule per enabled state variant over the configured targets."
  (append (state-rules (state-variants)
                       (or (state-variant-targets)
                           (default-state-targets)))
          (state-rules (interactive-state-variants)
                       (or (interactive-state-targets)
                           (default-interactive-targets)))))

;; ============ Variants that reshape the selector ==========================
;;
;; A state variant only appends a pseudo-class, which is why it could be a
;; string prefix.  The rest of the families cannot: group and peer name a
;; relationship between two elements, has/not wrap the state in a functional
;; pseudo-class, aria/data name an attribute, and rtl/ltr scope the rule with
;; `:where'.  Those are shapes, so a variant is a name plus a function from the
;; variant class selector to the selector that is written.

(define aria-variants
  (make-parameter '(("busy" . "[aria-busy=true]")
                    ("checked" . "[aria-checked=true]")
                    ("current" . "[aria-current=page]")
                    ("disabled" . "[aria-disabled=true]")
                    ("expanded" . "[aria-expanded=true]")
                    ("hidden" . "[aria-hidden=true]")
                    ("invalid" . "[aria-invalid=true]")
                    ("pressed" . "[aria-pressed=true]")
                    ("readonly" . "[aria-readonly=true]")
                    ("required" . "[aria-required=true]")
                    ("selected" . "[aria-selected=true]"))))

;; The data attribute vocabulary that is generated.  It cannot be discovered
;; the way ARIA can: any `data-' attribute is legal, so a build lists the
;; values its markup sets and extends this parameter with its own.
(define data-variants
  (make-parameter '(("active" . "[data-active]")
                    ("checked" . "[data-checked]")
                    ("closed" . "[data-closed]")
                    ("disabled" . "[data-disabled]")
                    ("inactive" . "[data-inactive]")
                    ("loading" . "[data-loading]")
                    ("open" . "[data-open]")
                    ("selected" . "[data-selected]"))))

(define (state-pseudo name)
  "The pseudo-class of the state variant NAME, or #f when there is none."
  (let ((entry (assq (string->symbol name) state-pseudos)))
    (and entry (cdr entry))))

(define (attribute-selector name variants)
  "The attribute selector registered for NAME in VARIABLES, or #f."
  (let ((entry (assoc name variants)))
    (and entry (cdr entry))))

(define (selector-variant-shaper name)
  "The selector shape of variant NAME, or #f when NAME is not a selector
variant.  The shaper receives the variant class selector and returns the
selector to emit."
  (cond
    ((string-prefix? "group-" name)
     (let ((pseudo (state-pseudo (string-drop name 6))))
       (and pseudo (lambda (cls)
                     (format #f ".group~a ~a" pseudo cls)))))
    ((string-prefix? "peer-" name)
     (let ((pseudo (state-pseudo (string-drop name 5))))
       (and pseudo (lambda (cls)
                     (format #f ".peer~a ~~ ~a" pseudo cls)))))
    ;; :has() has no depth limit: `has-checked' matches any descendant, which
    ;; is what the markup asks for and costs nothing to author.
    ((string-prefix? "has-" name)
     (let ((pseudo (state-pseudo (string-drop name 4))))
       (and pseudo (lambda (cls)
                     (format #f "~a:has(~a)" cls pseudo)))))
    ((string-prefix? "not-" name)
     (let ((pseudo (state-pseudo (string-drop name 4))))
       (and pseudo (lambda (cls)
                     (format #f "~a:not(~a)" cls pseudo)))))
    ((string-prefix? "aria-" name)
     (let ((attr (attribute-selector (string-drop name 5)
                                     (aria-variants))))
       (and attr (lambda (cls)
                   (format #f "~a~a" cls attr)))))
    ((string-prefix? "data-" name)
     (let ((attr (attribute-selector (string-drop name 5)
                                     (data-variants))))
       (and attr (lambda (cls)
                   (format #f "~a~a" cls attr)))))
    ((member name '("rtl" "ltr"))
     (lambda (cls)
       (format #f "~a:where([dir=~a], [dir=~a] *)" cls name name)))
    (else #f)))

;; The selector variants a build generates, as class prefixes.  Only
;; `group-hover' and `peer-checked' are on by default; anything else in the
;; vocabulary (group-*, peer-*, has-*, not-*, aria-*, data-*, rtl, ltr) is one
;; entry away.
(define selector-variants
  (make-parameter '("group-hover" "peer-checked")))

;; Families the selector variants apply to; #f uses the broad-but-affordable
;; tier below.  Bind it to `(default-state-targets)' for the full colour
;; cross-product under every variant.
(define selector-variant-targets
  (make-parameter #f))

(define (default-selector-variant-targets)
  "The families a selector variant covers by default.

The interactive tier plus the solid palette colours: `group-hover:bg-x-500'
is the reason these variants exist, while the whole opacity cross-product is
generated once by `colors' rather than once per variant - the same trade
`color-base-classes' makes for the responsive layer.  Filters are left out
because their composed value is long and a hover-only blur is rare; bind
`selector-variant-targets' to widen."
  (append (default-interactive-targets)
          (font-family)
          (shadows)
          (color-base-classes (palettes))))

(define (selector-variant-classes)
  "One rule per enabled selector variant over the configured families."
  (append-map (lambda (name)
                (let ((shaper (selector-variant-shaper name)))
                  (if shaper
                      (flatten-list
                       (add-selector-variant name shaper
                                             (or (selector-variant-targets)
                                                 (default-selector-variant-targets))))
                      (begin (format (current-error-port)
                                     "warning: unknown selector variant: ~a~%"
                                     name) '()))))
              (selector-variants)))

;; At-rule variants need no selector work: the class is named after the
;; variant and the block around it does the qualifying.
(define at-rule-variants
  (make-parameter '(("print" . "@media print")
                    ("motion-safe"
                     .
                     "@media (prefers-reduced-motion: no-preference)")
                    ("motion-reduce"
                     .
                     "@media (prefers-reduced-motion: reduce)"))))

;; Families the at-rule variants apply to; #f uses the structural tier below.
(define at-rule-variant-targets
  (make-parameter #f))

(define (default-at-rule-variant-targets)
  "The families an at-rule variant covers by default.

Layout, box, type, transforms and effects are what a media query or a print
stylesheet changes (`print:hidden', `motion-reduce:transition-none'), and
colours stay out so the palette is not duplicated under every at-rule.  Unit
spacing is left out as well: it is the largest family and `@sm:p-4' is rare
next to `@sm:flex', so bind `at-rule-variant-targets' to
`(default-at-rule-variant-targets)' plus `(spacing-classes)' to have it."
  (append (layout-classes)
          (display-utilities)
          (flexbox-classes)
          (sizing-classes)
          (typography-classes)
          (transform-classes)
          (transition-classes)
          (effect-core-classes)
          (shadows)))

;; Container query scales, in the vocabulary Tailwind v4 uses.  The class name
;; is the quoted prefix, e.g. `@sm:flex' -> `.\\@sm\\:flex'.
(define container-breakpoints
  (make-parameter '(("sm" . "24rem")
                    ("md" . "28rem")
                    ("lg" . "32rem")
                    ("xl" . "36rem")
                    ("2xl" . "42rem")
                    ("3xl" . "48rem")
                    ("4xl" . "56rem")
                    ("5xl" . "64rem")
                    ("6xl" . "72rem")
                    ("7xl" . "80rem"))))

(define container-variants
  (make-parameter '("sm" "md" "lg" "xl")))

(define (at-rule-variant-classes)
  "One at-rule block per enabled media or container variant."
  (define targets
    (or (at-rule-variant-targets)
        (default-at-rule-variant-targets)))
  (define (variant-block name prelude)
    (at-rule-block prelude
                   (flatten-list (add-selector-variant name identity
                                                       targets))))
  (append (map (lambda (spec)
                 (variant-block (car spec)
                                (cdr spec)))
               (at-rule-variants))
          (map (lambda (bp)
                 (variant-block (format #f "@~a" (car bp))
                                (format #f "@container (width >= ~a)"
                                        (cdr bp))))
               (filter (lambda (bp)
                         (member (car bp)
                                 (container-variants)))
                       (container-breakpoints)))))

(define (variant-classes)
  "Every generated variant: selector shapes, then at-rule blocks."
  (append (selector-variant-classes)
          (at-rule-variant-classes)))

(define (lean-responsive-classes)
  "The lean default responsive set.

Historically only a subset of families was duplicated under each breakpoint;
keeping that default means per-project builds stay small.  Bind
@code{responsive-classes} to @code{core-utility-classes} for full responsive
parity (this is what the complete build does)."
  (append (layout-classes)
          (background-classes)
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
          (css-comment "Load Olive CSS selector and at-rule variants (group-hover:, peer-checked:, has-, aria-, data-, rtl:, print:, @sm:, ...)")
          (variant-classes)
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
  (let ((css (string-join (flatten-list (map format-css css-lines)) "\n")))
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
