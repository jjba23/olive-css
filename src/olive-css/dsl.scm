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

(define-module (olive-css dsl)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-9)
  #:use-module (srfi srfi-13)
  #:use-module (ice-9 string-fun)
  #:use-module (ice-9 format)
  #:export (~ format-css
              list-combinations
              where-dark
              lighten-oklch
              identity-oklch
              darken-oklch
              make-palette
              ;;
              css-comment
              rule
              media-query
              add-media-query-prefix
              add-hover-variant
              make-rule
              rule?
              set-rule-selector!
              rule-selector
              rule-declarations
              declaration
              make-declaration
              declaration?
              declaration-property
              declaration-value
              css-rule
              css-color-rules
              css-declaration
              flatten-list
              css-rule-variants
              css-size
              to-rem
              to-px
              to-rem-blur
              to-percent
              to-percent-function))

(define* (~ #:key (output-port #f)
            #:rest args)
  "Format a string with arguments. This is a descriptive alias for @code{format} with an optional destination port.

@example
(~ \"color: ~a;\" \"red\") @result{} \"color: red;\"
@end example"
  (apply format
         (append `(,output-port) args)))

(define (flatten-list xs)
  "Recursively flatten a deeply nested list @var{xs} into a single flat list.

@example
(flatten-list '(1 (2 3) 4)) @result{} '(1 2 3 4)
@end example"
  (cond
    ((null? xs)
     '())
    ((pair? xs)
     (append (flatten-list (car xs))
             (flatten-list (cdr xs))))
    (else (list xs))))

(define (darken-oklch xs n)
  "Darken an OKLCH color by subtracting value @var{n} from its lightness component.
@var{xs} is a list representing OKLCH color components where the @code{car} is lightness."
  (append (list (let* ((comp (- (car xs) n)))
                  (if (< comp 0) 0
                      (string->number (format #f "~,5f" comp)))))
          (cdr xs)))

(define (lighten-oklch xs n)
  "Lighten an OKLCH color by adding value @var{n} to its lightness component.
@var{xs} is a list representing OKLCH color components where the @code{car} is lightness."
  (append (list (let* ((comp (+ n
                                (car xs))))
                  (if (>= comp 1) 1
                      (string->number (format #f "~,5f" comp)))))
          (cdr xs)))

(define (identity-oklch oklch some)
  "Return the original @var{oklch} components completely unmodified, ignoring @var{some}."
  oklch)

(define* (make-palette oklch
                       #:key (transformers (list (list 100 lighten-oklch 0.1)
                                                 (list 300 lighten-oklch 0.05)
                                                 (list 500 identity-oklch 0)
                                                 (list 700 darken-oklch 0.05)
                                                 (list 900 darken-oklch 0.1))))
  "Generate a tiered color palette mapping variant weights (e.g., 100, 500, 900) to transformed
variations of a base @var{oklch} configuration."
  (map (lambda (t)
         (list (car t)
               (apply (cadr t)
                      (list oklch
                            (caddr t))))) transformers))

(define-record-type rule
  (make-rule selector declarations) rule?
  (selector rule-selector set-rule-selector!)
  (declarations rule-declarations))

(define* (css-rule selector . args)
  "Construct a new CSS @code{rule} object containing a target @var{selector} and flattened @var{args} declarations."
  (make-rule selector
             (flatten-list args)))

(define-record-type declaration
  (make-declaration property value) declaration?
  (property declaration-property)
  (value declaration-value))

;; An alias for @code{make-declaration} used to create individual property-value combinations.
(define css-declaration
  make-declaration)

(define* (css-rule-variants selector
                            #:key property variants
                            (other-properties '()))
  "Generate a list of CSS rules from a template @var{selector} across multiple string value @var{variants}."
  (map (lambda (v)
         (css-rule (format #f selector
                           (car v))

                   (append (map (lambda (p)
                                  (css-declaration (car p)
                                                   (cadr p))) other-properties)
                           (list (css-declaration property
                                                  (cadr v))))

                   )) variants))

(define* (css-comment msg)
  "Format a given string message @var{msg} inside a CSS multi-line block comment wrapper."
  (list (format #f "/*\n  ~a\n*/" msg)))

(define (add-media-query-prefix sel args)
  "Prefix utility class selectors within @var{args} to incorporate a specific media query screen size token @var{sel}."
  (cond
    ((rule? args)
     (let* ((a args)
            (selector (rule-selector a))
            (str (if (equal? "."
                             (string-take selector 1))
                     (format #f ".~a\\:~a" sel
                             (string-drop selector 1)) selector)))
       (css-rule str
                 (rule-declarations a))))
    ((list? args)
     (map (lambda (a)
            (add-media-query-prefix sel a)) args))
    (else args)))

(define (add-hover-variant sel args)
  "Transform utility rules in @var{args} into nested interactive pseudo-classes matching @code{&:hover} targets prefixed by @var{sel}."
  (cond
    ((rule? args)
     (let* ((a args)
            (selector (rule-selector a))
            (str (if (equal? "."
                             (string-take selector 1))
                     (format #f ".~a\\:~a" sel
                             (string-drop selector 1)) selector))
            (rd (css-rule "&:hover"
                          (rule-declarations a))))
       (css-rule str rd)))
    ((list? args)
     (map (lambda (a)
            (add-hover-variant sel a)) args))
    (else args)))

(define* (css-color-rules selector
                          #:key property
                          variants
                          (other-properties '())
                          (palettes '()))
  "Construct color-specific utility rules mapping across specified @var{palettes}, configurations, and opacity @var{variants}."
  (map (lambda (palette)
         (map (lambda (alpha-weight)
                (css-rule (format #f selector
                                  (car palette)
                                  (caadr alpha-weight)
                                  (if (and (not (equal? ""
                                                        (caar alpha-weight)))
                                           (not (equal? #f
                                                        (caar alpha-weight))))
                                      (format #f "\\/~a"
                                              (caar alpha-weight)) ""))

                          (append (map (lambda (p)
                                         (css-declaration (car p)
                                                          (cadr p)))
                                       other-properties)
                                  (list (css-declaration property
                                                         (apply format
                                                                (append (list
                                                                              #f
                                                                              "oklch(~a ~a ~a / ~a)")
                                                                        (car (assoc-ref
                                                                              palette

                                                                              
                                                                              (caadr
                                                                               alpha-weight)))
                                                                        (list (cadar
                                                                               alpha-weight)))))))

                          )) variants)) palettes))

(define* (css-size s
                   #:key (conversion identity)
                   (multiplier 1))
  "Process a sizing pair @var{s} by modifying numeric values via a @var{multiplier} and formatting output with @var{conversion}."
  (list (car s)
        (conversion (cond
                      ((number? (cadr s))
                       (* (cadr s) multiplier))
                      ((string? (cadr s))
                       (cadr s))
                      (else (cadr s))))))

(define (to-rem x)
  "Convert a primitive numeric measurement value @var{x} into a standard CSS @code{rem} string value."
  (format #f "~,2frem" x))

(define (to-px x)
  "Convert a primitive numeric measurement value @var{x} into a standard CSS @code{px} string value."
  (format #f "~,2fpx" x))

(define (to-percent x)
  "Convert a decimal numeric ratio or number @var{x} into a standard CSS percentage @code{%} string token."
  (format #f "~,2f%" x))

(define (to-rem-blur x)
  "Wrap a native numeric measurement value @var{x} within a valid CSS standard @code{blur(...)} layout definition."
  (format #f "blur(~,2frem)" x))

(define (to-percent-function f)
  "Return a higher-order closure function transforming numbers into CSS functional notations @var{f} scaling values in percentage terms."
  (lambda (x)
    (format #f "~a(~,2f%)" f x)))

(define (list-combinations list1 list2)
  "Compute all combinations (Cartesian product) of elements present between @var{list1} and @var{list2}."
  (append-map (lambda (x)
                (map (lambda (y)
                       (list x y)) list2)) list1))

(define* (format-css xs)
  "Recursively transform an arbitrarily structured hierarchy of @code{rule} records, lists, or declarations @var{xs} into valid CSS text format strings."
  (cond
    ((list? xs)
     (map format-css xs))
    ((rule? xs)
     (format #f "~a {~a}"
             (rule-selector xs)
             (cond
               ((rule? (rule-declarations xs))
                (format-css (rule-declarations xs)))
               ((list? (rule-declarations xs))
                (string-join (map (lambda (xx)
                                    (cond
                                      ((rule? xx)
                                       (format-css xx))
                                      ((declaration? xx)
                                       (format-declaration xx))
                                      (else (format #f "~a" xx)))

                                    )
                                  (rule-declarations xs)) " "))
               (else (begin
                       (format-declaration (rule-declarations xs)))))))
    ((declaration? xs)
     (format-declaration xs))
    (else (format #f "~a" xs))))

(define (format-declaration xs)
  "Serialize an individual @code{declaration} record @var{xs} directly to a string representation matching standard CSS notation."
  (format #f "~a:~a;"
          (declaration-property xs)
          (declaration-value xs)))

;; CSS pseudo-class selector target sequence scoping system configurations targeting user-activated dark mode settings.
(define where-dark
  "&:where([data-theme=dark], [data-theme=dark] *)")

(define* (media-query query . args)
  "Wrap an evaluated set of stylesheet components inside a CSS modern media query expression container block.

@example
(media-query \"min-width: 768px\" \".container { display: block; }\")
@end example"
  (append (list (format #f "@media (~a) {" query)) args
          '("}")))
