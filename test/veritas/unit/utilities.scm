;; olive-css
;;
;; SPDX-License-Identifier: MIT
;; Copyright © Josep Bigorra <jjbigorra@gmail.com>

;;; Commentary:
;;;
;;; Tests for the background image utilities and the scroll margin/padding
;;; spacing additions.  The families are emitted through the same record
;;; pipeline as the rest of Olive CSS, so the check is the generated CSS.
;;;
;;;
;;; Code:

(define-module (veritas unit utilities)
  #:use-module (ice-9 textual-ports)
  #:use-module (veritas veritas)
  #:use-module (olive-css main)
  #:use-module ((olive-css dsl) #:select (minify-css))
  #:use-module (olive-css decl colors)
  #:use-module (olive-css decl spacing)
  #:export (spec))

(define (css-of classes)
  "Write CLASSES to a temporary stylesheet and return its text."
  (let ((test-file (string-append "/tmp/olive-css-utilities-"
                                  (number->string (getpid))
                                  "-"
                                  (symbol->string (gensym "css-"))
                                  ".css")))
    (dynamic-wind
      (lambda () #t)
      (lambda ()
        (parameterize ((minified? #f))
          (write-css-to-file #:file test-file #:css-lines classes))
        (call-with-input-file test-file get-string-all))
      (lambda ()
        (when (file-exists? test-file)
          (delete-file test-file))))))

(define background-suite
  (suite "background images"
         (test "position, size, repeat, attachment, clip and origin"
               (let ((css (css-of (background-classes))))
                 (assert-contains #:expect css #:got ".bg-center"
                                  #:name "background position")
                 (assert-contains #:expect css
                                  #:got "background-position:center"
                                  #:name "the position declaration")
                 (assert-contains #:expect css #:got ".bg-cover"
                                  #:name "background size")
                 (assert-contains #:expect css
                                  #:got "background-size:cover"
                                  #:name "the size declaration")
                 (assert-contains #:expect css #:got ".bg-repeat-x"
                                  #:name "background repeat")
                 (assert-contains #:expect css
                                  #:got "background-repeat:repeat-x"
                                  #:name "the repeat declaration")
                 (assert-contains #:expect css #:got ".bg-fixed"
                                  #:name "background attachment")
                 (assert-contains #:expect css
                                  #:got "background-attachment:fixed"
                                  #:name "the attachment declaration")
                 (assert-contains #:expect css #:got ".bg-clip-text"
                                  #:name "background clip")
                 (assert-contains #:expect css
                                  #:got "background-clip:text"
                                  #:name "the clip declaration")
                 (assert-contains #:expect css #:got ".bg-origin-content"
                                  #:name "background origin")
                 (assert-contains #:expect css
                                  #:got "background-origin:content-box"
                                  #:name "the origin declaration")
                 (assert-contains #:expect css #:got ".bg-none"
                                  #:name "background image none")
                 (assert-contains #:expect css
                                  #:got "background-image:none"
                                  #:name "the none declaration")))))

(define scroll-spacing-suite
  (suite "scroll spacing"
         (test "scroll margin and padding use the spacing scale"
               (let ((css (css-of (list (scroll-margin)
                                        (scroll-padding)))))
                 (assert-contains #:expect css #:got ".scroll-m-4"
                                  #:name "scroll margin")
                 (assert-contains #:expect css #:got "scroll-margin:"
                                  #:name "the margin declaration")
                 (assert-contains #:expect css #:got ".scroll-mt-8"
                                  #:name "one scroll margin side")
                 (assert-contains #:expect css #:got "scroll-margin-top:"
                                  #:name "the side declaration")
                 (assert-contains #:expect css #:got ".scroll-px-4"
                                  #:name "scroll padding inline")
                 (assert-contains #:expect css
                                  #:got "scroll-padding-inline:"
                                  #:name "the inline declaration")
                 (assert-contains #:expect css #:got ".scroll-pb-2"
                                  #:name "one scroll padding side")
                 (assert-contains #:expect css
                                  #:got "scroll-padding-bottom:"
                                  #:name "the padding side declaration")))))

(define gradient-suite
  (suite "gradients"
         (test "directions and palette stops"
               (let ((css (css-of (append (gradient-classes)
                                          (gradient-color-classes
                                           (list (cons 'redwood
                                                       (redwood))))))))
                 (assert-contains #:expect css #:got ".bg-linear-to-r"
                                  #:name "the Tailwind v4 direction")
                 (assert-contains #:expect css
                                  #:got "linear-gradient(to right, var(--olive-gradient-stops))"
                                  #:name "the linear direction")
                 (assert-contains #:expect css #:got ".bg-gradient-to-r"
                                  #:name "the familiar alias")
                 (assert-contains #:expect css #:got ".bg-radial"
                                  #:name "radial gradients")
                 (assert-contains #:expect css
                                  #:got "radial-gradient(var(--olive-gradient-stops))"
                                  #:name "the radial direction")
                 (assert-contains #:expect css #:got ".bg-conic"
                                  #:name "conic gradients")
                 (assert-contains #:expect css #:got ".bg-linear-45"
                                  #:name "a linear angle")
                 (assert-contains #:expect css
                                  #:got "linear-gradient(45deg, var(--olive-gradient-stops))"
                                  #:name "the angle declaration")
                 (assert-contains #:expect css #:got ".from-redwood-500"
                                  #:name "a from stop")
                 (assert-contains #:expect css #:got "--olive-gradient-from:oklch("
                                  #:name "the from color")
                 (assert-contains #:expect css #:got ".via-redwood-500"
                                  #:name "a via stop")
                 (assert-contains #:expect css #:got "--olive-gradient-via:oklch("
                                  #:name "the via color")
                 (assert-contains #:expect css #:got ".to-redwood-500"
                                  #:name "a to stop")
                 (assert-contains #:expect css
                                  #:got "--olive-gradient-stops:var(--olive-gradient-from),"
                                  #:name "the from stop joins the gradient")
                 (assert-contains #:expect css
                                  #:got "var(--olive-gradient-via)"
                                  #:name "the via stop joins the gradient")
                 (assert-contains #:expect css #:got ".from-transparent"
                                  #:name "a transparent stop")
                 (assert-contains #:expect css
                                  #:got "--olive-gradient-from:transparent"
                                  #:name "the transparent value")))))

(define logical-spacing-suite
  (suite "logical and negative spacing"
         (test "logical sides and negative margins"
               (let ((css (css-of (list (margin)
                                        (padding)))))
                 (assert-contains #:expect css #:got ".ms-4"
                                  #:name "logical margin start")
                 (assert-contains #:expect css
                                  #:got "margin-inline-start:1.12rem"
                                  #:name "the logical margin start value")
                 (assert-contains #:expect css #:got ".me-4"
                                  #:name "logical margin end")
                 (assert-contains #:expect css
                                  #:got "margin-inline-end:1.12rem"
                                  #:name "the logical margin end value")
                 (assert-contains #:expect css #:got ".ms-auto"
                                  #:name "logical automatic margin")
                 (assert-contains #:expect css #:got ".ps-4"
                                  #:name "logical padding start")
                 (assert-contains #:expect css
                                  #:got "padding-inline-start:1.12rem"
                                  #:name "the logical padding start value")
                 (assert-contains #:expect css #:got ".pe-4"
                                  #:name "logical padding end")
                 (assert-contains #:expect css
                                  #:got "padding-inline-end:1.12rem"
                                  #:name "the logical padding end value")
                 (assert-contains #:expect css #:got "-m-4"
                                  #:name "negative margin")
                 (assert-contains #:expect css #:got "-1.12rem"
                                  #:name "the negative value")
                 (assert-contains #:expect css #:got "-mt-8"
                                  #:name "negative side margin")))))

(define forced-color-suite
  (suite "forced color adjustment"
         (test "forced-color-adjust auto and none"
               (let ((css (css-of (forced-color-adjust))))
                 (assert-contains #:expect css #:got ".forced-color-adjust-none"
                                  #:name "none")
                 (assert-contains #:expect css
                                  #:got "forced-color-adjust:none"
                                  #:name "the none value")
                 (assert-contains #:expect css #:got ".forced-color-adjust-auto"
                                  #:name "auto")
                 (assert-contains #:expect css
                                  #:got "forced-color-adjust:auto"
                                  #:name "the auto value")))))

(define color-scheme-suite
  (suite "color scheme"
         (test "scheme utilities set the color-scheme property"
               (let ((css (css-of (color-scheme))))
                 (assert-contains #:expect css #:got ".scheme-light"
                                  #:name "light")
                 (assert-contains #:expect css #:got "color-scheme:light"
                                  #:name "the light value")
                 (assert-contains #:expect css #:got ".scheme-light-dark"
                                  #:name "light and dark")
                 (assert-contains #:expect css #:got "color-scheme:light dark"
                                  #:name "the light-dark value")
                 (assert-contains #:expect css #:got ".scheme-only-dark"
                                  #:name "only dark")
                 (assert-contains #:expect css #:got "color-scheme:only dark"
                                  #:name "the only-dark value")))))

(define mask-suite
  (suite "masks"
         (test "gradient masks and edge fades"
               (let ((css (css-of (mask-classes))))
                 (assert-contains #:expect css #:got ".mask-none"
                                  #:name "mask removal")
                 (assert-contains #:expect css
                                  #:got "mask-image:none"
                                  #:name "the none declaration")
                 (assert-contains #:expect css #:got ".mask-linear-45"
                                  #:name "an angled linear mask")
                 (assert-contains #:expect css
                                  #:got "--olive-mask-linear-angle:45deg"
                                  #:name "the linear angle")
                 (assert-contains #:expect css
                                  #:got "linear-gradient(var(--olive-mask-linear-angle,0deg),black var(--olive-mask-linear-from,0%),transparent var(--olive-mask-linear-to,100%))"
                                  #:name "the linear image")
                 (assert-contains #:expect css
                                  #:got "mask-linear-from-50"
                                  #:name "a linear from stop")
                 (assert-contains #:expect css
                                  #:got "--olive-mask-linear-from:50%"
                                  #:name "the linear from value")
                 (assert-contains #:expect css #:got ".mask-radial"
                                  #:name "a radial mask")
                 (assert-contains #:expect css
                                  #:got "radial-gradient(var(--olive-mask-radial-shape,ellipse) var(--olive-mask-radial-size,farthest-corner) at var(--olive-mask-radial-position,center),black var(--olive-mask-radial-from,0%),transparent var(--olive-mask-radial-to,100%))"
                                  #:name "the radial image")
                 (assert-contains #:expect css #:got ".mask-circle"
                                  #:name "a radial shape")
                 (assert-contains #:expect css
                                  #:got "--olive-mask-radial-shape:circle"
                                  #:name "the radial shape value")
                 (assert-contains #:expect css
                                  #:got ".mask-radial-at-top-right"
                                  #:name "a radial position")
                 (assert-contains #:expect css
                                  #:got "--olive-mask-radial-position:top right"
                                  #:name "the radial position value")
                 (assert-contains #:expect css #:got ".mask-conic-90"
                                  #:name "an angled conic mask")
                 (assert-contains #:expect css
                                  #:got "--olive-mask-conic-angle:90deg"
                                  #:name "the conic angle")
                 (assert-contains #:expect css
                                  #:got "conic-gradient(from var(--olive-mask-conic-angle,0deg),black var(--olive-mask-conic-from,0%),transparent var(--olive-mask-conic-to,100%))"
                                  #:name "the conic image")
                 (assert-contains #:expect css
                                  #:got "mask-t-from-50"
                                  #:name "a top edge fade")
                 (assert-contains #:expect css
                                  #:got "linear-gradient(to top,black var(--olive-mask-top-from,0%),transparent var(--olive-mask-top-to,100%))"
                                  #:name "the top edge image")
                 (assert-contains #:expect css
                                  #:got "mask-x-from-50"
                                  #:name "a horizontal edge fade")
                 (assert-contains #:expect css
                                  #:got "linear-gradient(to right,black var(--olive-mask-right-from,0%),transparent var(--olive-mask-right-to,100%)),linear-gradient(to left,black var(--olive-mask-left-from,0%),transparent var(--olive-mask-left-to,100%))"
                                  #:name "both horizontal layers")
                 (assert-contains #:expect css
                                  #:got "mask-composite:intersect"
                                  #:name "horizontal layers intersect")))
         (test "position, size, repeat, origin, clip and modes"
               (let ((css (css-of (mask-classes))))
                 (assert-contains #:expect css #:got ".mask-top-left"
                                  #:name "mask position")
                 (assert-contains #:expect css
                                  #:got "mask-position:top left"
                                  #:name "the position declaration")
                 (assert-contains #:expect css #:got ".mask-cover"
                                  #:name "mask size")
                 (assert-contains #:expect css
                                  #:got "mask-size:cover"
                                  #:name "the size declaration")
                 (assert-contains #:expect css #:got ".mask-repeat-x"
                                  #:name "mask repeat")
                 (assert-contains #:expect css
                                  #:got "mask-repeat:repeat-x"
                                  #:name "the repeat declaration")
                 (assert-contains #:expect css
                                  #:got ".mask-origin-view"
                                  #:name "mask origin")
                 (assert-contains #:expect css
                                  #:got "mask-origin:view-box"
                                  #:name "the origin declaration")
                 (assert-contains #:expect css
                                  #:got ".mask-clip-fill"
                                  #:name "mask clip")
                 (assert-contains #:expect css
                                  #:got "mask-clip:fill-box"
                                  #:name "the clip declaration")
                 (assert-contains #:expect css
                                  #:got ".mask-no-clip"
                                  #:name "no mask clip")
                 (assert-contains #:expect css
                                  #:got "mask-clip:no-clip"
                                  #:name "the no-clip declaration")
                 (assert-contains #:expect css #:got ".mask-intersect"
                                  #:name "mask composite")
                 (assert-contains #:expect css
                                  #:got "mask-composite:intersect"
                                  #:name "the composite declaration")
                 (assert-contains #:expect css #:got ".mask-alpha"
                                  #:name "mask mode")
                 (assert-contains #:expect css
                                  #:got "mask-mode:alpha"
                                  #:name "the mode declaration")
                 (assert-contains #:expect css
                                  #:got ".mask-type-luminance"
                                  #:name "SVG mask type")
                 (assert-contains #:expect css
                                  #:got "mask-type:luminance"
                                  #:name "the type declaration")))))

(define minifier-suite
  (suite "minifier"
         (test "drops optional whitespace and final separators"
               (assert-equal #:expect ".a{color:red;background:oklch(1 0 0/1);}.b>.c{margin:0 1px;}"
                             #:got (minify-css ".a {color: red; background: oklch(1 0 0 / 1);}\n.b > .c { margin: 0 1px; }")
                             #:name "the compact form"))))

(define (spec)
  (veritas-run background-suite scroll-spacing-suite gradient-suite
               logical-spacing-suite forced-color-suite color-scheme-suite
               mask-suite minifier-suite))
