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

(define-module (olive-css decl animation)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-13)
  #:use-module (ice-9 string-fun)
  #:use-module (olive-css dsl)
  #:use-module (olive-css sizes)
  #:export (animations animation-duration))

(define animation-duration
  (param "0.8s"))

(define fade-in-page-transition
  (param (list (rul "@view-transition"
                    (dec 'navigation
                         'auto))
               (rul (string-join '("::view-transition-old(root)"
                                   "::view-transition-new(root)") ", ")
                    (dec 'animation "fade 0.1s ease both"))
               (rul "@keyframes fade"
                    (rul 'from
                         (dec 'opacity 0.2))
                    (rul 'to
                         (dec 'opacity 1))))))

(define slide-from-top-element-animation
  (param (list (rul "@keyframes slide-from-top-element"
                    (rul "from"
                         (dec 'translate "0 -150vh")
                         (dec 'scale "1 200%"))
                    (rul "to"
                         (dec 'translate "0 0")
                         (dec 'scale "1 100%"))))))

(define slide-from-top
  (param (list (rul ".slide-from-top"
                    (dec 'animation-duration (animation-duration))
                    (dec 'animation-name
                         'slide-from-top-element)))))

(define slide-from-bottom-element-animation
  (param (list (rul "@keyframes slide-from-bottom-element"
                    (rul "from"
                         (dec 'translate "0 150vh")
                         (dec 'scale "1 200%"))
                    (rul "to"
                         (dec 'translate "0 0")
                         (dec 'scale "1 100%"))))))

(define slide-from-bottom
  (param (list (rul ".slide-from-bottom"
                    (dec 'animation-duration (animation-duration))
                    (dec 'animation-name
                         'slide-from-bottom-element)))))

(define slide-from-right-element-animation
  (param (list (rul "@keyframes slide-from-right-element"
                    (rul "from"
                         (dec 'translate "150vw 0")
                         (dec 'scale "200% 1"))
                    (rul "to"
                         (dec 'translate "0 0")
                         (dec 'scale "100% 1"))))))

(define slide-from-right
  (param (list (rul ".slide-from-right"
                    (dec 'animation-duration (animation-duration))
                    (dec 'animation-name
                         'slide-from-right-element)))))

(define slide-from-left-element-animation
  (param (list (rul "@keyframes slide-from-left-element"
                    (rul "from"
                         (dec 'translate "-150vw 0")
                         (dec 'scale "200% 1"))
                    (rul "to"
                         (dec 'translate "0 0")
                         (dec 'scale "100% 1"))))))

(define slide-from-left
  (param (list (rul ".slide-from-left"
                    (dec 'animation-duration (animation-duration))
                    (dec 'animation-name
                         'slide-from-left-element)))))

(define active-scale
  (param (list (rul ".active\\:scale-95"
                    (rul "&:active"
                         (dec 'scale "95% 95%"))))))

(define animations
  (param (list (fade-in-page-transition)
               (slide-from-right-element-animation)
               (slide-from-right)
               (slide-from-left-element-animation)
               (slide-from-left)
               (slide-from-top-element-animation)
               (slide-from-top)
               (slide-from-bottom-element-animation)
               (slide-from-bottom)
               (active-scale))))
