;; olive-css
;;
;; SPDX-License-Identifier: MIT
;; Copyright © Josep Bigorra <jjbigorra@gmail.com>

;;; Commentary:
;;;
;;; Tests for @code{(olive-css cli)} and the build registry in
;;; @code{(olive-css builds)}: the commands the CLI accepts, the project
;;; builds it can generate, and the errors it reports for input it cannot
;;; honour.  Generating the complete stylesheet takes long enough to dominate
;;; the suite, so the one build these tests generate is a lean project build.
;;;
;;;
;;; Code:

(define-module (veritas unit cli)
  #:use-module (ice-9 regex)
  #:use-module (ice-9 textual-ports)
  #:use-module (veritas veritas)
  #:use-module (olive-css builds)
  #:use-module (olive-css cli)
  #:use-module (olive-css main)
  #:export (spec))

(define (contains? haystack needle)
  "True when HAYSTACK contains NEEDLE."
  (if (string-contains haystack needle) #t #f))

(define (listed? names name)
  "True when NAMES holds NAME."
  (if (member name names) #t #f))

(define (output-of thunk)
  "Everything THUNK writes to standard output."
  (with-output-to-string thunk))

(define (error-of thunk)
  "Everything THUNK writes to standard error."
  (with-error-to-string thunk))

(define semver
  (make-regexp "^[0-9]+\\.[0-9]+\\.[0-9]+$"))

(define version-suite
  (suite "version"
         (test "reports a semantic version"
               (assert-true (if (regexp-exec semver olive-css-version)
                                #t #f)
                            #:name "MAJOR.MINOR.PATCH")
               (assert-equal #:expect (string-append "olive-css "
                                                     olive-css-version
                                                     "\n")
                             #:got (output-of (lambda ()
                                                (run-cli '("--version"))))
                             #:name "the --version output"))))

(define builds-suite
  (suite "project builds"
         (test "names every shipped build"
               (assert-true (listed? (build-names) "full")
                            #:name "the complete build is listed")
               (assert-true (listed? (build-names) "lucidplan")
                            #:name "a project build is listed")
               (assert-true (>= (length (build-names)) 9)
                            #:name "all project builds are present"))
         (test "each build has a file and a generator"
               (assert-equal #:expect '()
                             #:got (filter (lambda (spec)
                                             (not (and (string? (build-file
                                                                 (car spec)))
                                                       (procedure? (caddr
                                                                    spec)))))
                                           build-specs)
                             #:name "no build is missing its parts"))
         (test "the complete build writes the shipped stylesheet"
               (assert-equal #:expect "resources/css/olive.min.css"
                             #:got (build-file "full")
                             #:name "the default output path")
               (assert-false (build-file "no-such-build")
                             #:name "an unknown build has no path"))
         (test "a project build generates CSS"
               (let* ((file "/tmp/olive-css-cli-test.css")
                      (css (build-css "wikimusic")))
                 (assert-true (pair? css)
                              #:name "the generator returns CSS lines")
                 (write-css-to-file #:file file #:css-lines css)
                 (assert-contains #:expect (call-with-input-file file
                                             get-string-all)
                                  #:got ".font-sans"
                                  #:name "the stylesheet has its families")
                 (delete-file file)))))

(define commands-suite
  (suite "commands"
         (test "help names every command"
               (let ((help olive-css-help-text))
                 (assert-contains #:expect help #:got "generate"
                                  #:name "the generate command")
                 (assert-contains #:expect help #:got "tree-shake"
                                  #:name "the tree-shake command")
                 (assert-contains #:expect help #:got "--build"
                                  #:name "the build option")))
         (test "list prints the build names"
               (let ((printed (output-of (lambda ()
                                           (run-cli '("list"))))))
                 (for-each (lambda (name)
                             (assert-contains #:expect printed #:got name
                                              #:name name))
                           (build-names))))
         (test "an unknown build fails without writing anything"
               (let ((status 0)
                     (said ""))
                 (set! said (error-of (lambda ()
                                        (set! status
                                              (run-cli '("generate"
                                                         "--build"
                                                         "no-such-build"))))))
                 (assert-equal #:expect 1 #:got status
                               #:name "the exit status")
                 (assert-contains #:expect said #:got "no-such-build"
                                  #:name "the rejected name is named")))
         (test "an unknown command is refused"
               (let ((status 0)
                     (said ""))
                 (set! said (error-of (lambda ()
                                        (set! status
                                              (run-cli '("explode"))))))
                 (assert-equal #:expect 2 #:got status
                               #:name "usage errors exit with 2")
                 (assert-contains #:expect said #:got "explode"
                                  #:name "the command is named")))
         (test "an output path needs exactly one build"
               (let ((status 0))
                 (error-of (lambda ()
                             (set! status
                                   (run-cli '("generate"
                                              "--output"
                                              "/tmp/x.css")))))
                 (assert-equal #:expect 1 #:got status
                               #:name "generating every build elsewhere is refused")))
         (test "--help wins over a command"
               (assert-equal #:expect 0
                             #:got (run-cli '("generate" "--help"))
                             #:name "the help status"))))

(define (spec)
  (veritas-run version-suite builds-suite commands-suite))
