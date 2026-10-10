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

(define-module (olive-css decl transitions)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-13)
  #:use-module (ice-9 string-fun)
  #:use-module (olive-css dsl)
  #:use-module (olive-css sizes)
  #:export (transition-classes transition-property transition-duration
                               transition-delay transition-timing
                               animation-classes))

(define default-ease
  "cubic-bezier(0.4, 0, 0.2, 1)")

(define default-duration
  "150ms")

(define (transition-rule name properties)
  (css-rule name
            (css-declaration 'transition-property properties)
            (css-declaration 'transition-timing-function default-ease)
            (css-declaration 'transition-duration default-duration)))

(define transition-property
  (make-parameter (list (transition-rule ".transition-none"
                                         'none)
                        (transition-rule ".transition-all"
                                         'all)
                        (transition-rule ".transition"
                         "color, background-color, border-color, text-decoration-color, fill, stroke, opacity, box-shadow, transform, translate, scale, rotate, filter, backdrop-filter")
                        (transition-rule ".transition-colors"
                         "color, background-color, border-color, text-decoration-color, fill, stroke")
                        (transition-rule ".transition-opacity"
                                         'opacity)
                        (transition-rule ".transition-shadow"
                                         'box-shadow)
                        (transition-rule ".transition-transform"
                         "transform, translate, scale, rotate"))))

(define duration-scale
  '((0 0)
    (75 75)
    (100 100)
    (150 150)
    (200 200)
    (300 300)
    (500 500)
    (700 700)
    (1000 1000)))

(define transition-duration
  (make-parameter (css-rule-variants ".duration-~a"
                                     #:property 'transition-duration
                                     #:variants (map (lambda (s)
                                                       (list (car s)
                                                             (format #f "~ams"
                                                                     (cadr s))))
                                                     duration-scale))))

(define transition-delay
  (make-parameter (css-rule-variants ".delay-~a"
                                     #:property 'transition-delay
                                     #:variants (map (lambda (s)
                                                       (list (car s)
                                                             (format #f "~ams"
                                                                     (cadr s))))
                                                     duration-scale))))

(define transition-timing
  (make-parameter (css-rule-variants ".ease-~a"
                                     #:property 'transition-timing-function
                                     #:variants `((linear linear)
                                                  (in
                                                   "cubic-bezier(0.4, 0, 1, 1)")
                                                  (out
                                                   "cubic-bezier(0, 0, 0.2, 1)")
                                                  (in-out ,default-ease)))))

(define (keyframes name stops)
  (css-rule (format #f "@keyframes ~a" name)
            (map (lambda (stop)
                   (css-rule (car stop)
                             (map (lambda (decl)
                                    (css-declaration (car decl)
                                                     (cadr decl)))
                                  (cdr stop)))) stops)))

(define animation-classes
  (make-parameter (list (keyframes 'spin
                                   '(("to" (transform "rotate(360deg)"))))
                        (keyframes 'ping
                                   '(("75%, 100%" (transform "scale(2)")
                                      (opacity 0))))
                        (keyframes 'pulse
                                   '(("50%" (opacity 0.5))))
                        (keyframes 'bounce
                                   '(("0%, 100%" (transform "translateY(-25%)")
                                      (animation-timing-function
                                       "cubic-bezier(0.8, 0, 1, 1)"))
                                     ("50%" (transform "translateY(0)")
                                      (animation-timing-function
                                       "cubic-bezier(0, 0, 0.2, 1)"))))
                        (css-rule ".animate-none"
                                  (css-declaration 'animation
                                                   'none))
                        (css-rule ".animate-spin"
                                  (css-declaration 'animation
                                                   "spin 1s linear infinite"))
                        (css-rule ".animate-ping"
                                  (css-declaration 'animation
                                   "ping 1s cubic-bezier(0, 0, 0.2, 1) infinite"))
                        (css-rule ".animate-pulse"
                                  (css-declaration 'animation
                                   "pulse 2s cubic-bezier(0.4, 0, 0.6, 1) infinite"))
                        (css-rule ".animate-bounce"
                                  (css-declaration 'animation
                                                   "bounce 1s infinite")))))

;; `animation-classes' holds @keyframes and is emitted only once at the top
;; level, whereas `transition-classes' is safe to duplicate under state
;; variants and media queries.
(define transition-classes
  (make-parameter (list (transition-property)
                        (transition-duration)
                        (transition-delay)
                        (transition-timing))))
