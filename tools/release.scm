;; olive-css
;;
;; SPDX-License-Identifier: MIT
;; Copyright © Josep Bigorra <jjbigorra@gmail.com>

;;; Commentary:
;;;
;;; Cut a release: turn the changelog's Unreleased section into a dated one,
;;; write the version into every recipe that names it, commit, tag, push and
;;; publish the GitHub release.  `maak release' runs this.
;;;
;;; The task refuses to start on a dirty tree, off trunk, or on a version that
;;; already has a tag, because each of those makes a half-finished release
;;; that is awkward to undo.  The Arch checksum is refreshed afterwards, from
;;; the archive the new tag serves, and pushed as its own commit.
;;;
;;;
;;; Code:

(define-module (tools release)
  #:use-module (ice-9 format)
  #:use-module (ice-9 popen)
  #:use-module (ice-9 regex)
  #:use-module (ice-9 textual-ports)
  #:use-module (srfi srfi-13)
  #:use-module (olive-css cli)
  #:export (main release-changelog release-notes rewrite-cli-version))

(define repository
  "https://github.com/jjba23/olive-css")

(define release-branch
  "trunk")

(define (release-heading version date)
  (format #f "* v~a - ~a" version date))

(define (unreleased-body text)
  "The first level-two section inside Unreleased, and where it starts."
  (let* ((unreleased (string-contains text "* Unreleased"))
         (body (and unreleased (string-contains text "** " unreleased))))
    (unless body
      (error "CHANGELOG.org has no Unreleased section with entries"))
    body))

(define (refresh-unreleased-intro text version)
  "Point the Unreleased introduction at VERSION, when it names one."
  (regexp-substitute/global #f "Work that lands after =v[0-9.]+=" text
                            'pre "Work that lands after =v" version "=" 'post))

(define (release-changelog text version date)
  "Return TEXT with the Unreleased entries moved under a dated release."
  (let ((body (unreleased-body text)))
    (string-append (refresh-unreleased-intro (substring text 0 body) version)
                   "Nothing yet.\n\n"
                   (release-heading version date)
                   "\n\n"
                   (substring text body))))

(define (release-notes text)
  "Return the Unreleased entries of TEXT, for the GitHub release."
  (let* ((body (unreleased-body text))
         (next (string-contains text "\n* " body)))
    (string-trim-both (substring text body (or next (string-length text))))))

(define (read-file path)
  (call-with-input-file path get-string-all))

(define (write-file path text)
  (call-with-output-file path
    (lambda (port)
      (display text port))))

(define (replace-first text pattern replacement)
  "Replace the first match of the string PATTERN in TEXT."
  (let ((match (regexp-exec (make-regexp pattern) text)))
    (unless match
      (error "no match for" pattern))
    (string-append (match:prefix match)
                   replacement
                   (match:suffix match))))

(define (capture argv)
  "Run ARGV and return its exit status and standard output."
  (let* ((port (apply open-pipe* OPEN_READ argv))
         (output (get-string-all port))
         (status (status:exit-val (close-pipe port))))
    (values status output)))

(define (capture-one argv)
  "Run ARGV and return its trimmed first line, or #f when it fails."
  (call-with-values (lambda () (capture argv))
    (lambda (status output)
      (and (zero? status)
           (string-trim-both output)))))

(define (run argv)
  (let ((status (apply system* argv)))
    (unless (zero? status)
      (error "command failed:" (string-join argv " ")))
    status))

(define (say format-string . arguments)
  (format #t "release: ~a~%"
          (apply format #f format-string arguments)))

(define (current-branch)
  (capture-one (list "git" "rev-parse" "--abbrev-ref" "HEAD")))

(define (tree-is-clean?)
  (call-with-values
      (lambda () (capture (list "git" "status" "--porcelain")))
    (lambda (status output)
      (and (zero? status)
           (string-null? (string-trim-both output))))))

(define (tag-exists? tag)
  (zero? (system* "git" "rev-parse" "-q" "--verify"
                  (string-append "refs/tags/" tag))))

(define (set-version-in-file! path pattern replacement)
  (write-file path
              (replace-first (read-file path) pattern replacement)))

(define (rewrite-cli-version text version)
  "Rewrite the =olive-css-version= string in TEXT to VERSION.

Only the quoted value changes; the form around it is left byte-for-byte alone,
so a release cannot unbalance it."
  (let* ((marker "(define olive-css-version")
         (form (string-contains text marker)))
    (unless form
      (error "no olive-css-version form"))
    (let* ((open (string-contains text "\"" form))
           (close (and open (string-contains text "\"" (+ open 1)))))
      (unless close
        (error "no olive-css-version string"))
      (string-append (substring text 0 (+ open 1))
                     version
                     (substring text close)))))

(define (refresh-version-files! version)
  "Write VERSION into every recipe that names it, and date the changelog."
  (write-file "src/olive-css/cli.scm"
              (rewrite-cli-version (read-file "src/olive-css/cli.scm")
                                   version))
  (set-version-in-file! "default.nix"
                        "version = \"[^\"]+\";"
                        (string-append "version = \"" version "\";"))
  (set-version-in-file! "packaging/opensuse/olive-css.spec"
                        "Version:        [^\n]+"
                        (string-append "Version:        " version))
  (set-version-in-file! "packaging/arch/PKGBUILD"
                        "pkgver=[^\n]+"
                        (string-append "pkgver=" version)))

(define (write-debian-changelog! version stamp)
  (let* ((path "packaging/debian/changelog")
         (existing (read-file path))
         (already-there? (string-prefix? (string-append "olive-css ("
                                                        version "-")
                                         existing)))
    (unless already-there?
      (write-file path
                  (string-append
                   "olive-css (" version "-1) unstable; urgency=medium\n\n"
                   "  * Release v" version ".\n\n"
                   " -- Josep Bigorra <jjbigorra@gmail.com>  " stamp "\n\n"
                   existing)))))

(define (update-arch-checksum! version)
  "Point the Arch recipe at the archive the new tag serves."
  (let ((archive (format #f "/tmp/olive-css-~a.tar.gz" version)))
    (run (list "curl" "--fail" "--silent" "--show-error" "--location"
               "--output" archive
               (format #f "~a/archive/v~a.tar.gz" repository version)))
    (let* ((line (capture-one (list "sha256sum" archive)))
           (checksum (car (string-tokenize line))))
      (set-version-in-file! "packaging/arch/PKGBUILD"
                            "sha256sums=\\('[^']*'\\)"
                            (format #f "sha256sums=('~a')" checksum))
      (run (list "git" "add" "packaging/arch/PKGBUILD"))
      (run (list "git" "commit" "-m"
                 (format #f "build: Update the Arch checksum for v~a" version)))
      (run (list "git" "push" "origin" release-branch))
      (say "Arch checksum updated to ~a" checksum))))

(define (release!)
  (let* ((version (string-trim-both olive-css-version))
         (tag (string-append "v" version))
         (date (strftime "%Y-%m-%d" (localtime (current-time))))
         (stamp (strftime "%a, %d %b %Y %H:%M:%S %z"
                          (localtime (current-time))))
         (notes (format #f "/tmp/olive-css-~a.notes" version)))
    (unless (string=? (or (current-branch) "") release-branch)
      (error "releases are cut from" release-branch))
    (unless (tree-is-clean?)
      (error "the working tree is not clean; commit or stash first"))
    (when (tag-exists? tag)
      (error "tag" tag "already exists; bump olive-css-version first"))
    (let ((original (read-file "CHANGELOG.org")))
      (write-file "CHANGELOG.org"
                  (release-changelog original version date))
      (write-file notes (release-notes original)))
    (refresh-version-files! version)
    (write-debian-changelog! version stamp)
    (say "cutting ~a from ~a" tag release-branch)
    (run (list "git" "add" "-A"))
    (run (list "git" "commit" "-m"
               (format #f "chore: Release ~a" tag)))
    (run (list "git" "tag" "-a" tag "-m" (format #f "olive-css ~a" tag)))
    (run (list "git" "push" "origin" release-branch))
    (run (list "git" "push" "origin" tag))
    (run (list "gh" "release" "create" tag
               "--title" (format #f "olive-css ~a" tag)
               "--notes-file" notes
               "--verify-tag"))
    (say "published ~a" tag)
    ;; The tag is the point of no return: a checksum that cannot be fetched
    ;; is reported, but it does not turn a published release into a failure.
    (catch #t
      (lambda ()
        (update-arch-checksum! version))
      (lambda (key . details)
        (say "warning: could not refresh the Arch checksum (~a); update it by hand"
             (if (null? details) key (car details)))))
    (say "done: ~a/releases/tag/~a" repository tag)))

(define (main)
  "Run a release, reporting a refused precondition as a failure."
  (catch #t
    (lambda ()
      (release!)
      0)
    (lambda (key . details)
      (format (current-error-port)
              "release: ~a~%"
              (string-join (map (lambda (detail)
                                  (if (string? detail)
                                      detail
                                      (format #f "~a" detail)))
                                details)
                           " "))
      (exit 1))))
