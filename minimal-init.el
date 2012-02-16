;;; minimal configuration file for emacs as system default editor

(fset 'yes-or-no-p 'y-or-n-p)

(menu-bar-mode -1)
(tool-bar-mode -1)
(mouse-wheel-mode -1)
(mouse-sel-mode -1)

(setq inhibit-startup-screen t
      initial-scratch-message ";; *scratch*\n\n")

(setq backup-inhibited t
      auto-save-default nil)

(setq echo-keystrokes 0.4
      debug-on-error nil
      stack-trace-on-error nil
      standard-indent 4
      tab-always-indent 'complete
      grep-scroll-output t)

(setq-default comment-column 42
              fill-column 78
              indent-tabs-mode nil
              tab-width 4
              word-wrap t)

(show-paren-mode t)

(require 'ido)
(ido-mode t)
(ido-everywhere t)

(defun esk-sudo-edit (&optional arg)
  (interactive "p")
  (if (or arg (not buffer-file-name))
      (find-file (concat "/sudo:root@localhost:" (ido-read-file-name "File: ")))
    (find-alternate-file (concat "/sudo:root@localhost:" buffer-file-name))))
