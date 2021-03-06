;;Done at start to load faster
(cond
 ((string-match "linux" system-configuration)
  (if (fboundp 'menu-bar-mode) (menu-bar-mode -1)))
 ((string-match "apple" system-configuration)
  ;; (if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
  ))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))

;; (unless (file-exists-p (format "/tmp/emacs%d/server" (user-uid)))
;;   (server-start))

;; Emacs server
(require 'server)
(unless (server-running-p)
  (server-start))

(setq frame-title-format '("Emacs @ " system-name ": %b %+%+ %f")) ;set window title to full file name


;;http://www.hollenback.net/index.php/EmacsModeLine
;;http://www.gnu.org/software/emacs/elisp/html_node/Mode-Line-Variables.html#Mode-Line-Variables
(setq-default mode-line-format
              (list ""
                    ;; 'mode-line-mule-info
                    'mode-line-modified
                    ;; 'mode-line-frame-identification
                    'mode-line-buffer-identification
                    ;; '(getenv "HOST")
                    ;; ":"
                    ;; 'default-directory
                    ;; "   "
                    ;; was this buffer modified since the last save?
                    ;; the buffer name; the file name as a tool tip
                    ;; '(:eval (propertize "%b " 'face 'font-lock-keyword-face
                    ;;                     'help-echo (buffer-file-name)))


                    (propertize "%p" 'face 'font-lock-constant-face) ;; % above top line and column
                    "(" ;; '%02' to set to 2 chars at least; prevents flickering
                    (propertize "%02l" 'face 'font-lock-type-face) ","
                    (propertize "%02c" 'face 'font-lock-type-face)
                    ")"


                    ;; 'mode-line-position
                    '(vc-mode vc-mode)

                    ;; ;; the current major mode for the buffer.
                    ;; "["
                    ;; '(:eval (propertize "%m" 'face 'font-lock-string-face
                    ;;                     'help-echo buffer-file-coding-system))
                    ;; "] "

                    " "
                    'mode-line-modes
                    '(which-func-mode ("" which-func-format "--"))
                    '(global-mode-string ("--" global-mode-string))

                    ;; "["
                    ;; '(:eval (when (buffer-modified-p)
                    ;;           (concat " "   (propertize "Mod"
                    ;;                                    'face 'font-lock-warning-face
                    ;;                                    'help-echo "Buffer has been modified"))))

                    ;;  is this buffer read-only?
                    ;; '(:eval (when buffer-read-only
                    ;;           (concat ","  (propertize "RO"
                    ;;                                    'face 'font-lock-type-face
                    ;;                                    'help-echo "Buffer is read-only"))))
                    ;; "]"
                    "-%-"
                    )
              )

(push "/usr/local/bin" exec-path) ;needed for the mac, doesn't break/hurt linux
(push "~/.rvm/bin/rvm-prompt" exec-path)

;;------------------------------------------------
;;== LOAD PATH, AUTOLOADS, REQUIRES AND FILE ASSOCIATIONS
;;------------------------------------------------
(setq emacs-dir (file-name-directory (or (buffer-file-name) load-file-name)))

;; (when (file-exists-p "~/.emacs.d/kylpo-secrets-file")
;;   (load "~/.emacs.d/kylpo-secrets-file"))

(require 'cl)				; common lisp goodies, loop
(require 'tramp)


;;=elpa+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
(require 'package)

(add-to-list 'package-archives
             '( "original" . "http://tromey.com/elpa/" ))
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives
             '("gnu" . "http://elpa.gnu.org/packages/"))
(add-to-list 'package-archives
             '("sunrise-commander" . "http://joseito.republika.pl/sunrise-commander/"))
(package-initialize)

(when (not package-archive-contents)
  (package-refresh-contents))

(defvar my-packages '(
                      ;; starter-kit
                      ;; starter-kit-lisp
		      idle-highlight-mode
                      starter-kit-ruby
                      ;; starter-kit-js
                      flymake-cursor
                      redo+
                      css-mode
                      buffer-move
                      auto-complete
                      goto-last-change
                      multi-term
                      yaml-mode
                      less-css-mode
                      rvm
                      ;; erc-hl-nicks
                      sunrise-commander
                      sunrise-x-tree
                      rainbow-mode
                      wrap-region
                      yari
                      flymake-ruby
                      flymake-jshint
                      flymake-coffee
                      haml-mode
                      sass-mode
                      yasnippet
                      smart-tab
                      org
                      js2-mode
                      find-file-in-project
                      ;; ido-ubiquitous
                      elisp-slime-nav
                      paredit
		      smex
                      php-mode
                      markdown-mode
                      textmate
                      full-ack
                      ;; ruby-block
                      worklog
                      projectile
                      ;; sr-speedbar
                      anything
                      ))

(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))

;;from elpa
(require 'flymake-cursor)
(require 'redo+)
(require 'auto-complete)
(require 'buffer-move)
(require 'idle-highlight-mode)
(require 'starter-kit-defuns) ;must require after idle-highlight
;; (require 'ruby-block)
(require 'projectile)
(require 'sunrise-commander)
(require 'sunrise-x-tree)




(when (require 'yasnippet nil 'noerror)
  (yas/initialize)
  (yas/load-directory "~/.emacs.d/vendor/yasnippets"))

;;=smex
(setq smex-save-file (concat emacs-dir ".smex-items"))
(smex-initialize)
(global-set-key (kbd "M-x") 'smex)

;;=css
(setq css-indent-level 2)
(setq css-indent-offset 2)


(global-set-key (kbd "<C-S-up>") 'buf-move-up)
(global-set-key (kbd "<C-S-down>") 'buf-move-down)
(global-set-key (kbd "<C-S-left>") 'buf-move-left)
(global-set-key (kbd "<C-S-right>") 'buf-move-right)

(global-set-key (kbd "C-x C-/") 'goto-last-change)

;;(multi-term-keystroke-setup)
(setq multi-term-program "/bin/bash")

(autoload 'yaml-mode "yaml-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.ya?ml\\'" . yaml-mode))
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
(add-to-list 'auto-mode-alist '("\\.yaml$" . yaml-mode))

(add-hook 'ruby-mode-hook
          '(lambda ()
             (setq ruby-deep-arglist t)
             (setq ruby-deep-indent-paren nil)
             (setq c-tab-always-indent nil)
             (require 'inf-ruby)
             (require 'ruby-compilation)))
(add-hook 'ruby-mode-hook
          (lambda()
            (add-hook 'local-write-file-hooks
                      '(lambda()
                         (save-excursion
                           (untabify (point-min) (point-max))
                           (delete-trailing-whitespace)
                           )))
            (set (make-local-variable 'indent-tabs-mode) 'nil)
            (set (make-local-variable 'tab-width) 2)
            (imenu-add-to-menubar "IMENU")
            (local-set-key "\r" 'newline-and-indent);ret indents
            ;; (require 'ruby-electric)
            (define-key ruby-mode-map (kbd "#") 'ruby-interpolate)
            ;; (ruby-electric-mode t)
))

;; (add-hook 'text-mode-hook 'turn-on-auto-fill)
;; (add-hook 'text-mode-hook 'turn-on-flyspell)

(add-hook 'emacs-lisp-mode-hook 'turn-on-eldoc-mode)
(add-hook 'emacs-lisp-mode-hook 'esk-prog-mode-hook)
(add-hook 'emacs-lisp-mode-hook 'elisp-slime-nav-mode)


;;=el-get+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
(add-to-list 'load-path "~/.emacs.d/el-get/el-get")

(unless (require 'el-get nil t)
  :  (url-retrieve
      "https://github.com/dimitri/el-get/raw/master/el-get-install.el"
      (lambda (s)
        (end-of-buffer)
        (eval-print-last-sexp))))

(setq
 el-get-sources
 '(
   (:name magit
          :after (lambda ()
                   (global-set-key (kbd "C-x g") 'magit-status)))

   (:name rhtml-mode
          :after (lambda ()
                   (autoload 'rhtml-mode "rhtml-mode" nil t)
                   (add-to-list 'auto-mode-alist '("\\.erb\\'" . rhtml-mode))
                   (add-to-list 'auto-mode-alist '("\\.rjs\\'" . rhtml-mode))
                   (add-to-list 'auto-mode-alist '("\\.rhtml$" . rhtml-mode))
                   (add-hook 'rhtml-mode
                             '(lambda ()
                                (define-key rhtml-mode-map (kbd "M-s") 'save-buffer)))))
   (:name etags-table
          :type emacswiki
          :features etags-table
          :after (lambda ()
                   (setq etags-table-search-up-depth 10)))

   (:name column-marker
          :type emacswiki
          :features column-marker
          :after (lambda ()
                   (dolist (hook '(emacs-lisp-mode-hook
                                   cperl-mode-hook
                                   shell-mode-hook
                                   text-mode-hook
                                   change-log-mode-hook
                                   makefile-mode-hook
                                   message-mode-hook
                                   texinfo-mode-hook
                                   c-mode-hook
                                   emacs-listp-mode-hook
                                   html-mode-hook
                                   ruby-mode-hook))
                     (add-hook hook (lambda ()
                                      (interactive)
                                      (column-marker-1 80)
                                      (column-marker-2 120)
                                      ;; (column-marker-3 80)
                                      )))

                   (set-face-background 'column-marker-1 "#2b2b2b")
                   (set-face-background 'column-marker-2 "red")))

   ;; (:name elscreen
   ;;        :description "Screen Manager for Emacsen"
   ;;        :type http-tar
   ;;        :depends apel
   ;;        :options ("xzf")
   ;;        :url "ftp://210.155.141.202/pub/morishima.net/naoto/ElScreen/elscreen-1.4.6.tar.gz"
   ;;        :features elscreen)
   ))

(setq
 my:el-get-packages
 '(el-get
   ;; ack
   ;; emacs-goodies-el
   ;; js2-mode
   ;; rvm
   ;; rspec-mode
   ;; magit
   dired+ ;;http://www.emacswiki.org/emacs/DiredPlus#Dired%2b
   ;; php-mode-improved			; if you're into php...
   erc-highlight-nicknames
   ;; scala-mode
   ;; zencoding-mode			;
   ;; http://www.emacswiki.org/emacs/ZenCoding
   ;; sunrise-commander
   ;; sunrise-x-tree
   nav
   rinari
   ;; nxhtml
   coffee-mode
   ace-jump-mode
   mustache-mode
   ;; evil
   deft
  ;; sr-speedbar
   tree-mode
   windata
   ))

(setq stack-trace-on-error t)


(setq my:el-get-packages
      (append
       my:el-get-packages
       (loop for src in el-get-sources collect (el-get-source-name src))))

;; install new packages and init already installed packages
(el-get 'sync my:el-get-packages)


(load-file "~/.emacs.d/vendor/emacs-dirtree/dirtree.el")
(add-to-list 'load-path "~/.emacs.d/vendor/emacs-tiny-tools/lisp/tiny")
(add-to-list 'load-path "~/.emacs.d/vendor/emacs-starter-kit/")
(add-to-list 'load-path "~/.emacs.d/vendor/campfire/")
(add-to-list 'load-path "~/.emacs.d/vendor/js3-mode/")
;;(add-to-list 'load-path "~/.emacs.d/vendor/ecb/")
(add-to-list 'load-path "~/.emacs.d/vendor/emacs-prelude/modules/")
(require 'prelude-coffee)
(add-to-list 'load-path "~/.emacs.d/vendor/")
(require 'sr-speedbar)
(require 'tinyeat)
;;(require 'ecb)




(add-to-list 'auto-mode-alist '("\\.php$" . php-mode))
(add-to-list 'auto-mode-alist '("\\.inc$" . php-mode))
;; We never want to edit Rubinius bytecode
(add-to-list 'completion-ignored-extensions ".rbc")

;; Deal with colors in shell mode correctly
(autoload 'ansi-color-for-comint-mode-on "ansi-color" nil t)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

(autoload 'markdown-mode "markdown-mode.el" "Major mode for editing Markdown files" t)
(setq auto-mode-alist (cons '("\\.text" . markdown-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.md" . markdown-mode) auto-mode-alist))

(defun coffee-custom ()
  "coffee-mode-hook"
  (set (make-local-variable 'tab-width) 2))
(add-hook 'coffee-mode-hook
            '(lambda() (coffee-custom)))

;;=color
;; (add-to-list 'custom-theme-load-path "~/.emacs.d/vendor/themes/zenburn-emacs")
;; (load-theme 'zenburn)
;;(set-face-foreground 'erc-pal-face "#8cd0d3")
;;(setq term-default-bg-color "#3f3f3f")        ;; background color (black)
;;(setq term-default-fg-color "#dcdccc")       ;; foreground color (yellow)


;;------------------------------------------------
;; == Platform Dependencies
;;------------------------------------------------
(cond
 ((string-match "nt" system-configuration)
  );;end windows
 ((string-match "apple" system-configuration)
  (set-face-attribute 'default (not 'this-frame-only) :height 100 :foundry "unknown" :family "Monaco")
  (defun dired-do-shell-mac-open-vqn ()
    (interactive)
    (save-window-excursion
      (dired-do-async-shell-command
       "open" current-prefix-arg
       (dired-get-marked-files t current-prefix-arg))))

  (add-hook 'dired-mode-hook (lambda () (local-set-key "E" 'dired-do-shell-mac-open-vqn)))

  (defun gnome-open-file (filename)
    "gnome-opens the specified file."
    (interactive "File to open: ")
    (let ((process-connection-type nil))
      (start-process "" nil "/usr/bin/open" filename)))

  (defun iterm ()
    "gnome-opens the specified file."
    (interactive)
    (let ((process-connection-type nil))
      (start-process "" nil "/usr/bin/open" "/Applications/iTerm.app/Contents/MacOS/iTerm")))
  );;end apple

 ((string-match "linux" system-configuration)
  ;;start LINUX
  ;;  (setq browse-url-browser-function 'browse-url-generic browse-url-generic-program "/usr/bin/conkeror")
  ;;10pt font aka :height 10*10=100
  ;; (set-face-attribute 'default (not 'this-frame-only) :height 90 :foundry "unknown" :family "Droid Sans Mono")
  (set-face-attribute 'default (not 'this-frame-only) :height 80 :foundry "unknown" :family "Monaco")
  (setq browse-url-generic-program (executable-find "firefox")
        browse-url-browser-function 'browse-url-generic)

  (defun gnome-open-file (filename)
    "gnome-opens the specified file."
    (interactive "File to open: ")
    (let ((process-connection-type nil))
      (start-process "" nil "/usr/bin/gnome-open" filename)))

  (defun dired-gnome-open-file ()
    "Opens the current file in a Dired buffer."
    (interactive)
    (gnome-open-file (dired-get-file-for-visit)))

  (add-hook 'dired-mode-hook (lambda () (local-set-key "E" 'dired-gnome-open-file)))
  ;;doesn't work in os x
  (setq dired-listing-switches "-lXGh --group-directories-first")
  );;end linux
 )

;;------------------------------------------------
;; == INIT & CONFIG
;;------------------------------------------------



;;=speedbar
(setq speedbar-use-images nil)

;;=deft
(setq deft-extension "txt")
(setq deft-directory "~/Dropbox/notes")
(setq deft-text-mode 'markdown-mode)
;; (setq deft-extension "org")
;; (setq deft-text-mode 'org-mode)
(setq deft-use-filename-as-title t)
(global-set-key [f8] 'deft)


(setq visible-bell nil)
;;ctags
(setq path-to-ctags "/usr/local/bin/ctags") ;; <- your ctags path her
(defun create-tags (dir-name)
  "Create tags file."
  (interactive "DDirectory: ")
  (shell-command
   (format "%s -f %s/TAGS -e -R %s" path-to-ctags dir-name (directory-file-name dir-name)))
  )

;; smart indenting and pairing for all
(electric-pair-mode t)
(electric-indent-mode t)
(electric-layout-mode t)

;; meaningful names for buffers with the same name
(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)
(setq uniquify-separator "/")
(setq uniquify-after-kill-buffer-p t)    ; rename after killing uniquified
(setq uniquify-ignore-buffers-re "^\\*") ; don't muck with special buffers

(set-default 'indent-tabs-mode nil)
(set-default 'indicate-empty-lines t)
(set-default 'imenu-auto-rescan t)

;; Hippie expand: at times perhaps too hip
;; (dolist (f '(try-expand-line try-expand-list try-complete-file-name-partially))
;;   (delete f hippie-expand-try-functions-list))

;; ;; Add this back in at the end of the list.
;; (add-to-list 'hippie-expand-try-functions-list 'try-complete-file-name-partially t)

(setq hippie-expand-try-functions-list '(try-expand-dabbrev
                                         try-expand-dabbrev-all-buffers
                                         try-expand-dabbrev-from-kill
                                         try-complete-file-name-partially
                                         try-complete-file-name
                                         try-expand-all-abbrevs
                                         try-expand-list
                                         try-expand-line
                                         try-complete-lisp-symbol-partially
                                         try-complete-lisp-symbol))

(eval-after-load 'grep
  '(when (boundp 'grep-find-ignored-files)
     (add-to-list 'grep-find-ignored-files "*.class")))


;;=autocomplete
;; Start auto-completion after 2 characters of a word
(setq ac-auto-start 2)
;; case sensitivity is important when finding matches
(setq ac-ignore-case nil)


;; This is a little hacky since VC doesn't support git add internally
(eval-after-load 'vc
  (define-key vc-prefix-map "i"
    '(lambda () (interactive)
       (if (not (eq 'Git (vc-backend buffer-file-name)))
           (vc-register)
         (shell-command (format "git add %s" buffer-file-name))
         (message "Staged changes.")))))

;;=eshell
;; Part of the Emacs Starter Kit
(setq eshell-cmpl-ignore-case t)

(setq eshell-cmpl-cycle-completions nil
      eshell-save-history-on-exit t
      eshell-cmpl-dir-ignore "\\`\\(\\.\\.?\\|CVS\\|\\.svn\\|\\.git\\)/\\'")

(eval-after-load 'esh-opt
  '(progn
     (require 'em-prompt)
     (require 'em-term)
     (require 'em-cmpl)
     (setenv "PAGER" "cat")
     (set-face-attribute 'eshell-prompt nil :foreground "turquoise1")
     (add-hook 'eshell-mode-hook ;; for some reason this needs to be a hook
               '(lambda () (eshell/export "TERM" "dumb")))
     (when (< emacs-major-version 23)
       (add-hook 'eshell-mode-hook ;; for some reason this needs to be a hook
                 '(lambda () (define-key eshell-mode-map "\C-a" 'eshell-bol)))
       (add-to-list 'eshell-output-filter-functions 'eshell-handle-ansi-color))

     (add-to-list 'eshell-visual-commands "ssh")
     (add-to-list 'eshell-visual-commands "tail")
     (add-to-list 'eshell-command-completions-alist
                  '("gunzip" "gz\\'"))
     (add-to-list 'eshell-command-completions-alist
                  '("tar" "\\(\\.tar|\\.tgz\\|\\.tar\\.gz\\)\\'"))))

(defun eshell/cds ()
  "Change directory to the project's root."
  (eshell/cd (locate-dominating-file default-directory "src")))

(setq
 uniquify-buffer-name-style 'post-forward
 uniquify-separator ":")

;;=desktop
;; save a bunch of variables to the desktop file
;; for lists specify the len of the maximal saved data also
(setq desktop-globals-to-save
      (append '((extended-command-history . 30)
                (file-name-history        . 100)
                (grep-history             . 30)
                (compile-history          . 30)
                (minibuffer-history       . 50)
                (query-replace-history    . 60)
                (read-expression-history  . 60)
                (regexp-history           . 60)
                (regexp-search-ring       . 20)
                (search-ring              . 20)
                (shell-command-history    . 50)
                tags-file-name
                register-alist)))

(setq bookmark-default-file "~/.emacs.d/emacs.bmk")

(setq ibuffer-shrink-to-minimum-size t)
(setq ibuffer-always-show-last-buffer nil)
(setq ibuffer-sorting-mode 'recency)
(setq ibuffer-use-header-line t)

;;Display
;; Use a vertical bar as cursor
(blink-cursor-mode 1)
;;(setq-default cursor-type '(bar . 2))
(setq-default indicate-empty-lines t)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(prefer-coding-system 'utf-8)
(setq c-basic-offset 2) ; Indenting is 2 spaces
(global-font-lock-mode 1) ; Enable syntax highlighting when editing code.
(show-paren-mode 1) ; Highlight the matching paren
;;show line of matching paren when off buffer
(defadvice show-paren-function
  (after show-matching-paren-offscreen activate)
  "If the matching paren is offscreen, show the matching line in the
        echo area. Has no effect if the character before point is not of
        the syntax class ')'."
  (interactive)
  (if (not (minibuffer-prompt))
      (let ((matching-text nil))
        ;; Only call `blink-matching-open' if the character before point
        ;; is a close parentheses type character. Otherwise, there's not
        ;; really any point, and `blink-matching-open' would just echo
        ;; "Mismatched parentheses", which gets really annoying.
        (if (char-equal (char-syntax (char-before (point))) ?\))
            (setq matching-text (blink-matching-open)))
        (if (not (null matching-text))
            (message matching-text)))))

(setq transient-mark-mode t) ; Highlight selected regions
(setq inhibit-startup-screen t) ; Dont load the about screen on load
(fset 'yes-or-no-p 'y-or-n-p)
(column-number-mode t) ; Show cursors X + Y coordinates in modeline
;; (display-time-mode t)
;; (display-battery-mode t)
(global-hl-line-mode t) ; Highlight the current line

;;=ispell
(setq ispell-program-name "/usr/local/bin/aspell");;homebrew default location
(setq ispell-list-command "list")



;;=ido-mode
(setq ido-enable-prefix nil
      ;; ido-case-fold  t ; be case-insensitive
      ido-enable-last-directory-history t ; remember last used dirs
      ido-max-work-directory-list 30   ; should be enough
      ido-max-work-file-list 50   ; remember many
      ido-enable-flex-matching t
      ido-create-new-buffer 'always
      ido-use-filename-at-point nil
      ;; ido-show-dot-for-dired t
      ido-everywhere t ;use for many file dialogs
      ido-save-directory-list-file "~/.emacs.d/.ido.last"
      ido-ignore-buffers '("\\` " "^\*Mess" "^\*Back" ".*Completion" "^\*Ido" "*scratch*" "^\\*tramp" "^\\*Messages\\*" " output\\*$" "^#" "^irc")
      ;; ido-ignore-files '("*\.jpg" "(pyc|jpg|png|gif)$");TODO doesn't work
      ido-max-prospects 20
      ido-confirm-unique-completion nil
      ido-auto-merge-work-directories-length nil
      ido-use-virtual-buffers t
      ido-handle-duplicate-virtual-buffers 2
      )
(ido-mode t) ; User ido mode for both buffers and files


;; when using ido, the confirmation is rather annoying...
(setq confirm-nonexistent-file-or-buffer nil)

;; Display ido results vertically, rather than horizontally
(setq ido-decorations (quote ("\n-> " "" "\n   " "\n   ..." "[" "]" " [No match]" " [Matched]" " [Not readable]" " [Too big]" " [Confirm]")))

;; Since it is veritcal, use C-n/p to navigate, not C-s/r
(add-hook 'ido-setup-hook
          (lambda ()
            (define-key ido-file-dir-completion-map (kbd "C-n")
              'ido-next-match)
            (define-key ido-file-dir-completion-map (kbd "C-p")
              'ido-prev-match)))

(defun ido-disable-line-trucation () (set (make-local-variable 'truncate-lines) nil))
(add-hook 'ido-minibuffer-setup-hook 'ido-disable-line-trucation)

(add-hook 'before-save-hook 'delete-trailing-whitespace)
(set-default 'imenu-auto-rescan t)

;;=term
;;
;; If you do use M-x term, you will notice there's line mode that acts like
;; emacs buffers, and there's the default char mode that will send your
;; input char-by-char, so that curses application see each of your key
;; strokes.
;;
;; The default way to toggle between them is C-c C-j and C-c C-k, let's
;; better use just one key to do the same.
(require 'term)
(define-key term-raw-map (kbd "C-c '") 'term-line-mode)
(define-key term-mode-map (kbd "C-c '") 'term-char-mode)

;; (setq term-default-bg-color "#3f3f3f")        ;; background color (black)
;; (setq term-default-fg-color "#dcdccc")       ;; foreground color (yellow)

;; Have C-y act as usual in term-mode, to avoid C-' C-y C-'
;; Well the real default would be C-c C-j C-y C-c C-k.
(define-key term-raw-map (kbd "C-y") 'term-paste)

(setq whitespace-style '(trailing lines space-before-tab indentation space-after-tab))

;; (recentf-mode 1)
(setq backup-directory-alist (list (cons ".*" (expand-file-name "~/bak/emacs/")))) ; Temp files
(setq x-select-enable-clipboard t) ; Integrate with X11s clipboard
(setq-default indent-tabs-mode nil) ; Dont indent with tabs
(setq confirm-kill-emacs 'yes-or-no-p) ; stops me killing emacs by accident!
;; (setq scroll-step 1) ; Only scroll down 1 line at a time
;; (setq scroll-conservatively 10) ; make scroll less jumpy
;; (setq scroll-margin 4) ; scroll will start b4 getting to top/bottom of page

;; activate disabled features
(put 'narrow-to-region 'disabled nil)
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)

;; (setq tab-always-indent 'complete) ;smart tab integrated into emacs

(font-lock-add-keywords nil '(("\\<\\(FIX\\|TODO\\|FIXME\\|HACK\\|REFACTOR\\) " 1 font-lock-warning-face t)))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (zenburn)))
 '(custom-safe-themes (quote ("59df2ce8018002886b07ed8a1406a53494ec3caaa8bf87c9820250cc5c7fcc2d" "4920f9add5c557ae792965db34fc6f104ba24675" "1bd6e2ae006ae5982ece6f4c5189d541671b366b" "b1ca0ce11f45aaa5c0edea1a6b6b918b7dee6aa0" default)))
 '(dirtree-windata (quote (frame left 0.2 delete)))
 '(ecb-options-version "2.40")
 '(js-indent-level 2)
 '(org-modules (quote (org-bbdb org-bibtex org-docview org-gnus org-info org-jsinfo org-irc org-mew org-mhe org-rmail org-vm org-wl org-w3m org-velocity)))
 '(sr-show-file-attributes nil)
 '(sr-speedbar-right-side nil)
 '(sr-speedbar-width-console 40)
 '(sr-speedbar-width-x 40)
 '(uniquify-buffer-name-style (quote forward) nil (uniquify))
 '(wg-morph-on nil)
 '(wg-switch-on-load nil))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(elscreen-tab-background-face ((t nil)))
 '(elscreen-tab-other-screen-face ((t nil)))
 '(mumamo-background-chunk-major ((t (:background "#3f3f3f"))) t)
 '(mumamo-background-chunk-submode1 ((t (:background "#2f2f2f"))) t))

;;------------------------------------------------
;;=Functions
;;------------------------------------------------

;;TAKEN FROM ___
(defun isearch-exit-at-opposite-end ()
  "by default isearch forward ends at end and isearch backward
  ends at beginning. this makes it do the opposite."
  (interactive)
  (add-hook 'isearch-mode-end-hook 'isearch-move-point-to-opposite-end)
  (isearch-exit))

(defun isearch-move-point-to-opposite-end ()
  (funcall (if isearch-forward #'backward-char #'forward-char)
           (length isearch-string))
  (remove-hook 'isearch-mode-end-hook 'isearch-move-point-to-opposite-end))

(define-key isearch-mode-map (kbd "<C-return>") 'isearch-exit-at-opposite-end)

;;; similar to o and O in vim. Use M-1 C-o to go above and M-2 C-o to go
;;; below. C-o is normal emacs behavior
(defun jsj-open-line (&optional alt)
  (interactive "P")
  (case alt
    (1 (beginning-of-line)
       (newline)
       (forward-line -1)
       (indent-according-to-mode))
    (2 (end-of-line)
       (newline-and-indent))
    (t (open-line 1))))

(define-key global-map (kbd "C-o") 'jsj-open-line)


(defun select-current-line ()
  "Select the current line"
  (interactive)
  (end-of-line) ; move to end of line
  (set-mark (line-beginning-position)))

(defun edit-init ()
  "Load the .emacs file into a buffer for editing."
  (interactive)
  (find-file "~/.emacs.d/init.el"))

(defun delete-file-and-buffer ()
  "Deletes the current file and buffer, assumes file exists"
  (interactive)
  (delete-file buffer-file-name)
  (kill-buffer (buffer-name)))

;; I-search with initial contents
;; from http://platypope.org/blog/2007/8/5/a-compendium-of-awesomeness
(defvar isearch-initial-string nil)

(defun isearch-set-initial-string ()
  (remove-hook 'isearch-mode-hook 'isearch-set-initial-string)
  (setq isearch-string isearch-initial-string)
  (isearch-search-and-update))

(defun isearch-forward-at-point (&optional regexp-p no-recursive-edit)
  "Interactive search forward for the symbol at point."
  (interactive "P\np")
  (if regexp-p (isearch-forward regexp-p no-recursive-edit)
    (let* ((end (progn (skip-syntax-forward "w_") (point)))
           (begin (progn (skip-syntax-backward "w_") (point))))
      (if (eq begin end)
          (isearch-forward regexp-p no-recursive-edit)
        (setq isearch-initial-string (buffer-substring begin end))
        (add-hook 'isearch-mode-hook 'isearch-set-initial-string)
        (isearch-forward regexp-p no-recursive-edit)))))

(defun hotkeys()
  (interactive)
  (find-file "~/spideroak/notes/emacs/hotkeys.org")
  )

;; Emacs macro to add a pomodoro item
(fset 'pomodoro
      "[ ]")

;; Emacs macro to add a pomodoro table
;; | G | Organization | [ ] |
;; |   |              |     |
(fset 'pomodoro-table
      [?| ?  ?G ?  ?| ?  ?O ?r ?g ?a ?n ?i ?z ?a ?t ?i ?o ?n ?  ?| ?  ?\[ ?  ?\] ?  ?| tab])

(defun select-current-word ()
  "Select the word under cursor.
“word” here is considered any alphanumeric sequence with “_” or “-”."
  (interactive)
  (let (pt)
    (skip-chars-backward "-_A-Za-z0-9")
    (setq pt (point))
    (skip-chars-forward "-_A-Za-z0-9")
    (set-mark pt)
    ))

;; http://stackoverflow.com/questions/847962/what-alternate-session-managers-are-available-for-emacs
(defvar my-desktop-session-dir
  (concat (getenv "HOME") "/.emacs.d/desktop-sessions/")
  "*Directory to save desktop sessions in")

(defvar my-desktop-session-name-hist nil
  "Desktop session name history")

(defun my-desktop-save (&optional name)
  "Save desktop with a name."
  (interactive)
  (unless name
    (setq name (my-desktop-get-session-name "Save session as: ")))
  (make-directory (concat my-desktop-session-dir name) t)
  (desktop-save (concat my-desktop-session-dir name) t))

(defun my-desktop-read (&optional name)
  "Read desktop with a name."
  (interactive)
  (unless name
    (setq name (my-desktop-get-session-name "Load session: ")))
  (desktop-read (concat my-desktop-session-dir name)))

(defun my-desktop-get-session-name (prompt)
  (completing-read prompt (and (file-exists-p my-desktop-session-dir)
                               (directory-files my-desktop-session-dir))
                   nil nil nil my-desktop-session-name-hist))

(defun kylpo-zap-back-to-char (arg char)
  "Kill up to ARG'th occurrence of CHAR.
     Case is ignored if `case-fold-search' is non-nil in the current buffer.
     Goes forward if ARG is negative; error if CHAR not found."
  (interactive "p\ncZap back to char: ")
  (if (char-table-p translation-table-for-input)
      (setq char (or (aref translation-table-for-input char) char)))
  (kill-region (point) (progn
                         (search-backward (char-to-string char)
                                          nil nil arg)
                         (point)))
  (insert char))

;; Behave like vi's o command
(defun open-next-line (arg)
  "Move to the next line and then opens a line.
    See also `newline-and-indent'."
  (interactive "p")
  (end-of-line)
  (open-line arg)
  (next-line 1)
  (when newline-and-indent
    (indent-according-to-mode)))

;; Behave like vi's O command
(defun open-previous-line (arg)
  "Open a new line before the current one.
     See also `newline-and-indent'."
  (interactive "p")
  (beginning-of-line)
  (open-line arg)
  (when newline-and-indent
    (indent-according-to-mode)))

;; ;; Autoindent open-*-lines
;; (defvar newline-and-indent t
;;   "Modify the behavior of the open-*-line functions to autoindent.")

(defun my-delete-backward-to-ws ()
  (interactive)
  (delete-region (point) (save-excursion (skip-syntax-backward "^ ") (point))))

(defun window-half-height () ;http://www.emacswiki.org/emacs/HalfScrolling
  (max 1 (/ (1- (window-height (selected-window))) 2)))

(defun sfp-page-down ()
  (interactive)
  (setq this-command 'next-line)
  (next-line
   (- (window-text-height)
      next-screen-context-lines)))

(defun sfp-page-up ()
  (interactive)
  (setq this-command 'previous-line)
  (previous-line
   (- (window-text-height)
      next-screen-context-lines)))

(defun kylpo-page-down-half ()
  (interactive)
  (setq this-command 'next-line)
  (next-line (window-half-height)))

(defun kylpo-page-up-half ()
  (interactive)
  (setq this-command 'previous-line)
  (previous-line (window-half-height)))

(defun scroll-up-half ()
  (interactive)
  (scroll-up (window-half-height)))

(defun scroll-down-half ()
  (interactive)
  (scroll-down (window-half-height)))

;; kill entire word, even if in middle of word
(defun my-kill-word ()
  (interactive)
  (backward-word)
  (kill-word 1))
;;(global-set-key (kbd "M-d") 'my-kill-word)

(defun ruby-interpolate ()
  "In a double quoted string, interpolate."
  (interactive)
  (insert "#")
  (when (and
         (looking-back "\".*")
         (looking-at ".*\""))
    (insert "{}")
    (backward-char 1)))

(defadvice zap-to-char (after my-zap-to-char-advice (arg char) activate)
  "Kill up to the ARG'th occurence of CHAR, and leave CHAR. If
  you are deleting forward, the CHAR is replaced and the point is
  put before CHAR"
  (insert char)
  (if (< 0 arg) (forward-char -1)))

(defmacro bind (key fn)
  "shortcut for global-set-key"
  `(global-set-key (kbd ,key)
                   ;; handle unquoted function names and lambdas
                   ,(if (listp fn)

                      `',fn)))

(defmacro cmd (name &rest body)
  "declare an interactive command without all the boilerplate"
  `(defun ,name ()
     ,(if (stringp (car body)) (car body))
     ;; tried (let (documented (stringp (first body))) but didn't know gensym
     ;; and couldn't get it to work. should be possible
     (interactive)
     ,@(if (stringp (car body)) (cdr `,body) body)))

(defun eshell/emacs (tags) ;;eshell rtags alias
  (rtags --recurse .))

(defun rtags ()
  (interactive)
  ;; (shell-command "etags -a -f TAGS *"))
  (shell-command "ctags -e -a --Ruby-kinds=-fF -o TAGS -R ."))
;;"ctags -e -a --Ruby-kinds=-fF -o TAGS -R . "))
;; (shell-command "etags -a --Ruby-kinds=f -o TAGS -R . "))

(defun isearch-occur ()
  "Invoke `occur' from within isearch."
  (interactive)
  (let ((case-fold-search isearch-case-fold-search))
    (occur (if isearch-regexp isearch-string (regexp-quote isearch-string)))))

(defun backward-buffer () (interactive)
  "Switch to previously selected buffer."
  (let* ((list (cdr (buffer-list)))
         (buffer (car list)))
    (while (and (cdr list) (string-match "\\*" (buffer-name buffer)))
      (progn
        (setq list (cdr list))
        (setq buffer (car list))))
    (bury-buffer)
    (switch-to-buffer buffer)))

(defun forward-buffer () (interactive)
  "Opposite of backward-buffer."
  (let* ((list (reverse (buffer-list)))
         (buffer (car list)))
    (while (and (cdr list) (string-match "\\*" (buffer-name buffer)))
      (progn
        (setq list (cdr list))
        (setq buffer (car list))))
    (switch-to-buffer buffer)))

(cmd scroll-down-keep-cursor
     "Scroll the text one line down while keeping the cursor"
     (scroll-down 1))

(cmd scroll-up-keep-cursor
     "Scroll the text one line up while keeping the cursor"
     (scroll-up 1))

(cmd isearch-other-window
     ;; thank you leo2007!
     (save-selected-window
       (other-window 1)
       (isearch-forward)))

(cmd comment-or-uncomment-current-line-or-region
     "Comments or uncomments current current line or whole lines in region."
     (save-excursion
       (let (min max)
         (if (and transient-mark-mode mark-active)
             (setq min (region-beginning) max (region-end))
           (setq min (point) max (point)))
         (comment-or-uncomment-region
          (progn (goto-char min) (line-beginning-position))
          (progn (goto-char max) (line-end-position))))))

(defun ido-open-find-directory-files (directory)
  (let ((directory (concat (expand-file-name directory) "/")))
    (concat directory
            (ido-completing-read
             (concat directory ": ")
             (mapcar (lambda (path)
                       (replace-regexp-in-string (concat "^" (regexp-quote directory) "/") "" path))
                     (split-string
                      (shell-command-to-string
                       (concat "find \"" directory "\" -type f | grep -v \"/.git/\" | grep -v \"/.yardoc/\""))))))))

(defun ido-find-file-in-tag-files ()
  (interactive)
  (save-excursion
    (let ((enable-recursive-minibuffers t))
      (visit-tags-table-buffer))
    (find-file
     (expand-file-name
      (ido-completing-read
       "Project file: " (tags-table-files) nil t)))))

(defun my-ido-find-tag ()
  "Find a tag using ido"
  (interactive)
  (tags-completion-table)
  (let (tag-names)
    (mapc (lambda (x)
            (unless (integerp x)
              (push (prin1-to-string x t) tag-names)))
          tags-completion-table)
    (find-tag (ido-completing-read "Tag: " tag-names))))

(defun org-gcal-sync ()
  "Export org to ics to be uploaded to Google Calendar and import
an .ics file that has been downloaded from Google Calendar "
  (org-export-icalendar-combine-agenda-files)
  (icalendar-import-file "~/tmp/.basic.ics" "~/tmp/.gcal"))


;;(defalias 'iwb 'indent-whole-buffer)

(defun toggle-fullscreen ()
  (interactive)
  (x-send-client-message nil 0 nil "_NET_WM_STATE" 32
                         '(2 "_NET_WM_STATE_MAXIMIZED_VERT" 0))
  (x-send-client-message nil 0 nil "_NET_WM_STATE" 32
                         '(2 "_NET_WM_STATE_MAXIMIZED_HORZ" 0))
  )

(defun switch-full-screen (&optional ii)
  (interactive "p")
  (if (> ii 0)
      (shell-command "wmctrl -r :ACTIVE: -badd,fullscreen"))
  (if (< ii 0)
      (shell-command "wmctrl -r :ACTIVE: -bremove,fullscreen"))
  (if (equal ii 0)
      (shell-command "wmctrl -r :ACTIVE: -btoggle,fullscreen")))

(defun switch-full-screen-toggle ()
  (interactive)
  (set-frame-parameter nil 'fullscreen
                       (if (frame-parameter nil 'fullscreen) nil 'fullboth)))

(defun darkroom-mode ()
  "Make things simple-looking by removing decoration
         and choosing a simple theme."
  (interactive)
  (switch-full-screen 1)     ;; requires above function
  ;;(color-theme-retro-green)  ;; requires color-theme
  (setq left-margin 30)
  (setq fill-column 100)
  (menu-bar-mode -1)
  (tool-bar-mode -1)
  (scroll-bar-mode -1)
  (transient-mark-mode 1)
  (move-to-left-margin 0 1)
  (auto-fill-mode)
  (setq text-mode-hook 'darkroom-mode))

(defun darkroom-mode-reset ()
  (interactive)
  (switch-full-screen -1)
  ;;(color-theme-subtle-hacker) ;; Choose your favorite theme
  (menu-bar-mode 1)
  (tool-bar-mode 1)
  (scroll-bar-mode 1)
  (auto-fill-mode 0)
  (setq left-margin 0))

(defun write-room ()
  "Make a frame without any bling."
  (interactive)
  ;; to restore:
  ;; (setq mode-line-format (default-value 'mode-line-format))
  (let ((frame (make-frame '((minibuffer . nil)
                             (vertical-scroll-bars . nil)
                             (left-fringe . 0); no fringe
                             (right-fringe . 0)
                             (background-mode . dark)
                             (background-color . "black")
                             (foreground-color . "green")
                             (cursor-color . "green")
                             (border-width . 0)
                             (border-color . "black"); should be unnecessary
                             (internal-border-width . 64); whitespace!
                             (cursor-type . box)
                             (menu-bar-lines . 0)
                             (tool-bar-lines . 0)
                                        ;                            (mode-line-format . nil) ; dream on... has no effect
                             (fullscreen . fullboth)  ; this should work
                             (unsplittable . t)))))
    (select-frame frame)
    (find-file "~/emacs.d/NOTES")
    (setq mode-line-format nil); is buffer local unfortunately
    ;; maximize window if fullscreen above had no effect
    (when (fboundp 'w32-send-sys-command)
      (w32-send-sys-command 61488 frame))))

(defun run-theater (command)
  "Open an Emacs frame with nothing other than the executed command."
  (interactive "Enter command: ")
  (select-frame (new-frame '((width . 72) (height . 20)
                             (menu-bar-lines . 0)
                             (minibuffer . nil)
                             (toolbar . nil))))
  (setq-default mode-line-format nil)
  (call-interactively command))

(defun insert-date ()
  "Insert a time-stamp according to locale's date and time format."
  (interactive)
  (insert (format-time-string "%Y%m%d" (current-time))))

(defun senny-grep-project (pattern)
  (interactive (list (read-string "Pattern: "
                                  (if (symbol-at-point)
                                      (symbol-name (symbol-at-point))""))))
  (rgrep pattern "*" (textmate-project-root)))

(defun view-url ()
  "Open a new buffer containing the contents of URL."
  (interactive)
  (let* ((default (thing-at-point-url-at-point))
         (url (read-from-minibuffer "URL: " default)))
    (switch-to-buffer (url-retrieve-synchronously url))
    (rename-buffer url t)
    ;; TODO: switch to nxml/nxhtml mode
    (cond ((search-forward "<?xml" nil t) (xml-mode))
          ((search-forward "<html" nil t) (html-mode)))))


(defun ido-goto-symbol (&optional symbol-list)
  ;;http://www.emacswiki.org/cgi-bin/wiki/ImenuMode#toc10
  "Refresh imenu and jump to a place in the buffer using Ido."
  (interactive)
  (unless (featurep 'imenu)
    (require 'imenu nil t))
  (cond
   ((not symbol-list)
    (let ((ido-mode ido-mode)
          (ido-enable-flex-matching
           (if (boundp 'ido-enable-flex-matching)
               ido-enable-flex-matching t))
          name-and-pos symbol-names position)
      (unless ido-mode
        (ido-mode 1)
        (setq ido-enable-flex-matching t))
      (while (progn
               (imenu--cleanup)
               (setq imenu--index-alist nil)
               (ido-goto-symbol (imenu--make-index-alist))
               (setq selected-symbol
                     (ido-completing-read "Symbol? " symbol-names))
               (string= (car imenu--rescan-item) selected-symbol)))
      (unless (and (boundp 'mark-active) mark-active)
        (push-mark nil t nil))
      (setq position (cdr (assoc selected-symbol name-and-pos)))
      (cond
       ((overlayp position)
        (goto-char (overlay-start position)))
       (t
        (goto-char position)))))
   ((listp symbol-list)
    (dolist (symbol symbol-list)
      (let (name position)
        (cond
         ((and (listp symbol) (imenu--subalist-p symbol))
          (ido-goto-symbol symbol))
         ((listp symbol)
          (setq name (car symbol))
          (setq position (cdr symbol)))
         ((stringp symbol)
          (setq name symbol)
          (setq position
                (get-text-property 1 'org-imenu-marker symbol))))
        (unless (or (null position) (null name)
                    (string= (car imenu--rescan-item) name))
          (add-to-list 'symbol-names name)
          (add-to-list 'name-and-pos (cons name position))))))))

;Move current line to top
(defun line-to-top ()
  "Move current line to top of window."
  (interactive)
  (recenter 0))

;Move point to top
(defun point-to-top ()
  (interactive)
  (move-to-window-line 0))

;Move point to bottom
(defun point-to-bottom ()
  "Move current line to top of window."
  (interactive)
  (move-to-window-line -1))

;from http://sinewalker.wordpress.com/2008/06/26/pretty-printing-xml-with-emacs-nxml-mode/
(defun bf-pretty-print-xml-region (begin end)
  "Pretty format XML markup in region. You need to have nxml-mode
http://www.emacswiki.org/cgi-bin/wiki/NxmlMode installed to do
this.  The function inserts linebreaks to separate tags that have
nothing but whitespace between them.  It then indents the markup
by using nxml's indentation rules."
  (interactive "r")
  (save-excursion
      (nxml-mode)
      (goto-char begin)
      (while (search-forward-regexp "\>[ \\t]*\<" nil t)
        (backward-char) (insert "\n"))
      (indent-region begin end))
    (message "Ah, much better!"))

;;------------------------------------------------
;;==Plugins
;;------------------------------------------------
;;TODO write notes on the format of featurep, progn, etc

;;=yasnippet
;; (if (featurep 'yasnippet)
;;     (progn
;;       (yas/initialize)
;;       (yas/load-directory "~/.emacs.d/yasnippets"))
;;   (message "INSTALL yasnippet"))


;;=dired & Tramp
;; (require 'dired-history)
(setq tramp-default-method "ssh")
(setq dired-omit-files (concat dired-omit-files "\\|^\\..+$"))
(setq tramp-auto-save-directory "~/.emacs.d/tramp-autosave")
(add-hook 'dired-mode-hook
          (lambda ()
            ;; (define-key dired-mode-map (kbd "o") 'dired-display-file)
            (define-key dired-mode-map (kbd "M-l") 'nil)))

;;=org-mode
(defun planner ()
  (interactive)
  (find-file "~/Dropbox/doc/planner.org")
  )
(defun journal()
  (interactive)
  (find-file "~/Dropbox/doc/journal/journal.org")
  )
(setq org-habit-graph-column 60)
(setq org-agenda-include-diary nil)
(setq org-deadline-warning-days 14)
(setq org-timeline-show-empty-dates t)
(setq org-insert-mode-line-in-empty-file t)
(setq org-clock-into-drawer t)
(setq org-show-notifications t)
(setq org-timer-default-timer 25)
(setq org-agenda-files (quote ("~/Dropbox/doc/planner.org")))
(setq org-agenda-ndays 7)
(setq org-agenda-restore-windows-after-quit t)
(setq org-agenda-show-all-dates t)
(setq org-agenda-skip-deadline-if-done t)
(setq org-agenda-skip-scheduled-if-done t)
(setq org-agenda-sorting-strategy (quote ((agenda time-up priority-down tag-up) (todo tag-up))))
(setq org-agenda-start-on-weekday nil)
(setq org-agenda-todo-ignore-deadlinens t)
(setq org-agenda-todo-ignore-scheduled t)
(setq org-agenda-todo-ignore-with-date t)
(setq org-deadline-warning-days 14)
(setq org-export-html-style "<link rel=\"stylesheet\" type=\"text/css\" href=\"mystyles.css\">")
(setq org-fast-tag-selection-single-key nil)
                                        ;(setq org-log-done (quote (done)))
(setq org-reverse-note-order t)
(setq org-tags-column -78)
(setq org-tags-match-list-sublevels nil)
;; (setq org-time-stamp-rounding-minutes 5)
(setq org-use-fast-todo-selection t)
(setq org-use-tag-inheritance nil)
(setq org-fontify-done-headline t) ;;newly added
;; Show all future entries for repeating tasks
(setq org-agenda-repeating-timestamp-show-all t)
;; Resume clocking tasks when emacs is restarted
(setq org-clock-persistence-insinuate)
;; Yes it's long... but more is better ;)
(setq org-clock-history-length 35)
;; Resume clocking task on clock-in if the clock is open
(setq org-clock-in-resume t)
;; Change task state to STARTED when clocking in
;; (setq org-clock-in-switch-to-state "STARTED")

;; Save the running clock and all clock history when exiting Emacs, load it on startup
(setq org-clock-persistence-insinuate t)
(setq org-clock-persist t)
(setq org-clock-in-resume t)

;; Save clock data and notes in the LOGBOOK drawer
(setq org-clock-into-drawer t)
;; Sometimes I change tasks I'm clocking quickly - this removes
;; clocked tasks with 0:00 duration
(setq org-clock-out-remove-zero-time-clocks t)
;; Separate drawers for clocking and logs
(setq org-drawers (quote ("PROPERTIES" "LOGBOOK" "CLOCK")))
;; Save clock data in the CLOCK drawer and state changes and notes in the LOGBOOK drawer
(setq org-clock-into-drawer "CLOCK")
(setq org-log-into-drawer t)

;; Custom keywords
;; (setq org-todo-keyword-faces
;;       '(("TODO"  . (:foreground "red" :weight bold))
;;         ("STARTED" :foreground "blue" :weight bold)
;;         ("GOAL"  . (:foreground "purple" :weight bold))
;;         ("WAITING"  . (:foreground "orange" :weight bold))
;;         ("DELEGATED"  . (:foreground "orange" :weight bold))
;;         ("SOMEDAY"  . (:foreground "orange" :weight bold))
;;         ("ONGOING"  . (:foreground "orange" :weight bold))
;;         ("DONE"  . (:foreground "forest green" :weight bold))
;;         ("DISMISSED"  . (:foreground "forest green" :weight bold))
;;         ("CANCELLED"  . (:foreground "forest green" :weight bold))
;;         ))
(setq org-agenda-custom-commands
      '(;; ("P" "Projects"
        ;; ((tags "PROJECT")))
        ("H" "Office and Home Lists"
         ((agenda)
          (tags-todo "OFFICE")
          (tags-todo "HOME")
          (tags-todo "COMPUTER")
          (tags-todo "DVD")
          (tags-todo "READING")))
        ("d" "Daily Action List"
         ((agenda "" ((org-agenda-ndays 1)
                      (org-agenda-sorting-strategy
                       (quote ((agenda time-up priority-down tag-up) )))
                      ;;  (org-deadline-warning-days 0)
                      ))))

        ;; ("c" todo "DONE|DEFERRED|CANCELLED" nil)

        ;; ("w" todo "WAITING" nil)
        ("o" todo "ONGOING" nil)

        ("A" agenda ""
         ((org-agenda-skip-function
           (lambda nil
             (org-agenda-skip-entry-if (quote notregexp) "\\=.*\\[#A\\]")))
          (org-agenda-ndays 1)
          (org-agenda-overriding-header "Today's Priority #A tasks: ")))

        ("P" "Projects" tags "/!PROJECT" ((org-use-tag-inheritance nil)))
        ("s" "Started Tasks" todo "STARTED" ((org-agenda-todo-ignore-with-date nil)))
        ("Q" "Questions" tags "QUESTION" nil)
        ("w" "Tasks waiting on something" tags "WAITING" ((org-use-tag-inheritance nil)))
        ("r" "Refile New Notes and Tasks" tags "REFILE" ((org-agenda-todo-ignore-with-date nil)))
        ("n" "Notes" tags "NOTES" nil)
        ("c" "Schedule" agenda ""
         ((org-agenda-ndays 7)
          (org-agenda-start-on-weekday 1)
          (org-agenda-time-grid nil)
          (org-agenda-prefix-format " %12:t ")
          (org-agenda-include-all-todo nil)
          (org-agenda-repeating-timekstamp-show-all t)
          (org-agenda-skip-function '(org-agenda-skip-entry-if 'deadline 'scheduled))))
        ("u" "Upcoming deadlines (6 months)" agenda ""
         ((org-agenda-skip-function '(org-agenda-skip-entry-if 'notdeadline))
          (org-agenda-ndays 1)
          (org-agenda-include-all-todo nil)
          (org-deadline-warning-days 180)
          (org-agenda-time-grid nil)))
        ))

;;=capture
(setq org-capture-templates
      '(("t" "Todo" entry (file+headline "~/Dropbox/doc/planner.org" "Tasks")
                                        ;             "* TODO %?\n----Entered on %U\n  %i")
         "* TODO %?  %i")
        ("j" "Journal" entry (file+datetree "~/Dropbox/doc/journal/journal.org")
         "** %?")
        ("p" "Pic-of-the-day" entry (file+datetree "~/Dropbox/doc/journal/journal.org")
         "* [[~/Dropbox/doc/journal/%?.jpg]]")
        ("l" "Log Time" entry (file+datetree "~/Dropbox/doc/timelog.org" )
         "** %U - %^{Activity}  :TIME:")
        ("r" "Tracker" entry (file+datetree "~/Dropbox/doc/journal/journal.org")
         "* Tracker \n| Item | Count |
              %?|-+-|
              | Pull 20||
              | Push 20||
              | Crunch 16/15/1m||
              | Back 10||
              |-|
              | Anki||
              | Climbed||
              | Ran||
         |Biked to work ||";;\n#+BEGIN: clocktable :maxlevel 5 :scope agenda :block today\n#+END:"
         )
        ("w" "" entry ;; 'w' for 'org-protocol'
         (file+headline "~/Dropbox/doc/www.org" "Notes`")
         "* %^{Title}\n\n  Source: %u, %c\n\n  %i")
        ("m" "movie" entry (file+headline "~/Dropbox/doc/media.org" "Movies")
         "* %? \n----Entered on %U\n  %i")
        ("b" "book" entry (file+headline "~/Dropbox/doc/media.org" "Books")
         "* %? \n----Entered on %U\n  %i")
        ("P" "pomodoro" entry (file+headline "~/Dropbox/doc/planner.org" "Tasks")
         "* | %? |  | [] | %i")
        ))

;;*****CALENDAR/DIARY MODE*****
(setq view-diary-entries-initially t
      mark-diary-entries-in-calendar t
      number-of-diary-entries 7)
(add-hook 'diary-display-hook 'fancy-diary-display)
(add-hook 'today-visible-calendar-hook 'calendar-mark-today)

;;=erc
;; check channels
;; (set-face-foreground 'erc-pal-face "#8cd0d3")
(erc-track-mode t)
(erc-autojoin-mode t)

;; Only track my nick(s)
(defadvice erc-track-find-face (around erc-track-find-face-promote-query activate)
  (if (erc-query-buffer-p)
      (setq ad-return-value (intern "erc-current-nick-face"))
    ad-do-it))

;; Use libnotify
(defun clean-message (s)
  (setq s (replace-regexp-in-string "'" "&apos;"
                                    (replace-regexp-in-string "\"" "&quot;"
                                                              (replace-regexp-in-string "&" "&"
                                                                                        (replace-regexp-in-string "<" "&lt;"
                                                                                                                  (replace-regexp-in-string ">" "&gt;" s)))))))

(defun call-libnotify (matched-type nick msg)
  (let* ((cmsg  (split-string (clean-message msg)))
         (nick   (first (split-string nick "!")))
         (msg    (mapconcat 'identity (rest cmsg) " ")))
    (shell-command-to-string
     (format "notify-send -u critical '%s says:' '%s'" nick msg))))

(defvar growlnotify-command (executable-find "growlnotify") "The path to growlnotify")

(defun growl (title message)
  "Shows a message through the growl notification system using
 `growlnotify-command` as the program."
  (flet ((encfn (s) (encode-coding-string s (keyboard-coding-system))) )
    (let* ((process (start-process "growlnotify" nil
                                   growlnotify-command
                                   (encfn title)
                                   "-a" "Emacs"
                                   "-n" "Emacs")))
      (process-send-string process (encfn message))
      (process-send-string process "\n")
      (process-send-eof process))) t)

(defun my-erc-hook (match-type nick message)
  "Shows a growl notification, when user's nick was mentioned. If the buffer is currently not visible, makes it sticky."
  (unless (posix-string-match "^\\** *Users on #" message)
    (growl
     (concat "ERC: name mentioned on: " (buffer-name (current-buffer)))
     message
     )))

;; (add-hook 'erc-text-matched-hook 'my-erc-hook)
;; (add-hook 'erc-text-matched-hook 'call-libnotify)

(setq erc-server "irc.freenode.net"
      erc-port 6667
      ;;       erc-user-full-name                 "Edward O'Connor"
      ;;       erc-email-userid                   "ted"
      erc-nick '("kylpo" "kp")
      ;;       erc-password                       nil ; set this in local config
      ;;       erc-nickserv-passwords             nil ; set this in local config
      ;;       erc-anonymous-login                t
      ;;       erc-auto-query                     'bury
      ;;       erc-join-buffer                    'bury
      erc-max-buffer-size                30000
      ;;       erc-prompt-for-password            nil
      ;;       erc-join-buffer                    'buffer
      ;;       erc-command-indicator              "CMD"
      ;;       erc-echo-notices-in-current-buffer t
      ;;       erc-send-whitespace-lines          nil
      erc-prompt ">"
      erc-hide-list '("JOIN" "PART" "QUIT" "NICK")
      erc-keywords '(" ruby " " rails " " erc " " tmux " " screen ")
      erc-pals '("technomancy")
      erc-track-exclude-types '("JOIN" "NICK" "PART" "QUIT" "MODE" "324" "329" "332" "333" "353" "477")
      ;; joining && autojoing
      ;; make sure to use wildcards for e.g. freenode as the actual server
      ;; name can be be a bit different, which would screw up autoconnect
      erc-autojoin-channels-alist '((".*\\.freenode.net" "#lubuntu" "#scala" "#clojure" "#emacs"))

      ;; (".*\\.gimp.org" "#gimp" "#gimp-users")))
      ;;       erc-ignore-list                    '("jibot")
      )

(setq ibuffer-saved-filter-groups
      (quote (("default"
               ("Ruby" (mode . ruby-mode))
               ("Org" ;; all org-related buffers
                (mode . org-mode))
               ("Mail"
                (or  ;; mail-related buffers
                 (mode . mew-message-mode)
                 (mode . mew-summary-mode)
                 (mode . mew-draft-mode)
                 ))
               ("Programming" ;; prog stuff
                (or
                 (mode . c-mode)
                 (mode . perl-mode)
                 (mode . python-mode)
                 (mode . emacs-lisp-mode)
                 (mode . clojure-mode)
                 ))
               ("ERC"   (mode . erc-mode))
               ("Jabber"
                (or
                 (mode . jabber-chat-mode)
                 (mode . jabber-roster-mode)))))))

(add-hook 'ibuffer-mode-hook
          (lambda ()
            (ibuffer-switch-to-saved-filter-groups "default")))

;;=elscreen
(if (featurep 'elscreen)
    (progn
      (setq elscreen-display-screen-number nil)
      ;; (setq elscreen-display-tab nil)
      ;; (setq elscreen-tab-display-control nil)
      (global-set-key (kbd "s-p") 'elscreen-previous)
      (global-set-key (kbd "s-n") 'elscreen-next)
     (global-set-key (kbd "C-S-<tab>") 'elscreen-previous)
     (global-set-key (kbd "C-<tab>") 'elscreen-next)
      (global-set-key (kbd "s-t") 'elscreen-clone))
  (message "INSTALL elscreen"))

(if (featurep 'ZZZZZZ)
    (message "ZZZZ true")
  (message"ZZZZ False"))


;;=gnus
;;tab complete recipients
;; (add-hook 'message-mode-hook
;;           (function (lambda()
;;                       (local-set-key (kbd "<tab>") 'bbdb-complete-name)
;;                       )))

;; auto-create bbdb contact
;; (setq bbdb/news-auto-create-p t)

;; (setq user-mail-address "2kylepoole@gmail.com")

;; (setq user-full-name "Kyle Poole")
;; ;; (setq gnus-select-method '(nnimap "gmail"))
;; ;; (setq gnus-select-method '(nnml ""))

;; ;; (setq gnus-secondary-select-methods
;; ;;       '((nnimap "gmail"
;; ;;                 (nnimap-address "imap.gmail.com")
;; ;;                 (nnimap-server-port 993)
;; ;;                 (nnimap-stream ssl)
;; ;;                 ;; (nnimap-autheticator login)
;; ;;                 )))

;; ;; (add-to-list 'gnus-secondary-select-methods '(nnimap "gmail"
;; ;;                                  (nnimap-address "imap.gmail.com")
;; ;;                                  (nnimap-server-port 993)
;; ;;                                  (nnimap-stream ssl)))

;; (setq gnus-select-method '(nnimap "gmail"
;;                                   (nnimap-address "imap.gmail.com")
;;                                   (nnimap-server-port 993)
;;                                   (nnimap-stream ssl)))

;; ;; (setq gnus-summary-line-format "%U%R%z%B%(%[%5L: %-23,23f%]%) %s\n")
;; (setq gnus-summary-line-format "%U%R│%B%(%s%80=%) │ %f %110=│ %6&user-date;\n")
;; (setq gnus-summary-make-false-root 'dummy
;;       gnus-sum-thread-tree-false-root      "┈─► "
;;       gnus-sum-thread-tree-single-indent   "●  "
;;       gnus-sum-thread-tree-root            "●  "
;;       gnus-sum-thread-tree-vertical        "│"
;;       gnus-sum-thread-tree-leaf-with-other "├─► "
;;       gnus-sum-thread-tree-single-leaf     "╰─► "
;;       gnus-sum-thread-tree-indent          " ")
;; (setq mm-discouraged-alternatives '("text/html" "text/richtext"))
;; (setq mm-text-html-renderer 'w3m)

;; (setq message-send-mail-function 'smtpmail-send-it
;;       smtpmail-starttls-credentials '(("smtp.gmail.com" 587 nil nil))
;;       smtpmail-auth-credentials '(("smtp.gmail.com" 587 "2kylepoole@gmail.com" nil))
;;       smtpmail-default-smtp-server "smtp.gmail.com"
;;       smtpmail-smtp-server "smtp.gmail.com"
;;       smtpmail-smtp-service 587
;;       smtpmail-local-domain "yourcompany.com")

;;------------------------------------------------
;; == GLOBAL KEYBINDS
;;------------------------------------------------

;;-----------------------------------------------------------------------------
;; F2: files
;;-----------------------------------------------------------------------------
(defmacro set-key-find-file (key file)
  "Defines a shortcut key to open a file."
  (let ((fname (intern (concat "open-" file))))
    `(progn (defun ,fname () (interactive) (find-file ,file))
            (global-set-key (kbd ,key) ',fname))))

(set-key-find-file "<f2> e" "~/.emacs.d/init.el")
(set-key-find-file "<f2> g" "~/.gnus.el")
(set-key-find-file "<f2> t" "~/org/todo.org")
(set-key-find-file "<f2> n" "~/org/notes.org")
(set-key-find-file "<f2> f" "~/org/feeds.org")
(set-key-find-file "<f2> z" "~/.zshrc")
(set-key-find-file "<f2> b" "~/.xbindkeysrc")
(set-key-find-file "<f2> r" "~/.Xresources")
(set-key-find-file "<f2> m" "~/.Xmodmap")
(set-key-find-file "<f2> h" "~/Dropbox/notes/emacs/hotkeys.org")

(global-set-key (kbd "<f2> w") 'webjump)

;;-----------------------------------------------------------------------------
;; F5: Org functions
;;-----------------------------------------------------------------------------
(bind "<f5> a" org-toggle-archive-tag)
(bind "<f5> b" org-ido-switchb)
(bind "<f5> i" org-clock-in)
(bind "<f5> o" org-clock-out)
(bind "<f5> r" org-refile)
(bind "<f5> f" org-occur)
                                        ;(bind "<f5> r" org-remember)
(bind "<f5> v" org-archive-subtree)
(bind "<f5> t" my-org-todo)
(bind "<f5> w" widen)
(bind "<f5> u" org-feed-update-all)
;;-----------------------------------------------------------------------------
;; F6: Emacs functions
;;-----------------------------------------------------------------------------
(bind "<f6> t" 'visit-tags-table)
(bind "<f6> h" 'jao-toggle-selective-display)
(bind "<f6> h" 'hs-org/minor-mode)
;; (bind "<f6> d" 'color-theme-wombat)
(bind "<f6> l" 'color-theme-active)
(bind "<f6> n" 'linum-mode)

;;-----------------------------------------------------------------------------
;; F9: Emacs programs
;;-----------------------------------------------------------------------------
;; (bind "<f9> e" eshell)
;; (bind "<f9> f" rgrep)
;; (bind "<f9> h" (lambda () (interactive) (dired "~")))
;; (bind "<f9> c" calendar)
;; (bind "<f9> r" org-remember)
;; (bind "<f9> g" gnus)
;; (bind "<f9> M-g" gnus-unplugged)


;;-----------------------------------------------------------------------------
;; F12: Agenda
;;-----------------------------------------------------------------------------
(bind "<f12>" org-agenda)
(bind "C-<f12>" org-clock-goto)

;;---------------------------------------------------------
;; Random bindings
;;---------------------------------------------------------
;; (global-set-key (kbd "C-c p") 'planner)
(global-set-key (kbd "C-c j") 'journal)
(global-set-key (kbd "C-c h") 'hotkeys)
(global-set-key [f7] 'ansi-term)
;; (global-set-key [f8] 'org-agenda-clock-cancel)
(global-set-key [f9] 'org-agenda-clock-in)
(global-set-key [f10] 'org-agenda-clock-out)
(global-set-key [f11] 'switch-full-screen-toggle)
(global-set-key [f12]         'org-capture)
(global-set-key (kbd "C-c e") 'djcb-erc-start-or-switch) ;; switch to ERC
(global-set-key "\C-x\C-k" 'kill-region)
(global-set-key "\C-c\C-k" 'kill-region)
(global-set-key (kbd "M-L") 'next-buffer)
(global-set-key (kbd "M-H") 'previous-buffer)
(global-set-key (kbd "M-/") 'hippie-expand)
(global-set-key "\r" 'newline-and-indent)
;; (global-set-key [return] 'newline-and-indent)
                                        ;(global-set-key (kbd "C-M-p") 'enlarge-window-horizontally)
                                        ;(global-set-key (kbd "C-M-o") 'shrink-window-horizontally)
(global-set-key "\C-xj" 'join-line)

;; Jump to a definition in the current file.
(global-set-key (kbd "C-x C-i") 'ido-goto-symbol)

;; Perform general cleanup.
(global-set-key (kbd "C-c n") 'esk-cleanup-buffer)

(global-set-key "\C-x," 'my-ido-find-tag)
(global-set-key "\C-xc" 'calendar)
(global-set-key "\C-xt" 'eshell)
;; (global-set-key "\C-x\C-f" 'lusty-file-explorer)
                                        ;(global-set-key "\C-xs" 'flyspell-mode)
(global-set-key "\C-xs" 'sunrise)
(global-set-key "\C-xS" 'sunrise-cd)
                                        ;(global-set-key "\C-xc" 'search)
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-x\C-b" 'ibuffer)
(global-set-key (kbd "C-x O") 'previous-multiframe-window) ;back a window

(global-set-key (kbd "C-c y") 'bury-buffer)
(global-set-key (kbd "C-c r") 'revert-buffer)

(bind "C-x M-f" 'find-file-other-window)
(global-set-key "\M-?" 'comment-or-uncomment-current-line-or-region)

;; Movements
(bind "C-M-S" isearch-other-window)
(bind "C-S-p" scroll-down-keep-cursor)
(bind "C-S-n" scroll-up-keep-cursor)
;; todo
(global-set-key (kbd "s-e") 'point-to-top)
(global-set-key (kbd "s-d") 'move-to-window-line)
(global-set-key (kbd "s-c") 'point-to-bottom)
;; H 'move-to-window-line-top-bottom 1
;; L 'move-to-window-line-top-bottom -1

;; (setq mouse-autoselect-window t) ;;focus follows mouse

;; Window/Desktop Navigation/Manipulation
(bind "C-^" 'enlarge-window)
(bind "C-<" 'shrink-window-horizontally)
(bind "C->" 'enlarge-window-horizontally)
(global-set-key (kbd "M-j") 'windmove-down)
(global-set-key (kbd "M-k") 'windmove-up)
(global-set-key (kbd "M-h") 'windmove-left)
(global-set-key (kbd "M-l") 'windmove-right)
(global-set-key (kbd "M-0") 'delete-window)
(global-set-key (kbd "M-1") 'delete-other-windows)
(global-set-key (kbd "M-2") 'split-window-vertically)
(global-set-key (kbd "M-3") 'split-window-horizontally)
(global-set-key (kbd "M-4") 'balance-windows)
(global-set-key (kbd "C-x SPC s") 'my-desktop-save)
(global-set-key (kbd "C-x SPC r") 'my-desktop-read)
;; (global-set-key (kbd "C-, r") 'my-desktop-read)
;; (global-set-key (kbd "C-, s") 'my-desktop-save)
;; (global-set-key (kbd "s-p") 'wg-switch-left)
;; (global-set-key (kbd "s-n") 'wg-switch-right)
;; (global-set-key (kbd "s-t") 'wg-create-workgroup)


(define-key isearch-mode-map (kbd "C-o") 'isearch-occur) ;occur in isearch
(global-set-key [S-return]   'open-next-line)
(global-set-key [C-S-return] 'open-previous-line)

(global-set-key [next] 'sfp-page-down)
(global-set-key [prior] 'sfp-page-up)
(global-set-key (kbd "M-V") 'kylpo-page-up-half)
(global-set-key (kbd "C-S-v") 'kylpo-page-down-half)
(global-set-key (kbd "C-v") 'sfp-page-down)
(global-set-key (kbd "M-v") 'sfp-page-up)

(global-set-key (kbd "M-d") 'tinyeat-forward)
;; (global-set-key "\C-w" 'backward-kill-word)
(global-set-key (kbd "M-Z") 'kylpo-zap-back-to-char)

(global-set-key (kbd "s--") 'text-scale-decrease)
(global-set-key (kbd "s-=") 'text-scale-increase)

;; (global-set-key (kbd "s-n") 'wg-switch-left)
;; (global-set-key (kbd "s-p") 'wg-switch-left)
(global-set-key (kbd "M-#") 'isearch-forward-at-point)
;;TODO (global-set-key (kbd "C-j") 'join-line)
;; (global-set-key (kbd "C-o") 'open-next-line)
;; (global-set-key (kbd "M-o") 'open-previous-line)

;; http://tsengf.blogspot.com/2011/06/scroll-up-and-down-line-by-line-in.html
(defun scroll-up-one-line()
  (interactive)
  (scroll-up 1))

(defun scroll-down-one-line()
  (interactive)
  (scroll-down 1))

;;TODO
;; (global-set-key [?\C-i] 'scroll-down-one-line)
;; (global-set-key [?\C-o] 'scroll-up-one-line)

;; (global-unset-key (kbd "<C-tab>"))
(global-unset-key (kbd "<M-tab>"))
(global-unset-key (kbd "<M-h>"))
;; (global-set-key (kbd "C-.") 'dot-mode-execute)
(global-set-key [?\C-h] 'delete-backward-char)
(global-set-key [?\C-x ?h] 'help-command) ; overrides mark-whole-buffer
;; (global-unset-key (kbd "<C-o>"))
;; (global-set-key (kbd "<C-o>") 'auto-complete)
(global-set-key (kbd "M-n") 'auto-complete)

;; Start eshell or switch to it if it's active.
(global-set-key (kbd "C-x m") 'eshell)

;; Start a new eshell even if one is active.
(global-set-key (kbd "C-x M") (lambda () (interactive) (eshell t)))

;; Start a regular shell if you prefer that.
(global-set-key (kbd "C-x C-m") 'shell)

(global-set-key (kbd "C-x g") 'magit-status)
(global-set-key (kbd "C-c f") 'find-file-in-project)

;;; start search at top of buffer
(bind "C-S-s" (lambda () (interactive) (beginning-of-buffer) (isearch-forward)))

(global-set-key (kbd "s-+") 'text-scale-increase)
(global-set-key (kbd "C-j") 'ace-jump-mode)
(global-set-key (kbd "C-M-j") 'ace-jump-char-mode)
(global-set-key (kbd "M-;") 'ace-jump-mode)



    ;; Behave like vi's o command
    (defun open-next-line (arg)
      "Move to the next line and then opens a line.
    See also `newline-and-indent'."
      (interactive "p")
      (end-of-line)
      (open-line arg)
      (next-line 1)
      (when newline-and-indent
        (indent-according-to-mode)))
    (global-set-key (kbd "C-o") 'open-next-line)
    ;; Behave like vi's O command
    (defun open-previous-line (arg)
      "Open a new line before the current one.
     See also `newline-and-indent'."
      (interactive "p")
      (beginning-of-line)
      (open-line arg)
      (when newline-and-indent
        (indent-according-to-mode)))
    (global-set-key (kbd "M-o") 'open-previous-line)

    ;; ;; Autoindent open-*-lines
    ;; (defvar newline-and-indent t
    ;;   "Modify the behavior of the open-*-line functions to cause them to autoindent.")

;; kill region if active, otherwise kill backward word
(defun kill-region-or-backward-word ()
  (interactive)
  (if (region-active-p)
      (kill-region (region-beginning) (region-end))
    (backward-kill-word 1)))
(global-set-key (kbd "C-w") 'kill-region-or-backward-word)










(defun copy-from-osx ()
  (shell-command-to-string "pbpaste"))

(defun paste-to-osx (text &optional push)
  (let ((process-connection-type nil))
      (let ((proc (start-process "pbcopy" "*Messages*" "pbcopy")))
        (process-send-string proc text)
        (process-send-eof proc))))

(setq interprogram-cut-function 'paste-to-osx)
(setq interprogram-paste-function 'copy-from-osx)
