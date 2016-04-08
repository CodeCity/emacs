
;;;; Python settings for Emacs
;;;; 2016-04-01

;;Elpy - Emacs with Python

(elpy-enable)
(elpy-use-ipython)

(require 'py-autopep8)
(add-hook 'python-mode-hook 'py-autopep8-enable-on-save)

(require 'restclient)

(when (require 'flycheck nil t)
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode))

(org-babel-do-load-languages
 'org-babel-load-languages
 '((python . t)))

(defun elpy-shell-send-region-or-buffer (&optional arg)
  "Send the active region or the buffer to the Python shell.                    

If there is an active region, send that. Otherwise, send the                    
whole buffer.                                                                   

In Emacs 24.3 and later, without prefix argument, this will                     
escape the Python idiom of if __name__ == '__main__' to be false                
to avoid accidental execution of code. With prefix argument, this               
code is executed."
  (interactive "P")
  ;; Ensure process exists                                                      
  (elpy-shell-get-or-create-process)
  (let ((if-main-regex "^if +__name__ +== +[\"']__main__[\"'] *:")
        (has-if-main nil))
    (if (region-active-p)
        (let ((region (elpy--region-without-indentation
                       (region-beginning) (region-end))))
          (setq has-if-main (string-match if-main-regex region))
          (python-shell-send-string region))
      (save-excursion
        (goto-char (point-min))
        (setq has-if-main (re-search-forward if-main-regex nil t)))
      (python-shell-send-buffer arg))
    (display-buffer (process-buffer (elpy-shell-get-or-create-process)))
    (when has-if-main
      (message (concat "Removed if __main__ == '__main__' construct, "
                       "use a prefix argument to evaluate.")))))
