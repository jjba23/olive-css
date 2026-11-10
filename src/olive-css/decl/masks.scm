;; olive-css
;;
;; SPDX-License-Identifier: MIT
;; Copyright © Josep Bigorra <jjbigorra@gmail.com>

;;; Commentary:
;;;
;;; Mask utilities: image gradients, edge fades, positioning, repetition,
;;; origin, clipping, compositing and the two SVG mask interpretations.  The
;;; gradient masks use black and transparent so they work in alpha mode, and
;;; the from/to classes expose percentage stops.
;;;
;;;
;;; Code:

(define-module (olive-css decl masks)
  #:use-module (srfi srfi-1)
  #:use-module (olive-css dsl)
  #:export (mask-classes
            mask-image
            mask-position
            mask-size
            mask-repeat
            mask-origin
            mask-clip
            mask-composite
            mask-mode
            mask-type
            mask-linear
            mask-radial
            mask-conic
            mask-edge-gradients))

(define mask-percentages
  '((0 "0%")
    (10 "10%")
    (20 "20%")
    (30 "30%")
    (40 "40%")
    (50 "50%")
    (60 "60%")
    (70 "70%")
    (80 "80%")
    (90 "90%")
    (100 "100%")))

(define mask-angles
  '((0 "0deg")
    (45 "45deg")
    (90 "90deg")
    (135 "135deg")
    (180 "180deg")
    (225 "225deg")
    (270 "270deg")
    (315 "315deg")))

(define (linear-mask-image)
  "linear-gradient(var(--olive-mask-linear-angle,0deg),black var(--olive-mask-linear-from,0%),transparent var(--olive-mask-linear-to,100%))")

(define (radial-mask-image)
  "radial-gradient(var(--olive-mask-radial-shape,ellipse) var(--olive-mask-radial-size,farthest-corner) at var(--olive-mask-radial-position,center),black var(--olive-mask-radial-from,0%),transparent var(--olive-mask-radial-to,100%))")

(define (conic-mask-image)
  "conic-gradient(from var(--olive-mask-conic-angle,0deg),black var(--olive-mask-conic-from,0%),transparent var(--olive-mask-conic-to,100%))")

(define (mask-stop-rules prefix family image)
  "One from and one to rule per percentage, sharing IMAGE."
  (append
   (map (lambda (percentage)
          (css-rule (format #f ".~a-from-~a\\%" prefix (car percentage))
                    (css-declaration (format #f "--olive-mask-~a-from" family)
                                     (cadr percentage))
                    (css-declaration 'mask-image image)))
        mask-percentages)
   (map (lambda (percentage)
          (css-rule (format #f ".~a-to-~a\\%" prefix (car percentage))
                    (css-declaration (format #f "--olive-mask-~a-to" family)
                                     (cadr percentage))
                    (css-declaration 'mask-image image)))
        mask-percentages)))

(define (mask-angle-rules prefix family image)
  "One angle rule per step, all sharing IMAGE."
  (map (lambda (angle)
         (css-rule (format #f ".~a-~a" prefix (car angle))
                   (css-declaration (format #f "--olive-mask-~a-angle" family)
                                    (cadr angle))
                   (css-declaration 'mask-image image)))
       mask-angles))

(define mask-sides
  '((t "top" "to top")
    (r "right" "to right")
    (b "bottom" "to bottom")
    (l "left" "to left")))

(define (edge-mask-image direction family)
  (format #f
          "linear-gradient(~a,black var(--olive-mask-~a-from,0%),transparent var(--olive-mask-~a-to,100%))"
          direction family family))

(define (mask-side-rules side family direction)
  (append
   (map (lambda (percentage)
          (css-rule (format #f ".mask-~a-from-~a\\%" side (car percentage))
                    (css-declaration (format #f "--olive-mask-~a-from" family)
                                     (cadr percentage))
                    (css-declaration 'mask-image
                                     (edge-mask-image direction family))))
        mask-percentages)
   (map (lambda (percentage)
          (css-rule (format #f ".mask-~a-to-~a\\%" side (car percentage))
                    (css-declaration (format #f "--olive-mask-~a-to" family)
                                     (cadr percentage))
                    (css-declaration 'mask-image
                                     (edge-mask-image direction family))))
        mask-percentages)))

(define (mask-axis-rules axis first-direction first-family
                        second-direction second-family)
  "Two perpendicular edge layers, intersected as Tailwind does."
  (let ((image (format #f "~a,~a"
                       (edge-mask-image first-direction first-family)
                       (edge-mask-image second-direction second-family))))
    (append
     (map (lambda (percentage)
            (css-rule (format #f ".mask-~a-from-~a\\%" axis (car percentage))
                      (css-declaration
                       (format #f "--olive-mask-~a-from" first-family)
                       (cadr percentage))
                      (css-declaration
                       (format #f "--olive-mask-~a-from" second-family)
                       (cadr percentage))
                      (css-declaration 'mask-image image)
                      (css-declaration 'mask-composite 'intersect)))
          mask-percentages)
     (map (lambda (percentage)
            (css-rule (format #f ".mask-~a-to-~a\\%" axis (car percentage))
                      (css-declaration
                       (format #f "--olive-mask-~a-to" first-family)
                       (cadr percentage))
                      (css-declaration
                       (format #f "--olive-mask-~a-to" second-family)
                       (cadr percentage))
                      (css-declaration 'mask-image image)
                      (css-declaration 'mask-composite 'intersect)))
          mask-percentages))))

(define (mask-edge-gradients)
  "Side fades plus the two-layer x/y conveniences."
  (append (append-map (lambda (side)
                        (apply mask-side-rules side))
                      mask-sides)
          (mask-axis-rules "x" "to right" "right" "to left" "left")
          (mask-axis-rules "y" "to top" "top" "to bottom" "bottom")))

(define mask-image
  (make-parameter
   (append
    (list (css-rule ".mask-none"
                    (css-declaration 'mask-image 'none))
          (css-rule ".mask-radial"
                    (css-declaration 'mask-image (radial-mask-image)))
          (css-rule ".mask-conic"
                    (css-declaration 'mask-image (conic-mask-image))))
    (mask-angle-rules "mask-linear" "linear" (linear-mask-image))
    (mask-angle-rules "mask-conic" "conic" (conic-mask-image))
    (mask-stop-rules "mask-linear" "linear" (linear-mask-image))
    (mask-stop-rules "mask-radial" "radial" (radial-mask-image))
    (mask-stop-rules "mask-conic" "conic" (conic-mask-image))
    (list (css-rule ".mask-circle"
                    (css-declaration "--olive-mask-radial-shape" "circle"))
          (css-rule ".mask-ellipse"
                    (css-declaration "--olive-mask-radial-shape" "ellipse"))
          (css-rule ".mask-radial-closest-side"
                    (css-declaration "--olive-mask-radial-size"
                                     "closest-side"))
          (css-rule ".mask-radial-closest-corner"
                    (css-declaration "--olive-mask-radial-size"
                                     "closest-corner"))
          (css-rule ".mask-radial-farthest-side"
                    (css-declaration "--olive-mask-radial-size"
                                     "farthest-side"))
          (css-rule ".mask-radial-farthest-corner"
                    (css-declaration "--olive-mask-radial-size"
                                     "farthest-corner"))
          (css-rule ".mask-radial-at-top-left"
                    (css-declaration "--olive-mask-radial-position"
                                     "top left"))
          (css-rule ".mask-radial-at-top"
                    (css-declaration "--olive-mask-radial-position" "top"))
          (css-rule ".mask-radial-at-top-right"
                    (css-declaration "--olive-mask-radial-position"
                                     "top right"))
          (css-rule ".mask-radial-at-left"
                    (css-declaration "--olive-mask-radial-position" "left"))
          (css-rule ".mask-radial-at-center"
                    (css-declaration "--olive-mask-radial-position"
                                     "center"))
          (css-rule ".mask-radial-at-right"
                    (css-declaration "--olive-mask-radial-position"
                                     "right"))
          (css-rule ".mask-radial-at-bottom-left"
                    (css-declaration "--olive-mask-radial-position"
                                     "bottom left"))
          (css-rule ".mask-radial-at-bottom"
                    (css-declaration "--olive-mask-radial-position"
                                     "bottom"))
          (css-rule ".mask-radial-at-bottom-right"
                    (css-declaration "--olive-mask-radial-position"
                                     "bottom right")))
    (mask-edge-gradients))))

(define mask-position
  (make-parameter
   (css-rule-variants ".mask-~a"
                      #:property 'mask-position
                      #:variants '((top-left "top left")
                                   (top top)
                                   (top-right "top right")
                                   (left left)
                                   (center center)
                                   (right right)
                                   (bottom-left "bottom left")
                                   (bottom bottom)
                                   (bottom-right "bottom right")))))

(define mask-size
  (make-parameter
   (css-rule-variants ".mask-~a"
                      #:property 'mask-size
                      #:variants '((auto auto)
                                   (cover cover)
                                   (contain contain)))))

(define mask-repeat
  (make-parameter
   (css-rule-variants ".mask-~a"
                      #:property 'mask-repeat
                      #:variants '((repeat repeat)
                                   (no-repeat no-repeat)
                                   (repeat-x repeat-x)
                                   (repeat-y repeat-y)
                                   (repeat-round round)
                                   (repeat-space space)))))

(define mask-origin
  (make-parameter
   (css-rule-variants ".mask-origin-~a"
                      #:property 'mask-origin
                      #:variants '((border border-box)
                                   (padding padding-box)
                                   (content content-box)
                                   (fill fill-box)
                                   (stroke stroke-box)
                                   (view view-box)))))

(define mask-clip
  (make-parameter
   (append
    (css-rule-variants ".mask-clip-~a"
                       #:property 'mask-clip
                       #:variants '((border border-box)
                                    (padding padding-box)
                                    (content content-box)
                                    (fill fill-box)
                                    (stroke stroke-box)
                                    (view view-box)))
    (list (css-rule ".mask-no-clip"
                    (css-declaration 'mask-clip 'no-clip))))))

(define mask-composite
  (make-parameter
   (css-rule-variants ".mask-~a"
                      #:property 'mask-composite
                      #:variants '((add add)
                                   (subtract subtract)
                                   (intersect intersect)
                                   (exclude exclude)))))

(define mask-mode
  (make-parameter
   (css-rule-variants ".mask-~a"
                      #:property 'mask-mode
                      #:variants '((alpha alpha)
                                   (luminance luminance)
                                   (match match-source)))))

(define mask-type
  (make-parameter
   (css-rule-variants ".mask-type-~a"
                      #:property 'mask-type
                      #:variants '((alpha alpha)
                                   (luminance luminance)))))

(define mask-linear
  (make-parameter
   (append (mask-angle-rules "mask-linear" "linear" (linear-mask-image))
           (mask-stop-rules "mask-linear" "linear" (linear-mask-image)))))

(define mask-radial
  (make-parameter
   (append (list (css-rule ".mask-radial"
                           (css-declaration 'mask-image (radial-mask-image))))
           (mask-stop-rules "mask-radial" "radial" (radial-mask-image)))))

(define mask-conic
  (make-parameter
   (append (list (css-rule ".mask-conic"
                           (css-declaration 'mask-image (conic-mask-image))))
           (mask-angle-rules "mask-conic" "conic" (conic-mask-image))
           (mask-stop-rules "mask-conic" "conic" (conic-mask-image)))))

(define (mask-classes)
  "Every mask utility."
  (append (mask-image)
          (mask-position)
          (mask-size)
          (mask-repeat)
          (mask-origin)
          (mask-clip)
          (mask-composite)
          (mask-mode)
          (mask-type)))
