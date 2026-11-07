;; olive-css
;;
;; SPDX-License-Identifier: MIT
;; Copyright © Josep Bigorra <jjbigorra@gmail.com>

(define-module (olive-css decl backgrounds)
  #:use-module (srfi srfi-1)
  #:use-module (olive-css dsl)
  #:export (background-classes gradient-classes gradient-color-classes
                               background-image background-position
                               background-size background-repeat
                               background-attachment background-clip
                               background-origin))

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

(define (gradient-palette-stops palettes)
  (append-map (lambda (palette)
                (append-map (lambda (shade)
                              (gradient-stop-rules
                               (format #f "~a-~a" (car palette) (car shade))
                               (gradient-shade-color shade 1)
                               (gradient-shade-color shade 0)))
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
