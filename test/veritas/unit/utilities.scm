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
  #:use-module (olive-css decl spacing)
  #:export (spec))

(define test-file "/tmp/olive-css-utilities-test.css")

(define (css-of classes)
  "Write CLASSES to a temporary stylesheet and return its text."
  (parameterize ((minified? #f))
    (write-css-to-file #:file test-file #:css-lines classes))
  (let ((css (call-with-input-file test-file get-string-all)))
    (delete-file test-file)
    css))

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

(define (spec)
  (veritas-run background-suite scroll-spacing-suite))
