;;Done at start to load faster
(cond
 ((string-match "linux" system-configuration)
 (if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
  );;end windows
 ((string-match "apple" system-configuration)
  ;; (if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
  ))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))

(server-start)

(setq frame-title-format '("Emacs @ " system-name ": %b %+%+ %f")) ;set window title to full file name


;;http://www.hollenback.net/index.php/EmacsModeLine
;;http://www.gnu.org/software/emacs/elisp/html_node/Mode-Line-Variables.html#Mode-Line-Variables
(setq-default mode-line-format
              (list "-"
                    'mode-line-mule-info
                    'mode-line-modified
                    'mode-line-frame-identification
                    'mode-line-buffer-identification
                    ;; "%b  "
                    '(getenv "HOST")
                    ;; ":"
                    ;; 'default-directory
                    ;; "   "
                    'mode-line-position
                    '(vc-mode vc-mode)
                    "   "
                    'mode-line-modes
                    '(which-func-mode ("" which-func-format "--"))
                    '(global-mode-string ("--" global-mode-string))
                    "-%-")
              )

(push "/usr/local/bin" exec-path) ;needed for the mac, doesn't break/hurt linux
(push "~/.rvm/bin/rvm-prompt" exec-path)

;;------------------------------------------------
;;== LOAD PATH, AUTOLOADS, REQUIRES AND FILE ASSOCIATIONS
;;------------------------------------------------
(setq dotfiles-dir (file-name-directory (or (buffer-file-name) load-file-name)))
;;*****ELPA****
;;early in .emacs to be able to use plugins later down
 (when
     (load
      (expand-file-name "~/.emacs.d/elpa/package.el"))
   (package-initialize))

 (setq package-archives
       '(("original" . "http://tromey.com/elpa/")
         ("gnu" . "http://elpa.gnu.org/packages/")
         ("marmalade" . "http://marmalade-repo.org/packages/")
;;         ;; ("sunrise-commander" . "http://joseito.republika.pl/sunrise-commander/")
         ))

(require 'cl)				; common lisp goodies, loop

(add-to-list 'load-path "~/.emacs.d/el-get/el-get")

(unless (require 'el-get nil t)
:  (url-retrieve
   "https://github.com/dimitri/el-get/raw/master/el-get-install.el"
   (lambda (s)
     (end-of-buffer)
     (eval-print-last-sexp))))

;;=el-get
;; set local recipes
(setq
el-get-sources
 '(
   (:name goto-last-change		; move pointer back to last change
          :after (lambda ()
        	   ;; when using AZERTY keyboard, consider C-x C-_
        	   (global-set-key (kbd "C-x C-/") 'goto-last-change)))
   (:name multi-term
          :after (lambda ()
                   (multi-term-keystroke-setup)
                   (setq multi-term-program "/bin/bash")))
   (:name workgroups
          :after (lambda ()
                   ;; (setq wg-prefix-key (kbd "C-c w"))
                   ;; (setq workgroups-default-file "~/.emacs.d/workgroups/default")
                   (workgroups-mode t)
                   ;; (wg-switch-on-load nil)
                   (wg-toggle-mode-line)
;                   (wg-load "~/.emacs.d/workgroups/default")
                   (global-set-key (kbd "C-z C-z") 'wg-switch-to-previous-workgroup)
                   ))
   (:name auto-complete
          ;; :after (lambda ()
          ;;          (global-unset-key (kbd "<C-o>"))
          ;;          (global-set-key (kbd "<C-o>") 'auto-complete))
          )
   (:name buffer-move ; have to add your own keys
          :after (lambda ()
                   (global-set-key (kbd "<C-S-up>") 'buf-move-up)
                   (global-set-key (kbd "<C-S-down>") 'buf-move-down)
                   (global-set-key (kbd "<C-S-left>") 'buf-move-left)
                   (global-set-key (kbd "<C-S-right>") 'buf-move-right)))
  (:name dot-mode
         :type git
         :url "https://github.com/emacsmirror/dot-mode.git"
         :features dot-mode
         :after (lambda ()
                  (require 'dot-mode)
                  (add-hook 'find-file-hooks 'dot-mode-on)))
   (:name goto-last-change ; move pointer back to last change
          :after (lambda ()
                   ;; when using AZERTY keyboard, consider C-x C-_
                   (global-set-key (kbd "C-x C-/") 'goto-last-change)))
   (:name magit
          :after (lambda ()
                   (global-set-key (kbd "C-x g") 'magit-status)))
   (:name kylpo-smex
          :type git
          :url "http://github.com/nonsequitur/smex.git"
          :features smex
          :post-init (lambda ()
                       (setq smex-save-file "~/.emacs.d/.smex-items")
                       (smex-initialize))
          :after (lambda ()
                   (global-set-key (kbd "M-x") 'smex)
                   (global-set-key (kbd "M-X") 'smex-major-mode-commands)))
   (:name idle-highlight :type elpa)
   (:name kylpo-org-mode
          :type git
          :url "git://orgmode.org/org-mode.git"
	  :info "doc"
	  :build `,(mapcar
		    (lambda (target)
		      (concat "make " target " EMACS=" el-get-emacs))
		    '("clean" "all"))
	  :load-path ("lisp" "contrib/lisp")
	  :autoloads nil
	  :features org-install
	  :after
          (lambda ()
            (require 'org-habit)
            (add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))))
   (:name inf-ruby  :type elpa)
   (:name ruby-compilation :type elpa)
   (:name ruby-mode
          :type elpa
          :after
          (lambda ()
            (autoload 'ruby-mode "ruby-mode" nil t)
            (add-to-list 'auto-mode-alist '("\\.rake$" . ruby-mode))
            (add-to-list 'auto-mode-alist '("\\.gemspec$" . ruby-mode))
            (add-to-list 'auto-mode-alist '("\\.ru$" . ruby-mode))
            (add-to-list 'auto-mode-alist '("Rakefile$" . ruby-mode))
            (add-to-list 'auto-mode-alist '("Gemfile$" . ruby-mode))
            (add-to-list 'auto-mode-alist '("Capfile$" . ruby-mode))
            (add-to-list 'auto-mode-alist '("Vagrantfile$" . ruby-mode))
            (add-to-list 'auto-mode-alist '("\\.rb$" . ruby-mode))
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
                        ))))
   (:name css-mode
          :type elpa
          :after
          (lambda ()
            (autoload 'css-mode "css-mode" nil t)
            (add-hook 'css-mode-hook
                      '(lambda ()
                         (setq css-indent-level 2)
                         (setq css-indent-offset 2)))))
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
   ;; (:name framemove
   ;;        :type emacswiki
   ;;        ;;http://trey-jackson.blogspot.com/2010/02/emacs-tip-35-framemove.html
   ;;        :after (lambda ()
   ;;                 (require 'framemove)
   ;;                 (setq framemove-hook-into-windmove t)
   ;;                 ))
   (:name yaml-mode
          :type git
          :url "http://github.com/yoshiki/yaml-mode.git"
;          :features yaml-mode
          :after (lambda ()
                   (autoload 'yaml-mode "yaml-mode" nil t)
                   (add-to-list 'auto-mode-alist '("\\.ya?ml\\'" . yaml-mode))
                   (add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
                   (add-to-list 'auto-mode-alist '("\\.yaml$" . yaml-mode))))
  ;; (:name ack
  ;;        :after (lambda ()
  ;;                 (setq ack-command "ack ")))
   ;; (:name window-numbering
   ;;        :type http
   ;;        :url "http://nschum.de/src/emacs/window-numbering-mode/window-numbering.el"
   ;;        :features window-numbering
   ;;        :after (lambda ()
   ;;                 (window-numbering-mode 1)
                   ;; ;; (setq window-numbering-assign-func
                   ;;             ;; (lambda () (when (equal (buffer-name) "*Calculator*") 9)))
                   ;; ))
   (:name column-marker
          :type emacswiki
          :features column-marker
          :after (lambda ()
                   ;; (defun set-column-marker ()
                   ;;   (column-marker-1 80)
                   ;;   (column-marker-2 120))
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

                   ;; (add-hook 'c-mode-hook          'set-column-marker)
                   ;; (add-hook 'emacs-lisp-mode-hook 'set-column-marker)
                   ;; (add-hook 'html-mode-hook       'set-column-marker)))
   ;; (:name undo-tree
   ;;     :type http
   ;;     :url "http://www.dr-qubit.org/undo-tree/undo-tree.el"
   ;;     :features undo-tree)
   ))

(setq
 my:el-get-packages
 '(el-get				; el-get is self-hosting
   ;; ack
   emacs-goodies-el
   js2-mode
   rvm
   ;rspec-mode
   dired+ ;;http://www.emacswiki.org/emacs/DiredPlus#Dired%2b
;   php-mode-improved			; if you're into php...
   erc-highlight-nicknames
   sunrise-commander
;   sunrise-x-tree
;   sunrise-x-buttons
;   sunrise-x-tabs
;   scala-mode
   rainbow-mode ;color-highlight
;  ensime
   color-theme
   wrap-region
   yari
;   ruby-end ;necessary to place after ruby-mode
   flymake-ruby
   auto-complete			; complete as you type with overlays
   yasnippet
   zencoding-mode			; http://www.emacswiki.org/emacs/ZenCoding
   nav
   rinari
   rainbow-delimiters
   paredit
   ))

(setq my:el-get-packages
      (append
       my:el-get-packages
       (loop for src in el-get-sources collect (el-get-source-name src))))

;; install new packages and init already installed packages
(el-get 'sync my:el-get-packages)

(add-to-list 'load-path "~/.emacs.d/packages/emacs-tiny-tools/lisp/tiny")
(require 'tinyeat)
(require 'tramp)
(require 'redo+) ;;from elpa
(require 'uniquify)

(add-to-list 'auto-mode-alist '("\\.php$" . php-mode))
(add-to-list 'auto-mode-alist '("\\.inc$" . php-mode))
;; We never want to edit Rubinius bytecode
(add-to-list 'completion-ignored-extensions ".rbc")

;; Deal with colors in shell mode correctly
(autoload 'ansi-color-for-comint-mode-on "ansi-color" nil t)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

;;=color
(load "~/.emacs.d/colors/zenburn/zenburn.el")
(color-theme-zenburn)
(set-face-foreground 'erc-pal-face "#8cd0d3")
(setq term-default-bg-color "#3f3f3f")        ;; background color (black)
(setq term-default-fg-color "#dcdccc")       ;; foreground color (yellow)


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

;;highlight lines that pass 80 chars
;; (let ((whitespace-line-column 80)       ;80 is the default
;;       (whitespace-style '(lines-tail))) ;or '(lines) for the whole line
;;   (whitespace-mode 1))



;; This is a little hacky since VC doesn't support git add internally
(eval-after-load 'vc
  (define-key vc-prefix-map "i" '(lambda () (interactive)
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

;;=ido-mode
(setq ido-enable-prefix nil
      ido-case-fold  t ; be case-insensitive
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
      )
(ido-mode 'both) ; User ido mode for both buffers and files

;; when using ido, the confirmation is rather annoying...
(setq confirm-nonexistent-file-or-buffer nil)

;; Display ido results vertically, rather than horizontally
(setq ido-decorations (quote ("\n-> " "" "\n   " "\n   ..." "[" "]" " [No match]" " [Matched]" " [Not readable]" " [Too big]" " [Confirm]")))

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

(recentf-mode 1)
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



(font-lock-add-keywords nil '(("\\<\\(FIX\\|TODO\\|FIXME\\|HACK\\|REFACTOR\\) " 1 font-lock-warning-face t)))

(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(sr-show-file-attributes nil)
 '(wg-morph-on nil)
 '(wg-switch-on-load nil))

(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )

;;------------------------------------------------
;;== Custom Functions
;;------------------------------------------------

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

;; Autoindent open-*-lines
(defvar newline-and-indent t
  "Modify the behavior of the open-*-line functions to autoindent.")

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
                        fn
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

(cmd xsteve-ido-choose-from-recentf
     "Use ido to select a recently opened file from the `recentf-list'"
     (let ((home (expand-file-name (getenv "HOME"))))
       (find-file
        (ido-completing-read "Recentf open: "
                             (mapcar (lambda (path)
                                       (replace-regexp-in-string home "~" path))
                                     recentf-list)
                             nil t))))

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

(defun org-gcal-sync ()
  "Export org to ics to be uploaded to Google Calendar and import
an .ics file that has been downloaded from Google Calendar "
  (org-export-icalendar-combine-agenda-files)
  (icalendar-import-file "~/tmp/.basic.ics" "~/tmp/.gcal"))


(cmd indent-whole-buffer ()
     "indent whole buffer"
     (delete-trailing-whitespace)
     (indent-region (point-min) (point-max) nil)
     (untabify (point-min) (point-max)))
(defalias 'iwb 'indent-whole-buffer)

(defun add-watchwords ()
  (interactive)
  (font-lock-add-keywords
   nil '(("\\<\\(FIX\\|TODO\\|FIXME\\|HACK\\|REFACTOR\\):"
          1 font-lock-warning-face t))))

(defun untabify-buffer ()
  (interactive)
  (untabify (point-min) (point-max)))

(defun indent-buffer ()
  (interactive)
  (indent-region (point-min) (point-max)))

(defun cleanup-buffer ()
  "Perform a bunch of operations on the whitespace content of a buffer."
  (interactive)
  (indent-buffer)
  (untabify-buffer)
  (delete-trailing-whitespace))

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

(defun sudo-edit (&optional arg)
  (interactive "p")
  (if (or arg (not buffer-file-name))
      (find-file (concat "/sudo:root@localhost:" (ido-read-file-name "File: ")))
    (find-alternate-file (concat "/sudo:root@localhost:" buffer-file-name))))

(defun lorem ()
  "Insert a lorem ipsum."
  (interactive)
  (insert "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do "
          "eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim"
          "ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut "
          "aliquip ex ea commodo consequat. Duis aute irure dolor in "
          "reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla "
          "pariatur. Excepteur sint occaecat cupidatat non proident, sunt in "
          "culpa qui officia deserunt mollit anim id est laborum."))

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

;;------------------------------------------------
;;==Plugins
;;------------------------------------------------

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
(global-set-key (kbd "C-c p") 'planner)
(global-set-key (kbd "C-c j") 'journal)
(global-set-key (kbd "C-c h") 'hotkeys)
(global-set-key [f7] 'ansi-term)
(global-set-key [f8] 'org-agenda-clock-cancel)
(global-set-key [f9] 'org-agenda-clock-in)
(global-set-key [f10] 'org-agenda-clock-out)
(global-set-key [f11] 'switch-full-screen-toggle)
(global-set-key [f12]         'org-capture)
(global-set-key (kbd "C-c e") 'djcb-erc-start-or-switch) ;; switch to ERC
(global-set-key "\C-x\C-k" 'kill-region)
(global-set-key "\C-c\C-k" 'kill-region)
(global-set-key (kbd "M-L") 'next-buffer)
(global-set-key (kbd "M-H") 'previous-buffer)
;; (global-set-key (kbd "M-/") 'hippie-expand)
(global-set-key "\r" 'newline-and-indent)
                                        ;(global-set-key (kbd "C-M-p") 'enlarge-window-horizontally)
                                        ;(global-set-key (kbd "C-M-o") 'shrink-window-horizontally)
(global-set-key "\C-xj" 'join-line)
(global-set-key "\C-xi" 'ido-goto-symbol) ;own func
(global-set-key "\C-xf" 'xsteve-ido-choose-from-recentf)
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

(bind "C-M-S" isearch-other-window)
(bind "C-S-p" scroll-down-keep-cursor)
(bind "C-S-n" scroll-up-keep-cursor)
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
(global-set-key (kbd "s-p") 'wg-switch-left)
(global-set-key (kbd "s-n") 'wg-switch-right)

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
(global-set-key "\C-w" 'backward-kill-word)
(global-set-key (kbd "M-Z") 'kylpo-zap-back-to-char)

(global-set-key (kbd "s--") 'text-scale-decrease)
(global-set-key (kbd "s-=") 'text-scale-increase)

;; (global-set-key (kbd "s-n") 'wg-switch-left)
;; (global-set-key (kbd "s-p") 'wg-switch-left)
(global-set-key (kbd "M-#") 'isearch-forward-at-point)
(global-set-key (kbd "C-j") 'join-line)
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