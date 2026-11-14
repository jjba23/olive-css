;; olive-css
;;
;; SPDX-License-Identifier: MIT
;; Copyright © Josep Bigorra <jjbigorra@gmail.com>

;;; Commentary:
;;;
;;; Unit tests for the variants that reshape a selector instead of prefixing
;;; it: group, peer, has, not, aria, data, rtl/ltr, and the at-rule shaped
;;; motion, print and container queries.
;;;
;;; The families under test are replaced by a two-rule set, so a test reads the
;;; selector shaper rather than the whole colour system.
;;;
;;;
;;; Code:

(define-module (veritas unit variants)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-13)
  #:use-module (veritas veritas)
  #:use-module (olive-css main)
  #:use-module ((olive-css dsl) #:select (css-rule css-declaration format-css
                                                  flatten-list))
  #:use-module (olive-css decl layout)
  #:export (spec))

(define backslash
  (integer->char 92))

(define (escaped suffix)
  "The backslash CSS puts in front of SUFFIX inside a class name."
  (string-append (string backslash) suffix))

(define (css-of classes)
  "The stylesheet text CLASSES renders to."
  (string-join (flatten-list (map format-css classes)) "\n"))

(define tiny-rules
  (list (css-rule ".x"
                  (css-declaration 'color "red"))
        (css-rule ".y"
                  (css-declaration 'color "blue"))))

(define (variant-css thunk)
  "Render the lines THUNK returns with every variant family on TINY-RULES."
  (parameterize ((selector-variant-targets tiny-rules)
                 (at-rule-variant-targets tiny-rules))
    (css-of (thunk))))

(define defaults-css
  (variant-css variant-classes))

(define selector-suite
  (suite "selector shape variants"
         (test "group names an ancestor's state"
               (assert-contains #:expect defaults-css
                                #:got
                                (string-append ".group:hover .group-hover"
                                               (escaped ":x"))
                                #:name "the ancestor carries the state")
               (assert-contains #:expect defaults-css #:got "color:red"
                                #:name "the declarations survive"))
         (test "peer names a preceding sibling's state"
               (assert-contains #:expect defaults-css
                                #:got
                                (string-append ".peer:checked ~ .peer-checked"
                                               (escaped ":x"))
                                #:name "the sibling combinator"))
         (test "has and not wrap the state in a functional pseudo-class"
               (assert-contains #:expect
                                (parameterize ((selector-variants '("has-checked")))
                                  (variant-css variant-classes))
                                #:got
                                (string-append ".has-checked" (escaped ":x")
                                               ":has(:checked)")
                                #:name ":has()")
               (assert-contains #:expect
                                (parameterize ((selector-variants '("not-focus")))
                                  (variant-css variant-classes))
                                #:got
                                (string-append ".not-focus" (escaped ":x")
                                               ":not(:focus)")
                                #:name ":not()"))
         (test "aria and data name an attribute"
               (assert-contains #:expect
                                (parameterize ((selector-variants '("aria-expanded")))
                                  (variant-css variant-classes))
                                #:got
                                (string-append ".aria-expanded" (escaped ":x")
                                               "[aria-expanded=true]")
                                #:name "an ARIA attribute")
               (assert-contains #:expect
                                (parameterize ((selector-variants '("data-open")))
                                  (variant-css variant-classes))
                                #:got
                                (string-append ".data-open" (escaped ":x")
                                               "[data-open]")
                                #:name "a data attribute"))
         (test "rtl and ltr scope with :where"
               (assert-contains #:expect
                                (parameterize ((selector-variants '("rtl" "ltr")))
                                  (variant-css variant-classes))
                                #:got
                                (string-append ".rtl" (escaped ":x")
                                               ":where([dir=rtl], [dir=rtl] *)")
                                #:name "right to left")
               (assert-contains #:expect
                                (parameterize ((selector-variants '("rtl" "ltr")))
                                  (variant-css variant-classes))
                                #:got
                                (string-append ".ltr" (escaped ":x")
                                               ":where([dir=ltr], [dir=ltr] *)")
                                #:name "left to right"))
         (test "an unknown name is skipped instead of crashing"
               (let ((css (parameterize ((selector-variants
                                          '("group-nonsense" "group-hover")))
                            (variant-css variant-classes))))
                 (assert-contains #:expect css
                                  #:got
                                  (string-append ".group:hover .group-hover"
                                                 (escaped ":x"))
                                  #:name "the known variant is still written")
                 (assert-false (if (string-contains css "group-nonsense") #t #f)
                               #:name "the unknown variant writes nothing")))))

(define at-rule-suite
  (suite "at-rule variants"
         (test "print and the motion preferences become media queries"
               (assert-contains #:expect defaults-css #:got "@media print {"
                                #:name "print")
               (assert-contains #:expect defaults-css
                                #:got
                                "@media (prefers-reduced-motion: reduce) {"
                                #:name "reduced motion")
               (assert-contains #:expect defaults-css
                                #:got
                                (string-append ".motion-safe" (escaped ":x"))
                                #:name "the variant class is written inside"))
         (test "container variants measure a query container"
               (assert-contains #:expect defaults-css
                                #:got "@container (width >= 24rem) {"
                                #:name "the small container query")
               (assert-contains #:expect defaults-css
                                #:got
                                (string-append "." (escaped "@sm")
                                               (escaped ":x"))
                                #:name "the escaped container class")
               (assert-false (if (string-contains defaults-css
                                                  "@container (width >= 42rem)")
                                 #t #f)
                             #:name "a container scale that is not enabled"))
         (test "the enabled sets are parameters"
               (let ((css (parameterize ((at-rule-variants '())
                                         (container-variants '()))
                            (variant-css variant-classes))))
                 (assert-false (if (string-contains css "@media print") #t #f)
                               #:name "clearing the at-rule list writes none")
                 (assert-false (if (string-contains css "@container") #t #f)
                               #:name "clearing the container list writes none")))))

(define container-utility-suite
  (suite "query container utility"
         (test "@container establishes an inline-size container"
               (let ((css (css-of (list (container-type)))))
                 (assert-contains #:expect css
                                  #:got (string-append "." (escaped "@container"))
                                  #:name "the container class")
                 (assert-contains #:expect css
                                  #:got "container-type:inline-size"
                                  #:name "the inline-size declaration")))))

(define (spec)
  (veritas-run selector-suite at-rule-suite container-utility-suite))
