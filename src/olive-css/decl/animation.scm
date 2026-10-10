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
  (make-parameter "0.8s"))

(define fade-in-page-transition
  (make-parameter (list (css-rule "@view-transition"
                                  (css-declaration 'navigation
                                                   'auto))
                        (css-rule (string-join '("::view-transition-old(root)"
                                                 "::view-transition-new(root)")
                                               ", ")
                                  (css-declaration 'animation
                                                   "fade 0.1s ease both"))
                        (css-rule "@keyframes fade"
                                  (css-rule 'from
                                            (css-declaration 'opacity 0.2))
                                  (css-rule 'to
                                            (css-declaration 'opacity 1))))))

(define slide-from-top-element-animation
  (make-parameter (list (css-rule "@keyframes slide-from-top-element"
                                  (css-rule "from"
                                            (css-declaration 'translate
                                                             "0 -150vh")
                                            (css-declaration 'scale "1 200%"))
                                  (css-rule "to"
                                            (css-declaration 'translate "0 0")
                                            (css-declaration 'scale "1 100%"))))))

(define slide-from-top
  (make-parameter (list (css-rule ".slide-from-top"
                                  (css-declaration 'animation-duration
                                                   (animation-duration))
                                  (css-declaration 'animation-name
                                                   'slide-from-top-element)))))

(define slide-from-bottom-element-animation
  (make-parameter (list (css-rule "@keyframes slide-from-bottom-element"
                                  (css-rule "from"
                                            (css-declaration 'translate
                                                             "0 150vh")
                                            (css-declaration 'scale "1 200%"))
                                  (css-rule "to"
                                            (css-declaration 'translate "0 0")
                                            (css-declaration 'scale "1 100%"))))))

(define slide-from-bottom
  (make-parameter (list (css-rule ".slide-from-bottom"
                                  (css-declaration 'animation-duration
                                                   (animation-duration))
                                  (css-declaration 'animation-name
                                                   'slide-from-bottom-element)))))

(define slide-from-right-element-animation
  (make-parameter (list (css-rule "@keyframes slide-from-right-element"
                                  (css-rule "from"
                                            (css-declaration 'translate
                                                             "150vw 0")
                                            (css-declaration 'scale "200% 1"))
                                  (css-rule "to"
                                            (css-declaration 'translate "0 0")
                                            (css-declaration 'scale "100% 1"))))))

(define slide-from-right
  (make-parameter (list (css-rule ".slide-from-right"
                                  (css-declaration 'animation-duration
                                                   (animation-duration))
                                  (css-declaration 'animation-name
                                                   'slide-from-right-element)))))

(define slide-from-left-element-animation
  (make-parameter (list (css-rule "@keyframes slide-from-left-element"
                                  (css-rule "from"
                                            (css-declaration 'translate
                                                             "-150vw 0")
                                            (css-declaration 'scale "200% 1"))
                                  (css-rule "to"
                                            (css-declaration 'translate "0 0")
                                            (css-declaration 'scale "100% 1"))))))

(define slide-from-left
  (make-parameter (list (css-rule ".slide-from-left"
                                  (css-declaration 'animation-duration
                                                   (animation-duration))
                                  (css-declaration 'animation-name
                                                   'slide-from-left-element)))))

(define animations
  (make-parameter (list (fade-in-page-transition)
                        (slide-from-right-element-animation)
                        (slide-from-right)
                        (slide-from-left-element-animation)
                        (slide-from-left)
                        (slide-from-top-element-animation)
                        (slide-from-top)
                        (slide-from-bottom-element-animation)
                        (slide-from-bottom))))
