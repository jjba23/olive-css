;; olive-css
;;
;; SPDX-License-Identifier: MIT
;; Copyright © Josep Bigorra <jjbigorra@gmail.com>

(define-module (olive-css decl backgrounds)
  #:use-module (srfi srfi-1)
  #:use-module (olive-css dsl)
  #:use-module (olive-css sizes)
  #:export (background-classes gradient-classes gradient-color-classes
                               background-image background-position
                               background-size background-repeat
                               background-attachment background-clip
                               background-origin gradient-alphas))

(define background-image
  (make-parameter (list (css-rule ".bg-none"
                                  (css-declaration 'background-image
                                                   'none)))))

(define background-position
  (make-parameter (css-rule-variants ".bg-~a"
                                     #:property 'background-position
                                     #:variants '((center center)
                                                  (top top)
                                                  ("top-right" "top right")
                                                  (right right)
                                                  ("bottom-right" "bottom right")
                                                  (bottom bottom)
                                                  ("bottom-left" "bottom left")
                                                  (left left)
                                                  ("top-left" "top left")))))

(define background-size
  (make-parameter (css-rule-variants ".bg-~a"
                                     #:property 'background-size
                                     #:variants '((auto auto)
                                                  (cover cover)
                                                  (contain contain)))))

(define background-repeat
  (make-parameter (css-rule-variants ".bg-~a"
                                     #:property 'background-repeat
                                     #:variants '((repeat repeat)
                                                  ("no-repeat" no-repeat)
                                                  ("repeat-x" repeat-x)
                                                  ("repeat-y" repeat-y)
                                                  ("repeat-round" round)
                                                  ("repeat-space" space)))))

(define background-attachment
  (make-parameter (css-rule-variants ".bg-~a"
                                     #:property 'background-attachment
                                     #:variants '((fixed fixed)
                                                  (local local)
                                                  (scroll scroll)))))

(define background-clip
  (make-parameter (css-rule-variants ".bg-clip-~a"
                                     #:property 'background-clip
                                     #:variants '((border "border-box")
                                                  (padding "padding-box")
                                                  (content "content-box")
                                                  (text text)))))

(define background-origin
  (make-parameter (css-rule-variants ".bg-origin-~a"
                                     #:property 'background-origin
                                     #:variants '((border "border-box")
                                                  (padding "padding-box")
                                                  (content "content-box")))))

(define gradient-directions
  '((t "to top")
    (tr "to top right")
    (r "to right")
    (br "to bottom right")
    (b "to bottom")
    (bl "to bottom left")
    (l "to left")
    (tl "to top left")))

(define gradient-angles
  '((0 "0deg")
    (45 "45deg")
    (90 "90deg")
    (135 "135deg")
    (180 "180deg")
    (225 "225deg")
    (270 "270deg")
    (315 "315deg")))

(define (linear-gradient-rules prefix)
  "Build one linear-gradient rule per direction."
  (css-rule-variants (string-append "." prefix "-~a")
                     #:property 'background-image
                     #:variants (map (lambda (direction)
                                       (list (car direction)
                                             (format #f "linear-gradient(~a, var(--olive-gradient-stops))"
                                                     (cadr direction))))
                                     gradient-directions)))

(define (gradient-classes)
  "Gradient directions that consume the stop variables."
  (append (linear-gradient-rules "bg-linear-to")
          (linear-gradient-rules "bg-gradient-to")
          (css-rule-variants ".bg-linear-~a"
                             #:property 'background-image
                             #:variants (map (lambda (angle)
                                               (list (car angle)
                                                     (format #f "linear-gradient(~a, var(--olive-gradient-stops))"
                                                             (cadr angle))))
                                             gradient-angles))
          (list (css-rule ".bg-radial"
                          (css-declaration 'background-image
                                           "radial-gradient(var(--olive-gradient-stops))"))
                (css-rule ".bg-conic"
                          (css-declaration 'background-image
                                           "conic-gradient(var(--olive-gradient-stops))")))))

(define gradient-basic-colors
  '((white "white" "rgb(255 255 255 / 0)")
    (black "black" "rgb(0 0 0 / 0)")
    (transparent "transparent" "transparent")))

(define (gradient-shade-color shade alpha)
  "The oklch color of SHADE at ALPHA."
  (let ((color (cadr shade)))
    (format #f "oklch(~a ~a ~a / ~a)"
            (car color) (cadr color) (caddr color) alpha)))

;; The opacity modifiers a gradient stop accepts.  The opaque entry is the
;; stop's own class, so only the transparent ones become extra rules.
(define gradient-alphas
  (make-parameter (filter (lambda (a)
                            (not (equal? "" (car a))))
                          alphas)))

(define (gradient-from-rule name color clear)
  (css-rule (format #f ".from-~a" name)
            (css-declaration "--olive-gradient-from" color)
            (css-declaration "--olive-gradient-to" clear)
            (css-declaration "--olive-gradient-stops"
                             "var(--olive-gradient-from), var(--olive-gradient-to)")))

(define (gradient-via-rule name color clear)
  (css-rule (format #f ".via-~a" name)
            (css-declaration "--olive-gradient-via" color)
            (css-declaration "--olive-gradient-to" clear)
            (css-declaration "--olive-gradient-stops"
                             "var(--olive-gradient-from), var(--olive-gradient-via), var(--olive-gradient-to)")))

(define (gradient-to-rule name color)
  (css-rule (format #f ".to-~a" name)
            (css-declaration "--olive-gradient-to" color)))

(define (gradient-stop-rules name color clear)
  (list (gradient-from-rule name color clear)
        (gradient-via-rule name color clear)
        (gradient-to-rule name color)))

(define (gradient-basic-stops)
  (append-map (lambda (entry)
                (gradient-stop-rules (symbol->string (car entry))
                                     (cadr entry)
                                     (caddr entry)))
              gradient-basic-colors))

(define (gradient-shade-alpha-stops palette shade)
  "The same stop at every opacity modifier, e.g. =from-redwood-500/50=.

A stop is a pair of declarations - the colour the stop holds and the stops
list that reads it - so the alpha has to be computed here, in the palette
arithmetic, rather than applied to a literal at use time."
  (map (lambda (alpha)
         (let* ((suffix (format #f "\\/~a" (car alpha)))
                (name (format #f "~a-~a~a" (car palette) (car shade) suffix))
                (from (gradient-shade-color shade (cadr alpha)))
                (clear (gradient-shade-color shade 0)))
           (gradient-stop-rules name from clear)))
       (gradient-alphas)))

(define (gradient-palette-stops palettes)
  (append-map (lambda (palette)
                (append-map (lambda (shade)
                              (append (gradient-stop-rules
                                       (format #f "~a-~a" (car palette)
                                               (car shade))
                                       (gradient-shade-color shade 1)
                                       (gradient-shade-color shade 0))
                                      (gradient-shade-alpha-stops palette
                                                                  shade)))
                            (cdr palette)))
              palettes))

(define (gradient-color-classes palettes)
  "Palette stops and the transparent fade for gradient directions."
  (append (gradient-basic-stops)
          (gradient-palette-stops palettes)))

(define (background-classes)
  "Background image and gradient utilities."
  (list (background-image)
        (background-position)
        (background-size)
        (background-repeat)
        (background-attachment)
        (background-clip)
        (background-origin)
        (gradient-classes)))
