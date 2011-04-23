(server-start)
;;Done at start to load faster
;; (if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))

(push "/usr/local/bin" exec-path) ;needed for the mac, doesn't break/hurt linux

;;------------------------------------------------
;;== LOAD PATH, AUTOLOADS, REQUIRES AND FILE ASSOCIATIONS
;;------------------------------------------------
;;*****ELPA****

;;early in .emacs to be able to use plugins later down
(when
    (load
     (expand-file-name "~/.emacs.d/elpa/package.el"))
  (package-initialize))

;;*****EL-GET INIT*****
(add-to-list 'load-path "~/.emacs.d/el-get/el-get")

(setq package-archives
      '(("original" . "http://tromey.com/elpa/")
        ("gnu" . "http://elpa.gnu.org/packages/")
        ("marmalade" . "http://marmalade-repo.org/packages/")
        ("sunrise-commander" . "http://joseito.republika.pl/sunrise-commander/")
        ))

(if (require 'el-get nil t)
    (progn
      (message "el-get already installed"))
  (url-retrieve
   "https://github.com/dimitri/el-get/raw/master/el-get-install.el"
   (lambda (s)
     (end-of-buffer)
     (eval-print-last-sexp))))

(setq
 el-get-sources ;order does matter for some of these
 '(el-get
   ack
   (:name auto-complete :after
          (lambda ()
            ;; (setq ac-auto-start nil
            ;;       ac-modes '(erlang-mode
            ;;                  espresso-mode
            ;;                  js2-mode
            ;;                  sql-mode
            ;;                  ruby-mode
            ;;                  haml-mode
            ;;                  sass-mode
            ;;                  css-mode
            ;;                  lisp-interaction-mode
            ;;                  emacs-lisp-mode
            ;;                  css-mode
            ;;                  sql-interactive-mode))
            ;;(define-key ac-complete-mode-map (kbd "C-n") 'ac-next)
            ;;(define-key ac-complete-mode-map (kbd "C-p") 'ac-previous)))
            ))
   bookmark+ ;;http://www.emacswiki.org/emacs/BookmarkPlus#toc2
   (:name buffer-move ; have to add your own keys
          :after (lambda ()
                   (global-set-key (kbd "<C-S-up>") 'buf-move-up)
                   (global-set-key (kbd "<C-S-down>") 'buf-move-down)
                   (global-set-key (kbd "<C-S-left>") 'buf-move-left)
                   (global-set-key (kbd "<C-S-right>") 'buf-move-right)))
   dired+ ;;http://www.emacswiki.org/emacs/DiredPlus#Dired%2b
   erc-highlight-nicknames
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
   magithub
   rvm
   (:name smex ; a better (ido like) M-x
          :after (lambda ()
                   (setq smex-save-file "~/.emacs.d/.smex-items")
                   (global-set-key (kbd "M-x") 'smex)
                   (global-set-key (kbd "M-X") 'smex-major-mode-commands)))

   sunrise-commander
   sunrise-x-buttons
   todochiku
   (:name yasnippet
       :type svn
       :url "http://yasnippet.googlecode.com/svn/trunk/"
       :features "yasnippet"
       :post-init (lambda ()
                    (yas/initialize)
;                    (add-to-list 'yas/snippet-dirs (concat el-get-dir "yasnippet/snippets"))
;                    (add-to-list 'yas/snippet-dirs (concat this-directory "snippets"))
                    (add-to-list 'yas/snippet-dirs (concat (file-name-directory (or load-file-name buffer-file-name)) "snippets/"))
                    (yas/reload-all)))
   color-theme
   wrap-region
   yari
   (:name senny-textmate
          :type git
          :url "https://github.com/defunkt/textmate.el.git"
          :features textmate

          ;; customization
          :after (lambda ()
                   (textmate-mode t)))
  ;; (:name senny-popwin
  ;;         :features popwin
  ;;         :type git
  ;;         :url "https://github.com/m2ym/popwin-el.git"
  ;;         :load-path "."
  ;;         :after (lambda ()
  ;;                  (setq display-buffer-function 'popwin:display-buffer)
  ;;                  (setq popwin:special-display-config '(("*Ido Completions*")))))
;   (:name worklog :type elpa)
   (:name idle-highlight :type elpa)
   (:name org-mode :after
          (lambda ()
            (require 'org-habit)
            (add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))))
   (:name inf-ruby  :type elpa)
   (:name ruby-compilation :type elpa)
   (:name ruby-electric :type elpa)
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
                        (require 'ruby-electric)
                        (define-key ruby-mode-map (kbd "#") 'ruby-interpolate)
                        (ruby-electric-mode t)
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
          :after
          (lambda ()
            (autoload 'rhtml-mode "rhtml-mode" nil t)
            (add-to-list 'auto-mode-alist '("\\.erb\\'" . rhtml-mode))
            (add-to-list 'auto-mode-alist '("\\.rjs\\'" . rhtml-mode))
            (add-to-list 'auto-mode-alist '("\\.rhtml$" . rhtml-mode))
            (add-hook 'rhtml-mode
                      '(lambda ()
                         (define-key rhtml-mode-map (kbd "M-s") 'save-buffer)))))
   (:name rinari
          :after (lambda ()
                   (add-hook 'rhtml-mode-hook
                             (lambda () (rinari-launch)))))
   ruby-end ;necessary to place after ruby-mode
   flymake-ruby
   (:name senny-perspective
          :type git
          :features perspective
          :url "https://github.com/nex3/perspective-el.git"
          :after (lambda () (persp-mode)))
   (:name senny-rspec-mode
          :type git
          :url "https://github.com/pezra/rspec-mode.git"
          :compile "rspec-mode.el"
          :features rspec-mode)
   (:name yaml-mode
          :type git
          :url "http://github.com/yoshiki/yaml-mode.git"
          :features yaml-mode
          :after (lambda ()
                   (autoload 'yaml-mode "yaml-mode" nil t)
                   (add-to-list 'auto-mode-alist '("\\.ya?ml\\'" . yaml-mode))
                   (add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
                   (add-to-list 'auto-mode-alist '("\\.yaml$" . yaml-mode))))
   ))

(el-get 'sync)

(require 'ido)
(require 'tramp)
(require 'redo+) ;;from elpa
                      ;(require 'org)
                                        ;(require 'org-protocol)
                                        ;(require 'org-install)
                                        ;(require 'org-habit)
;(require 'easymenu) ;for ERC
                                        ;(require 'yaml-mode);doesn't auto init from elpa
                                        ;(add-to-list 'auto-mode-alist '("\\.ya?ml\\'" . yaml-mode))
                                        ;(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
                                        ;(add-to-list 'auto-mode-alist '("\\.yaml$" . yaml-mode))
(add-to-list 'auto-mode-alist '("\\.php$" . php-mode))
(add-to-list 'auto-mode-alist '("\\.inc$" . php-mode))
;; We never want to edit Rubinius bytecode
(add-to-list 'completion-ignored-extensions ".rbc")

;; Deal with colors in shell mode correctly
(autoload 'ansi-color-for-comint-mode-on "ansi-color" nil t)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

;;------------------------------------------------
                                        ;== Platform Dependencies
;;------------------------------------------------
(cond
 ((string-match "nt" system-configuration)

  );;end windows

 ((string-match "apple" system-configuration)
                                        ;  (add-to-list 'el-get-sources 'color-theme)
  (defun dired-do-shell-mac-open-vqn ()
    (interactive)
    (save-window-excursion
      (dired-do-async-shell-command
       "open" current-prefix-arg
       (dired-get-marked-files t current-prefix-arg))))

  (add-hook 'dired-mode-hook (lambda () (local-set-key "E" 'dired-do-shell-mac-open-vqn)))
  );;end apple

 ((string-match "linux" system-configuration)
  ;;start LINUX
;;  (setq browse-url-browser-function 'browse-url-generic browse-url-generic-program "/usr/bin/conkeror")
  ;;10pt font aka :height 10*10=100
  (set-face-attribute 'default (not 'this-frame-only) :height 100 :foundry "unknown" :family "Droid Sans Mono")

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

  ;; sort ido filelist by mtime instead of alphabetically
  ;; (defun ido-sort-mtime ()
  ;;   (setq ido-temp-list
  ;;         (sort ido-temp-list
  ;;               (lambda (a b)
  ;;                 (time-less-p
  ;;                  (sixth (file-attributes (concat ido-current-directory b)))
  ;;                  (sixth (file-attributes (concat ido-current-directory a)))))))
  ;;   (ido-to-end  ;; move . files to end (again)
  ;;    (delq nil (mapcar
  ;;               (lambda (x) (and (char-equal (string-to-char x) ?.) x))
  ;;               ido-temp-list))))
  ;; (add-hook 'ido-make-file-list-hook 'ido-sort-mtime)
  ;; (add-hook 'ido-make-dir-list-hook 'ido-sort-mtime)
  );;end linux
 )


;;------------------------------------------------
                                        ;== INIT & CONFIG
;;------------------------------------------------

;; (yas/initialize)
;; (yas/load-directory
 ;; (concat (file-name-directory (or load-file-name buffer-file-name)) "rails-snippets/"))

;; save a list of open files in ~/.emacs.desktop
;; save the desktop file automatically if it already exists
;;(setq desktop-save 'if-exists)
;;(desktop-save-mode 1)

;; save a bunch of variables to the desktop file
;; for lists specify the len of the maximal saved data also
;; (setq desktop-globals-to-save
;;       (append '((extended-command-history . 30)
;;                 (file-name-history        . 100)
;;                 (grep-history             . 30)
;;                 (compile-history          . 30)
;;                 (minibuffer-history       . 50)
;;                 (query-replace-history    . 60)
;;                 (read-expression-history  . 60)
;;                 (regexp-history           . 60)
;;                 (regexp-search-ring       . 20)
;;                 (search-ring              . 20)
;;                 (shell-command-history    . 50)
;;                 tags-file-name
;;                 register-alist)))

(setq ibuffer-shrink-to-minimum-size t)
(setq ibuffer-always-show-last-buffer nil)
(setq ibuffer-sorting-mode 'recency)
(setq ibuffer-use-header-line t)

;; whenever an external process changes a file underneath emacs, and there
;; was no unsaved changes in the corresponding buffer, just revert its
;; content to reflect what's on-disk.
(global-auto-revert-mode 1)

;;Display
;; Use a vertical bar as cursor
(blink-cursor-mode 1)
(setq-default cursor-type '(bar . 2))
(setq-default indicate-empty-lines t)

(load "~/.emacs.d/colors/color-theme-wombat")
(color-theme-wombat);http://jaderholm.com/color-themes/color-theme-wombat.el
;; (load "~/.emacs.d/colors/zenburn")
;; (color-theme-zenburn);http://emacs-fu.blogspot.com/2010/04/zenburn-color-theme.html
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(prefer-coding-system 'utf-8)
(setq c-basic-offset 3) ; Indenting is 3 spaces
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
(display-time-mode t)
(display-battery-mode t)
(global-hl-line-mode t) ; Highlight the current line

(ido-mode 'both) ; User ido mode for both buffers and files
(setq ido-enable-prefix nil
      ido-enable-flex-matching t
      ido-create-new-buffer 'always
      ido-use-filename-at-point 'guess
      ido-show-dot-for-dired t
      ido-save-directory-list-file "~/.emacs.d/.ido.last")
;;      ido-max-prospects 10)

;; Display ido results vertically, rather than horizontally
;; (setq ido-decorations (quote ("" "" "\n   " "\n   ..." "[" "]" " [No match]" " [Matched]" " [Not readable]" " [Too big]" " [Confirm]")))
;; (defun ido-disable-line-trucation () (set (make-local-variable 'truncate-lines) nil))
;; (add-hook 'ido-minibuffer-setup-hook 'ido-disable-line-trucation)


(add-hook 'before-save-hook 'delete-trailing-whitespace)
(set-default 'imenu-auto-rescan t)

(recentf-mode 1)
(setq backup-directory-alist (list (cons ".*" (expand-file-name "~/bak/emacs/")))) ; Temp files
(setq x-select-enable-clipboard t) ; Integrate with X11s clipboard
(setq-default indent-tabs-mode nil) ; Dont indent with tabs
(setq confirm-kill-emacs 'yes-or-no-p) ; stops me killing emacs by accident!
(setq scroll-step 1) ; Only scroll down 1 line at a time
(setq scroll-conservatively 10) ; make scroll less jumpy
(setq scroll-margin 7) ; scroll will start b4 getting to top/bottom of page

;; activate disabled features
(put 'narrow-to-region 'disabled nil)
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)

(setq rinari-tags-file-name "TAGS")
;;(setq next-line-add-newlines t);C-n at end of buffer will create new line

(setq windmove-wrap-around t) ;windmove-wrap

(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(speedbar-hide-button-brackets-flag t)
 '(speedbar-indentation-width 2)
 '(speedbar-show-unknown-files t)
 '(speedbar-update-flag nil t)
 '(speedbar-use-images nil)
 '(sr-show-file-attributes nil))

(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(org-upcoming-deadline ((t (:foreground "yellow"))))
 '(sr-directory-face ((t (:foreground "yellow" :weight bold))))
 '(sr-symlink-directory-face ((t (:foreground "yellow4" :slant italic)))))

;;------------------------------------------------
;;== Custom Functions
;;------------------------------------------------
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
  "Modify the behavior of the open-*-line functions to cause them to autoindent.")

(defun my-delete-backward-to-ws ()
  (interactive)
  (delete-region (point) (save-excursion (skip-syntax-backward "^ ") (point))))

(defun window-half-height () ;taken from http://www.emacswiki.org/emacs/HalfScrolling
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

   ;; (global-set-key [next] 'scroll-up-half)
   ;; (global-set-key [prior] 'scroll-down-half)

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

(defadvice zap-to-char (after dont-zap-char (arg char))
  "Doesn't include the char - zaps to the char before it (like vim)."
  (insert char)
  (backward-char))
(ad-activate 'zap-to-char)

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
  (shell-command "rtags --recurse ."))

(defun etags ()
  (interactive)
  (shell-command "etags -a -f TAGS *"))

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

(defun senny-ido-find-work ()
  (interactive)
  (let ((project-name (ido-completing-read "Work: "
                                           (directory-files "~/Work/" nil "^[^.]"))))
    (senny-persp project-name)
    (find-file (ido-open-find-directory-files
                (concat "~/Work/" project-name)))))
;;TODO
(defun ido-open-find-directory-files (directory)
  (let ((directory (concat (expand-file-name directory) "/")))
    (concat directory (ido-completing-read (concat directory ": ")
                                           (mapcar (lambda (path)
                                                     (replace-regexp-in-string (concat "^" (regexp-quote directory) "/") "" path))
                                                   (split-string
                                                    (shell-command-to-string
                                                     (concat
                                                      "find \"" directory
                                                      "\" -type f | grep -v \"/.git/\" | grep -v \"/.yardoc/\""))))))))

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

;; (defun move-cursor-next-pane ()
;;   "Move cursor to the next pane."
;;   (interactive)
;;   (other-window 1))

;; (defun move-cursor-previous-pane ()
;;   "Move cursor to the previous pane."
;;   (interactive)
;;   (other-window -1))

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
  (interactive "CEnter command: ")
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
  (insert (format-time-string "%c" (current-time))))

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

;;*****Dired & Tramp*****
(setq tramp-default-method "ssh")
(setq dired-omit-files
      (concat dired-omit-files "\\|^\\..+$"))

;;*****ORG-MODE*****
(defun planner ()
  (interactive)
  (find-file "~/Dropbox/doc/planner.org")
  )
(defun journal()
  (interactive)
  (find-file "~/Dropbox/doc/journal.org")
  )

(setq org-habit-graph-column 60)
(setq org-log-done 'time)
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
(setq org-log-done (quote (done)))
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
(setq org-todo-keyword-faces
      '(("TODO"  . (:foreground "red" :weight bold))
        ("STARTED" :foreground "blue" :weight bold)
        ("GOAL"  . (:foreground "purple" :weight bold))
        ("WAITING"  . (:foreground "orange" :weight bold))
        ("DELEGATED"  . (:foreground "orange" :weight bold))
        ("SOMEDAY"  . (:foreground "orange" :weight bold))
        ("ONGOING"  . (:foreground "orange" :weight bold))
        ("DONE"  . (:foreground "forest green" :weight bold))
        ("DISMISSED"  . (:foreground "forest green" :weight bold))
        ("CANCELLED"  . (:foreground "forest green" :weight bold))
        ))

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

;;*****Capture*****
(setq org-capture-templates
      '(("t" "Todo" entry (file+headline "~/Dropbox/doc/planner.org" "Tasks")
                                        ;             "* TODO %?\n----Entered on %U\n  %i")
         "* TODO %?  %i")
        ("j" "Journal" entry (file+datetree "~/Dropbox/doc/journal.org"))
                                        ; "** %?")
        ("l" "Log Time" entry (file+datetree "~/Dropbox/doc/timelog.org" )
         "** %U - %^{Activity}  :TIME:")
        ("r" "Tracker" entry (file+datetree "~/Dropbox/doc/journal.org")
         "* Tracker \n| Item | Count |
              %?|-+-|
              | Pull||
              | Push||
              | Crunch||
              | Back||
              |-|
              | Anki||";;\n#+BEGIN: clocktable :maxlevel 5 :scope agenda :block today\n#+END:"
         )
        ("w" "" entry ;; 'w' for 'org-protocol'
         (file+headline "~/Dropbox/doc/www.org" "Notes`")
         "* %^{Title}\n\n  Source: %u, %c\n\n  %i")
        ("m" "movie" entry (file+headline "~/Dropbox/doc/media.org" "Movies")
         "* %? \n----Entered on %U\n  %i")
        ("b" "book" entry (file+headline "~/Dropbox/doc/media.org" "Books")
         "* %? \n----Entered on %U\n  %i")
        ))
;; (setq org-capture-templates
;;      (quote (("w" "web note" entry (file+headline "~/org/web.org" "Notes") "* Source: %u, %c\n  %i")
;;              ("l" "scriptjure political or economic references" entry (file+headline "~/org/scripture-study.org" "Politics or Economic")
;;               "* %c %^{Type|descriptive|prescriptive|other} %U\n  %i\n\n   Notes: %^{Notes}")
;;              ("s" "scripture" entry (file+headline "~/org/scripture-study.org" "Notes") "* %c %U\n  %i")
;;              ("x" "co template" entry (file+headline "~/org/co.org" "co") "* %c\n" :immediate-finish 1)
;;              ("b" "book" entry (file+headline "~/www/org/truth.org" "Notes") "* %U\n  %?")
;;             ("t" "todo" entry (file+headline "~/org/todo.org" "Tasks") "* TODO %?")
;;            ("c" "calendar" entry (file+headline "~/org/calendar.org" "Events") "* %?\n  %^t")
;;           ("p" "phone-calls" entry (file+headline "~/doc/phone-calls.org" "Phone Calls") "* %T %?")
;;              ("j" "journal" entry (file+headline "~/doc/personal/journal.org" "Journal") "* %U\n%?")
;;              ("m" "music" entry (file+headline "~/org/music.org" "Music to checkout") "* :%^{Field|song|artist|album} %^{Value} :%^{Field|song|artist|album} %^{Value}")
;;              ("v" "movie" entry (file+headline "~/org/movies.org" "Movies to see") "* %^{Movie name}")
;;              ("n" "note" entry (file+headline "~/org/notes.org" "Notes") "* %U\n  %?")
;;              ("f" "food" entry (file+headline "~/org/food.org" "Food") "* %U\n  - %?")
;;              ("f" "programming" entry (file+headline "~/org/programming.org" "Questions") "* %U\n  - %?")
;;              ("e" "exercise" entry (file+headline "~/org/exercise.org" "Exercise") "* %U\n  - %?")
;;              ("o" "other" entry (file+headline "~/remember.org" "") "* %a\n%i"))))


;;*****CALENDAR/DIARY MODE*****
(setq view-diary-entries-initially t
      mark-diary-entries-in-calendar t
      number-of-diary-entries 7)
(add-hook 'diary-display-hook 'fancy-diary-display)
(add-hook 'today-visible-calendar-hook 'calendar-mark-today)


;;*****ERC STUFF*****
;(easy-menu-add-item  nil '("tools") ["IRC with ERC" erc t])

;; joining && autojoing

;; make sure to use wildcards for e.g. freenode as the actual server
;; name can be be a bit different, which would screw up autoconnect
(erc-autojoin-mode t)
(setq erc-autojoin-channels-alist
      '((".*\\.freenode.net" "#emacs" "#conkeror" "#org-mode" "#ruby" "#rails")))
;; (".*\\.gimp.org" "#gimp" "#gimp-users")))

;; check channels
(erc-track-mode t)
(setq erc-track-exclude-types '("JOIN" "NICK" "PART" "QUIT" "MODE"

                                "324" "329" "332" "333" "353" "477"))
;; don't show any of this
(setq erc-hide-list '("JOIN" "PART" "QUIT" "NICK"))

(defun djcb-erc-start-or-switch ()
  "Connect to ERC, or switch to last active buffer"
  (interactive)
  (if (get-buffer "irc.freenode.net:6667") ;; ERC already active?

      (erc-track-switch-buffer 1) ;; yes: switch to last active
    (when (y-or-n-p "Start ERC? ") ;; no: maybe start ERC
      (erc :server "irc.freenode.net" :port 6667 :nick "kylpo"))))
;; (erc :server "irc.gimp.org" :port 6667 :nick "sevfen"))))

;;*****SPEEDBAR*****
;; (setq speedbar-use-imenu-flag nil)
;; (setq speedbar-fetch-etags-command "/usr/bin/ctags-exuberant")
;; (setq speedbar-fetch-etags-arguments '("-e" "-f" "-"))

;;Setup speedbar, an additional frame for viewing source files
(autoload 'speedbar-frame-mode "speedbar" "Popup a speedbar frame" t)
(autoload 'speedbar-get-focus "speedbar" "Jump to speedbar frame" t)
(autoload 'speedbar-toggle-etags "speedbar" "Add argument to etags command" t)
(setq speedbar-frame-plist '(minibuffer nil
                                        border-width 0
                                        internal-border-width 0
                                        menu-bar-lines 0
                                        modeline t
                                        name "SpeedBar"
                                        width 24
                                        unsplittable t))

;;;; Perspective
(eval-after-load 'perspective
  '(progn

     ;; Perspective Setup
     (defmacro senny-persp (name &rest body)
       `(let ((initialize (not (gethash ,name perspectives-hash)))
              (current-perspective persp-curr))
          (persp-switch ,name)
          (when initialize ,@body)
          (setq persp-last current-perspective)))

     (defun persp-format-name (name)
       "Format the perspective name given by NAME for display in `persp-modestring'."
       (let ((string-name (format "%s" name)))
         (if (equal name (persp-name persp-curr))
             (propertize string-name 'face 'persp-selected-face))))

     (defun persp-update-modestring ()
       "Update `persp-modestring' to reflect the current perspectives.
Has no effect when `persp-show-modestring' is nil."
       (when persp-show-modestring
         (setq persp-modestring
               (append '("[")
                       (persp-intersperse (mapcar 'persp-format-name (persp-names)) "")
                       '("]")))))

     ;; Perspective Defuns
     (defun senny-persp-last ()
       (interactive)
       (persp-switch (persp-name persp-last)))


;;;; Perspective Definitions
     ;; (defun senny-persp/jabber ()
     ;;   (interactive)
     ;;   (senny-persp "@Jabber"
     ;;                (jabber-connect-all)
     ;;                (call-interactively 'jabber-display-roster)
     ;;                (switch-to-buffer jabber-roster-buffer)))

     (defun senny-persp/irc ()
       (interactive)
       (senny-persp "@IRC"
                    (djcb-erc-start-or-switch)
                    ;; (dolist (channel '("emacs" "ruby" "cucumber"))
                    ;;   (erc-join-channel channel))
                    ))

     (defun senny-persp/terminal ()
       (interactive)
       (senny-persp "@terminal"
                    (multi-term-next)
                    (jone-term-binding-fix)))

     (defun senny-persp/emacs ()
       (interactive)
       (senny-persp "@Emacs"))

     (defun senny-persp/org ()
       (interactive)
       (senny-persp "@org"
                    (find-file (first org-agenda-files))
                    (find-file "~/Dropbox/doc/ci.org")
                    (org-agenda-list 1)))

     (defun senny-persp/koans ()
       (interactive)
       (senny-persp "@koans"
                    (find-file ("~/Dropbox/koans/"))))

     (defun senny-persp/main ()
       (interactive)
       (senny-persp "main"))
     ))


;;------------------------------------------------
                                        ;== GLOBAL KEYBINDS
;;------------------------------------------------

;;-----------------------------------------------------------------------------
;; F2: files
;;-----------------------------------------------------------------------------
(defmacro set-key-find-file (key file)
  "Defines a shortcut key to open a file."
  (let ((fname (intern (concat "open-" file))))
    `(progn (defun ,fname () (interactive) (find-file ,file))
            (global-set-key (kbd ,key) ',fname))))

(set-key-find-file "<f2> e" "~/.emacs")
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
                                        ;(bind "<f6> t" 'visit-tags-table)
                                        ;(bind "<f6> h" 'jao-toggle-selective-display)
                                        ;(bind "<f6> h" 'hs-org/minor-mode)
                                        ;(bind "<f6> d" 'color-theme-wombat)
                                        ;(bind "<f6> l" 'color-theme-active)
                                        ;(bind "<f6> n" 'linum-mode)
(global-set-key (kbd "<f6> e") 'senny-persp/emacs)
(global-set-key (kbd "<f6> t") 'senny-persp/terminal)
(global-set-key (kbd "<f6> m") 'senny-persp/main)
(global-set-key (kbd "<f6> i") 'senny-persp/irc)
(global-set-key (kbd "<f6> o") 'senny-persp/org)
(global-set-key (kbd "<f6> s") 'persp-switch)
(global-set-key (kbd "<f6> p") 'senny-persp-last)

;;-----------------------------------------------------------------------------
;; F9: Emacs programs
;;-----------------------------------------------------------------------------
                                        ;(bind "<f9> e" eshell)
                                        ;(bind "<f9> f" rgrep)
                                        ;(bind "<f9> h" (lambda () (interactive) (dired "~")))
                                        ;(bind "<f9> c" calendar)
                                        ;(bind "<f9> r" org-remember)
                                        ;(bind "<f9> g" gnus)
                                        ;(bind "<f9> M-g" gnus-unplugged)


;;-----------------------------------------------------------------------------
;; F11:
;;-----------------------------------------------------------------------------

(bind "<M-f11>" recentf-open-files)

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
(global-set-key [f7] 'ansi-term)
(global-set-key [f8] 'org-agenda-clock-cancel)
(global-set-key [f9] 'org-agenda-clock-in)
(global-set-key [f10] 'org-agenda-clock-out)
(global-set-key [f11] 'switch-full-screen-toggle)
(global-set-key [f12]         'org-capture)
(global-set-key (kbd "C-c e") 'djcb-erc-start-or-switch) ;; switch to ERC
(global-set-key "\C-w" 'backward-kill-word)
(global-set-key "\C-x\C-k" 'kill-region)
(global-set-key "\C-c\C-k" 'kill-region)
(global-set-key (kbd "M-n") 'next-buffer)
;(global-set-key (kbd "M-p") 'previous-buffer)
                                        ;(global-set-key (kbd "M-n") 'move-cursor-next-pane)
                                        ;(global-set-key (kbd "M-p") 'move-cursor-previous-pane)
(global-set-key (kbd "M-/") 'hippie-expand)
                                        ;(global-set-key (kbd "C-z") 'set-mark-command)
                                        ;(global-set-key [C-tab] 'other-window)
(global-set-key "\r" 'newline-and-indent)
                                        ;(global-set-key (kbd "C-M-p") 'enlarge-window-horizontally)
                                        ;(global-set-key (kbd "C-M-o") 'shrink-window-horizontally)
(global-set-key "\C-xq" 'anything)
(global-set-key "\C-xj" 'join-line)
(global-set-key "\C-xi" 'ido-goto-symbol) ;own func
(global-set-key "\C-xf" 'xsteve-ido-choose-from-recentf)
(global-set-key "\C-x," 'my-ido-find-tag)
(global-set-key "\C-xc" 'calendar)
(global-set-key "\C-xt" 'eshell)
                                        ;(global-set-key "\C-xs" 'flyspell-mode)
(global-set-key "\C-xs" 'sunrise)
                                        ;(global-set-key "\C-xc" 'search)
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
                                        ;(global-set-key "\C-cb" 'org-iswitchb)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-x\C-b" 'ibuffer)
(global-set-key (kbd "C-x O") 'previous-multiframe-window) ;back a window
;; (global-set-key (kbd "C-x g") 'magit-status)

(global-set-key (kbd "C-c y") 'bury-buffer)
(global-set-key (kbd "C-c r") 'revert-buffer)

(bind "C-x M-f" 'find-file-other-window)
(global-set-key "\M-?" 'comment-or-uncomment-current-line-or-region)

(bind "C-M-S" isearch-other-window)
(bind "C-S-p" scroll-down-keep-cursor)
(bind "C-S-n" scroll-up-keep-cursor)

;; Window Navigation/Manipulation
                                        ;(bind "s-C-n" 'other-window)
                                        ;(bind "s-C-p" 'previous-multiframe-window)
(bind "C-^" 'enlarge-window)
(bind "C-<" 'shrink-window-horizontally)
(bind "C->" 'enlarge-window-horizontally)
(global-unset-key (kbd "M-j"))
(global-unset-key (kbd "M-k"))
(global-unset-key (kbd "M-h"))
(global-unset-key (kbd "M-l"))
(bind "M-j" 'windmove-down)
(bind "M-k" 'windmove-up)
(bind "M-h" 'windmove-left)
(bind "M-l" 'windmove-right)
(global-set-key (kbd "M-0") 'delete-window)
(global-set-key (kbd "M-1") 'delete-other-windows)
(global-set-key (kbd "M-2") 'split-window-vertically)
(global-set-key (kbd "M-3") 'split-window-horizontally)
(global-set-key (kbd "M-4") 'balance-windows)

(bind "s-x" (lambda ()
              (interactive)
              (call-interactively
               (intern
                (ido-completing-read
                 "M-x "
                 (all-completions "" obarray 'commandp))))))

(define-key isearch-mode-map (kbd "C-o") 'isearch-occur) ;occur in isearch
(global-set-key [S-return]   'open-next-line)
(global-set-key [C-S-return] 'open-previous-line)

(global-set-key [next] 'sfp-page-down)
(global-set-key [prior] 'sfp-page-up)
(global-unset-key (kbd "M-S-v"))
(global-unset-key (kbd "C-S-v"))
(global-set-key (kbd "M-S-v") 'kylpo-page-up-half)
(global-set-key (kbd "C-S-v") 'kylpo-page-down-half)
(global-set-key (kbd "C-v") 'sfp-page-down)
(global-set-key (kbd "M-v") 'sfp-page-up)


;(global-unset-key (kbd "C-x x i"))
(global-set-key (kbd "C-x SPC e") 'senny-persp/emacs)
(global-set-key (kbd "C-x SPC t") 'senny-persp/terminal)
(global-set-key (kbd "C-x SPC m") 'senny-persp/main)
(global-set-key (kbd "C-x SPC i") 'senny-persp/irc)
(global-set-key (kbd "C-x SPC o") 'senny-persp/org)
;(global-set-key (kbd "M-p s") 'persp-switch)
(global-set-key (kbd "C-x SPC p") 'senny-persp-last)
