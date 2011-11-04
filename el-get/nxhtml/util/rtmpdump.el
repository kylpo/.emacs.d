;;; rtmpdump.el --- Helper functions for rtmpdump
;; 
;; Author: Lennart Borgman (lennart O borgman A gmail O com)
;; Created: 2011-08-18
;; Version: 0.2
;; Last-Updated: 
;; URL: 
;; Keywords: video
;; Compatibility: 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 
;;; Commentary: 
;;
;; Download streaming videos from SVTPlay etc.
;; See http://huggpunkt.org/ladda-hem-fran-svtplay-v2 (in Swedish).
;; 
;; The commands shows a command for downloading with rtmpdump.
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 
;;; Change Log:
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 
;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 3, or
;; (at your option) any later version.
;; 
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.
;; 
;; You should have received a copy of the GNU General Public License
;; along with this program; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth
;; Floor, Boston, MA 02110-1301, USA.
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 
;;; Code:

(defcustom rtmpdump-program "rtmpdump.exe"
  "Name of rtmpdump program."
  :type 'string
  :group 'rtmpdump)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Commands

;; (rtmpdump-from-url "http://svtplay.se/v/2506447/dokumentarfilm/darwins_vag_fran_ide_till_teori")

;;;###autoload
(defun rtmpdump-from-url (url)
  (interactive "sURL:")
  (rtmpdump-display (rtmpdump-from-url-1 url))
  nil)

;;;###autoload
(defun rtmpdump-from-buffer (buf)
  (interactive "bBuffer:")
  (rtmpdump-display (rtmpdump-from-buffer-1 buf))
  nil)

;;;###autoload
(defun rtmpdump-from-file (file)
  (interactive "fFile:")
  (let ((buf (find-file-noselect file)))
    (rtmpdump-from-buffer buf)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Internal

(defun rtmpdump-display (cmd)
  (when cmd
    (if noninteractive
        (message "COMMAND: %s" cmd)
      (let ((buf (get-buffer-create "*RTMPDUMP*")))
        (with-current-buffer buf
          (erase-buffer)
          (insert "Command (paste this in a console, with your file name inserted):\n\n  "
                  cmd
                  "\n\n"
                  "If download stops then add -e to the command line and\n"
                  "call it again until the file is 100% downloaded."))
        (display-buffer buf)))))

(defun rtmpdump-from-url-1 (url)
  (let ((outbuf
	 (condition-case err
	     (url-retrieve-synchronously url)
	   (error (message "%s" (error-message-string err))
		  nil))))
    (when outbuf
      (declare (special url-http-response-status))
      (let ((status (with-current-buffer outbuf url-http-response-status)))
        (if (/= 200 status)
            (progn
              (message "Error trying to get url, status=%S" status)
              nil)
          (rtmpdump-from-buffer-1 outbuf))))))

(defun rtmpdump-from-buffer-1 (buf)
  (with-current-buffer buf
    (goto-char (point-min))
    (let ((patt-start "<object +classid=\"clsid:D27CDB6E-AE6D-11cf-96B8-444553540000\"")
          (patt-url "url:\\(rtmpe?://.*?\\), *bitrate:"))
      (cond
       ((not (re-search-forward patt-start nil t))
        (message "Error: Could not find %S" patt-start)
        nil)
       ;; Fixme: search for different bitrates.
       ((not (re-search-forward patt-url nil t))
        (message "Error: Could not find %S" patt-url)
        nil)
       (t
        (let* ((start (point))
               (rtmpe-url (match-string 1))
               (q-rtmpe-url (shell-quote-argument rtmpe-url))
               (ext (file-name-extension rtmpe-url))
               (outfile (concat "YOUR-FILE." ext))
               (q-outfile (shell-quote-argument outfile))
               (prog (if (file-exists-p rtmpdump-program)
                         (shell-quote-argument rtmpdump-program)
                       rtmpdump-program))
               (cmd (format "%s -r %s -o %s" prog q-rtmpe-url q-outfile))
               )
          (message "rtmpe-url=%S" rtmpe-url)
          cmd))))))

(provide 'rtmpdump)
;; Local variables:
;; coding: utf-8
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; rtmpdump.el ends here
