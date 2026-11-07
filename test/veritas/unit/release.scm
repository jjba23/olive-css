;; olive-css
;;
;; SPDX-License-Identifier: MIT
;; Copyright © Josep Bigorra <jjbigorra@gmail.com>

;;; Commentary:
;;;
;;; Tests for the pure half of @code{(tools release)}: rewriting the changelog
;;; so the Unreleased section becomes a dated release, and lifting that
;;; section into GitHub release notes.  The half that pushes is not exercised
;;; here; it refuses to run without a clean tree on trunk, so it is a manual
;;; step by design.
;;;
;;;
;;; Code:

(define-module (veritas unit release)
  #:use-module (ice-9 textual-ports)
  #:use-module (veritas veritas)
  #:use-module (tools release)
  #:export (spec))

(define (contains? haystack needle)
  "True when HAYSTACK contains NEEDLE."
  (if (string-contains haystack needle) #t #f))

(define sample-changelog
  "#+title: Olive CSS Changelog\n\n* Unreleased\n\nWork that lands here until it is tagged.\n\n** Added\n\n- a new utility\n\n* v0.7.0 - 2026-10-01\n\nOld news.\n")

(define released
  (release-changelog sample-changelog "0.8.0" "2026-11-07"))

(define notes
  (release-notes sample-changelog))

(define changer-suite
  (suite "release changelog"
         (test "the unreleased section keeps a stub and gains a dated release"
               (assert-contains #:expect released #:got "* Unreleased"
                                #:name "the working section stays")
               (assert-contains #:expect released #:got "Nothing yet."
                                #:name "the new section starts empty")
               (assert-contains #:expect released
                                #:got "* v0.8.0 - 2026-11-07"
                                #:name "the release is dated"))
         (test "the entries move under the release, in order"
               (assert-contains #:expect released #:got "- a new utility"
                                #:name "the entry survives")
               (assert-true (< (string-contains released "- a new utility")
                               (string-contains released "Old news."))
                            #:name "the new release precedes the older one"))))

(define notes-suite
  (suite "release notes"
         (test "the notes carry the section and nothing after it"
               (assert-contains #:expect notes #:got "- a new utility"
                                #:name "the entry is in the notes")
               (assert-false (contains? notes "Old news.")
                             #:name "the previous release is not")
               (assert-false (contains? notes "* Unreleased")
                             #:name "the working section is not"))))

(define (spec)
  (veritas-run changer-suite notes-suite))
