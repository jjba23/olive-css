;; olive-css
;;
;; SPDX-License-Identifier: MIT
;; Copyright © Josep Bigorra <jjbigorra@gmail.com>

;;; Commentary:
;;;
;;; Command line interface for Olive CSS.  It generates the stylesheets this
;;; repository ships, in one call or one build at a time, and prunes a build
;;; down to the classes a site uses.  `maak build' and `maak tree-shake' call
;;; it, so the shell commands in the documentation are the same ones the
;;; project runs.
;;;
;;; Every option is a thin layer over the library: generation is
;;; `build-css' from @code{(olive-css builds)} and pruning is
;;; @code{(olive-css tree-shaking)}, whose options are Guile parameters.
;;;
;;;
;;; Code:

(define-module (olive-css cli)
  #:declarative? #t
  #:use-module (ice-9 format)
  #:use-module (ice-9 getopt-long)
  #:use-module (srfi srfi-13)
  #:use-module (olive-css builds)
  #:use-module (olive-css main)
  #:use-module (olive-css tree-shaking)
  #:export (olive-css-version
            main
            run-cli
            show-help
            olive-css-help-text
            olive-css-option-grammar))

((define olive-css-version
  "0.8.0")

(define olive-css-option-grammar
  '((build (single-char #\b)
           (value #t))
    (output (single-char #\o)
            (value #t))
    (directory (single-char #\d)
               (value #t))
    (stylesheet (single-char #\s)
                (value #t))
    (list (single-char #\l)
          (value #f))
    (minified (value #f))
    (no-minified (value #f))
    (help (single-char #\h)
          (value #f))
    (version (single-char #\V)
             (value #f))))

(define (build-table)
  "One line per build, for the help page."
  (string-join (map (lambda (spec)
                      (format #f "  ~a~%~a"
                              (car spec)
                              (format #f "      ~a - ~a"
                                      (cadr spec)
                                      (cadddr spec))))
                    build-specs)
               "\n"))

(define olive-css-help-text
  (string-append "olive-css "
                 olive-css-version
                 " - utility-class CSS framework written in Guile Scheme\n"
                 "\n"
                 "usage: olive-css COMMAND [OPTIONS]\n"
                 "\n"
                 "commands:\n"
                 "  generate             write the shipped stylesheets (default)\n"
                 "  tree-shake           keep only the classes a built site uses\n"
                 "  list                 print the build names and their files\n"
                 "\n"
                 "generate options:\n"
                 "  -b, --build NAME     write only this build (default: all)\n"
                 "  -o, --output FILE    write to FILE; needs exactly one build\n"
                 "  -l, --list           print the builds instead of writing them\n"
                 "      --minified       minify the output (the default)\n"
                 "      --no-minified    write readable CSS while debugging\n"
                 "\n"
                 "tree-shake options:\n"
                 "  -d, --directory DIR  built HTML to scan (default: public)\n"
                 "  -s, --stylesheet FILE\n"
                 "                       stylesheet to prune\n"
                 "                       (default: resources/css/olive.min.css)\n"
                 "  -o, --output FILE    output name inside DIR (default: olive.min.css)\n"
                 "\n"
                 "other options:\n"
                 "  -h, --help           show this help and exit\n"
                 "  -V, --version        show the version and exit\n"
                 "\n"
                 "builds:\n"
                 (build-table)
                 "\n"
                 "\n"
                 "examples:\n"
                 "  olive-css generate --build lucidplan\n"
                 "  olive-css generate --output /tmp/olive.css --build full\n"
                 "  olive-css tree-shake --directory _site --output app.min.css\n"
                 "  olive-css list\n"))

(define (show-help)
  "Print the full help page to standard output."
  (display olive-css-help-text))

(define (say-error format-string . arguments)
  "Report a failure on standard error, in one line."
  (format (current-error-port)
          "olive-css: ~a\n"
          (apply format #f format-string arguments)))

(define (usage-hint)
  (display "Try 'olive-css --help'.\n" (current-error-port)))

(define (normalize-args arguments)
  "Drop a leading \"--\", the marker the launcher passes to Guile."
  (if (and (pair? arguments)
           (string? (car arguments))
           (string=? "--" (car arguments)))
      (cdr arguments)
      arguments))

(define (command-and-options arguments)
  "Split ARGUMENTS into a command and the options that follow it.

An option without a command means `generate', so `olive-css --build full'
works like `olive-css generate --build full'."
  (cond
    ((null? arguments) (values "generate" '()))
    ((string-prefix? "-" (car arguments))
     (values "generate" arguments))
    (else (values (car arguments) (cdr arguments)))))

(define (parse-options arguments)
  "Parse ARGUMENTS, or return #f after reporting a usage error."
  (catch 'quit
    (lambda ()
      (getopt-long (cons "olive-css" arguments)
                   olive-css-option-grammar
                   #:stop-at-first-non-option #f))
    (lambda arguments
      ;; getopt-long prints the offending option itself; the exit status
      ;; tells the caller this was a usage error rather than a failed run.
      (usage-hint)
      #f)))

(define (ensure-directory path)
  "Create PATH and its parents when they are missing."
  (unless (and (file-exists? path)
               (eq? 'directory (stat:type (stat path))))
    (let ((parent (dirname path)))
      (unless (string=? parent path)
        (ensure-directory parent)))
    (mkdir path)))

(define (print-builds)
  "Print every build as NAME, FILE and a one-line description."
  (for-each (lambda (spec)
              (format #t "~a\t~a\t~a~%"
                      (car spec)
                      (cadr spec)
                      (cadddr spec)))
            build-specs))

(define (minified-according-to options)
  (cond
    ((option-ref options 'no-minified #f) #f)
    ((option-ref options 'minified #f) #t)
    (else #t)))

(define (generate options)
  "Write the requested builds.  Returns 0 on success, 1 on a failed run."
  (cond
    ((option-ref options 'list #f)
     (print-builds)
     0)
    (else
     (let* ((requested (option-ref options 'build #f))
            (output (option-ref options 'output #f))
            (names (if requested (list requested) (build-names))))
       (cond
         ((and requested (not (build-file requested)))
          (say-error "unknown build: ~a" requested)
          (say-error "the builds are: ~a" (string-join (build-names) ", "))
          1)
         ((and output (not requested))
          (say-error "an output path needs exactly one build, with --build")
          1)
         (else
          (parameterize ((minified? (minified-according-to options)))
            (for-each (lambda (name)
                        (let ((file (or output (build-file name))))
                          (ensure-directory (dirname file))
                          (write-css-to-file #:file file
                                             #:css-lines (build-css name))
                          (format #t "olive-css: wrote ~a (~a)~%" file name)))
                      names))
          0))))))

(define (report-tree-shake result)
  "Print what pruning did."
  (format #t "Tree-shaking: ~a used classes~%"
          (assoc-ref result 'used-classes))
  (format #t "  ~a: ~a bytes~%"
          (assoc-ref result 'stylesheet)
          (assoc-ref result 'input-bytes))
  (format #t "  ~a: ~a bytes~%"
          (assoc-ref result 'destination)
          (assoc-ref result 'output-bytes)))

(define (tree-shake-command options)
  "Prune the stylesheet to the classes under a built site."
  (let ((result (parameterize ((artifact-path (or (option-ref options
                                                             'directory
                                                             #f)
                                                  (artifact-path)))
                               (base-stylesheet-path (or (option-ref options
                                                                     'stylesheet
                                                                     #f)
                                                         (base-stylesheet-path)))
                               (output-css-target (or (option-ref options
                                                                 'output
                                                                 #f)
                                                      (output-css-target))))
                 (tree-shake))))
    (report-tree-shake result)
    0))

(define (run-command command options)
  (cond
    ((string=? command "generate") (generate options))
    ((string=? command "list") (print-builds) 0)
    ((string=? command "tree-shake") (tree-shake-command options))
    (else (say-error "unknown command: ~a" command)
          (usage-hint)
          2)))

(define (run-cli arguments)
  "Run the command in ARGUMENTS and return its exit status.

ARGUMENTS is the list of words after the program name, as in
@code{(run-cli '(\"generate\" \"--build\" \"full\"))}."
  (let ((clean (normalize-args arguments)))
    (call-with-values
        (lambda () (command-and-options clean))
      (lambda (command rest)
        (if (and (not (member command '("generate" "list" "tree-shake")))
                 (not (string-prefix? "-" command)))
            (begin
              (say-error "unknown command: ~a" command)
              (usage-hint)
              2)
            (let ((options (parse-options rest)))
              (cond
                ((not options) 2)
                ((option-ref options 'help #f)
                 (show-help)
                 0)
                ((option-ref options 'version #f)
                 (format #t "olive-css ~a~%" olive-css-version)
                 0)
                (else
                 (catch #t
                   (lambda ()
                     (run-command (if (member command '("generate" "list"
                                                       "tree-shake"))
                                      command
                                      "generate")
                                  options))
                   (lambda (key . details)
                     (say-error "~a" (if (null? details)
                                         key
                                         (car details)))
                     1))))))))))

(define (main arguments)
  "Entry point for the launcher; exits with the run's status."
  (exit (run-cli arguments)))
