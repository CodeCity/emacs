;;;; Aaron
;;;; .emacs file - Windows
;;;; Revision: 2016-03-02

;; Remove menu bar and scroll bar
(when window-system
  (menu-bar-mode -1)
  (tool-bar-mode -1)
  (scroll-bar-mode -1))

(setq inhibit-startup-message t)
(setq inhibit-startup-screen t) ;; Prevent GNU Emacs window from starting
(setq initial-scratch-message "Hello Mr. Arlotti. Would you like to play a game?")

;; Global line numbers
(global-linum-mode t)

;; Better font
(add-to-list 'default-frame-alist '(font . "Courier Prime Source-10.0"))

;; Change default cursor style
(set-default 'cursor-type 'hbar)
(blink-cursor-mode 0)

;; Settings for look and feel
(ido-mode)
(show-paren-mode)
(winner-mode t)

;; Visual line mode - Soft wrap
(visual-line-mode 1)

;; Start Emacs maximized
(add-to-list 'default-frame-alist '(fullscreen . maximized))


;;-------------------------------------------
;;-----------Packages------------------------
;;-------------------------------------------

;; Repositories
(when (>= emacs-major-version 24)
  (require 'package)
  (add-to-list
   'package-archives
   '("melpa" . "http://melpa.org/packages/")
   t)
  (add-to-list
   'package-archives
   '("marmalade" . "http://marmalade-repo.org/packages/")
   t)
  (add-to-list
   'package-archives
   '("gnu" . "http://elpa.gnu.org/packages/")
   t)
  (add-to-list
   'package-archives
   '("elpy" . "https://jorgenschaefer.github.io/packages/"))

(package-initialize))


(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))
(require 'diminish)
(require 'bind-key)

(when (not package-archive-contents)
  (package-refresh-contents))

(defvar myPackages
  '(better-defaults
    ein          ; Emacs ipython notebook
    elpy         ; python for emacs
    flycheck     ; python syntax
    magit        ; for git
    py-autopep8  ; configures python correctly
    ))


(mapc #'(lambda (package)
          (unless (package-installed-p package)
            (package-install package)))
      myPackages)


(org-babel-load-file (concat user-emacs-directory "settings.org"))

(defconst user-init-dir
  (cond ((boundp 'user-emacs-directory)
         user-emacs-directory)
        ((boundp 'user-init-directory)
         user-init-directory)
        (t "C:\\Users\\Aaron\\.emacs.d\\")))

(defun load-user-file (file)
  (interactive "f")
  "Load file in current user's cofiguration directory"
  (load-file (expand-file-name file user-init-dir)))

(load-user-file "python.el")
(load-user-file "general.el")

;; smex - autocomplete
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)


;;-------------------------------------------
;;-----------Begin Email Client--------------

;(require 'mu4e)

;; default

(setq mu4e-maildir       "~/Maildir")
(setq mu4e-drafts-folder "/[Gmail].Drafts")
(setq mu4e-sent-folder   "/[Gmail].Sent Mail")
(setq mu4e-trash-folder  "/[Gmail].Trash")

;; don't save messages to Sent Messages
(setq mu4e-sent-messages-behavior 'delete)

;; mu4e shortcuts
;; switch to Inbox with ji
;; move the email to ma
(setq mu4e-maildir-shortcuts
      '( ("/INBOX"               .?i)
	 ("/[Gmail].Sent Mail"   .?s)
	 ("/[Gmail].Trash"       .?t)
	 ("/[Gmail].All Mail"    .?a)))

;; allow for updating the email using 'U' in the main window
(setq mu4e-get-mail-command "offlineimap")

;; personal info

(setq
 user-mail-address "aaronarlotti@gmail.com"
 user-full-name    "Aaron Arlotti")

;; sending email
(require 'smtpmail)
(setq message-send-mail-function 'smtpmail-send-it
      smtpmail-stream-type 'starttls
      smtpmail-default-smtp-server "smtp.gmail.com"
      smtpmail-smtp-server "smtp.gmail.com"
      smtpmail-smtp-service 587)

;; remove message buffer
(setq message-kill-buffer-on-exit t)

;; view emails in HTML format
(setq mu4e-view-prefer-html t)


(setq browse-url=browser-function 'w3m-browse-url)
(autoload 'w3m-browse-url "w3m" "Ask a www browser to show a URL." t)
; keyboard shortcut
(global-set-key "\C-xm" 'browse-url-at-point)
(setq w3m-use-cookies t)


;; helm - fuzzy lookups
(require 'helm-config)
(global-set-key (kbd "M-x") 'helm-M-x)


;;------END MAIL CLIENT----------------------
;;-------------------------------------------


;;------ORG MODE-----------------------------

;; org-bullets
(require 'org-bullets)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))


;; Org Mode
(find-file "~/Dropbox/ORG/AaronArlotti.org")   ;open the default org file automatically
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-cb" 'org-iswitchb)

(setq org-todo-keywords
       '((sequence "TODO" "VM" "|" "CH" "GD" "DONE")))

;; org-capture-templates
(setq org-capture-templates
      '(("c" "Sandbox CALL" entry (file+datetree "~/Dropbox/ORG/SandboxLog.org")
	 "* TODO  %?\nSCHEDULED: %T" :clock-in t)
	("s" "Sandbox TODO" entry (file+headline "~/Dropbox/ORG/SandboxLog.org" "URGENT TASKS")
	  "* TODO %?\n\%u" t)
        ("p" "Personal TODO" entry (file+headline "~/Dropbox/ORG/AaronArlotti.org" "PERSONAL TASKS")
	  "* TODO %?" t)
	))

;; org-bullets. Nicer bullets for org-mode
(require 'org-bullets)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))

;; add files to org agenda
(setq org-agenda-files '("C:\\Users\\Aaron\\Dropbox\\ORG"))

;; org-ac - autocomplete for org
(require 'org-ac)
(org-ac/config-default)

;; Split vertical by default
(setq split-height-threshold nil)
(setq split-width-threshold 0)

;;-------------------------------------------
;;------DO NOT EDIT BELOW THIS LINE----------
;;-------------------------------------------

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(Linum-format "%7i ")
 '(ansi-color-faces-vector
   [default bold shadow italic underline bold bold-italic bold])
 '(ansi-color-names-vector
   ["#3f3f3f" "#ea3838" "#7fb07f" "#fe8b04" "#62b6ea" "#e353b9" "#1fb3b3" "#d5d2be"])
 '(blink-cursor-mode nil)
 '(custom-enabled-themes (quote (afternoon)))
 '(custom-safe-themes
   (quote
    ("a0feb1322de9e26a4d209d1cfa236deaf64662bb604fa513cca6a057ddf0ef64" "28ec8ccf6190f6a73812df9bc91df54ce1d6132f18b4c8fcc85d45298569eb53" "04dd0236a367865e591927a3810f178e8d33c372ad5bfef48b5ce90d4b476481" "ab04c00a7e48ad784b52f34aa6bfa1e80d0c3fcacc50e1189af3651013eb0d58" "bc40f613df8e0d8f31c5eb3380b61f587e1b5bc439212e03d4ea44b26b4f408a" "f0d8af755039aa25cd0792ace9002ba885fd14ac8e8807388ab00ec84c9497d7" "5999e12c8070b9090a2a1bbcd02ec28906e150bb2cdce5ace4f965c76cf30476" "e97dbbb2b1c42b8588e16523824bc0cb3a21b91eefd6502879cf5baa1fa32e10" "dc54983ec5476b6187e592af57c093a42790f9d8071d9a0163ff4ff3fbea2189" default)))
 '(diary-entry-marker (quote font-lock-variable-name-face))
 '(emms-mode-line-icon-image-cache
   (quote
    (image :type xpm :ascent center :data "/* XPM */
static char *note[] = {
/* width height num_colors chars_per_pixel */
\"    10   11        2            1\",
/* colors */
\". c #1fb3b3\",
\"# c None s None\",
/* pixels */
\"###...####\",
\"###.#...##\",
\"###.###...\",
\"###.#####.\",
\"###.#####.\",
\"#...#####.\",
\"....#####.\",
\"#..######.\",
\"#######...\",
\"######....\",
\"#######..#\" };")))
 '(fci-rule-character-color "#202020")
 '(fci-rule-color "#222222")
 '(fringe-mode 4 nil (fringe))
 '(gnus-logo-colors (quote ("#2fdbde" "#c0c0c0")))
 '(gnus-mode-line-image-cache
   (quote
    (image :type xpm :ascent center :data "/* XPM */
static char *gnus-pointer[] = {
/* width height num_colors chars_per_pixel */
\"    18    13        2            1\",
/* colors */
\". c #1fb3b3\",
\"# c None s None\",
/* pixels */
\"##################\",
\"######..##..######\",
\"#####........#####\",
\"#.##.##..##...####\",
\"#...####.###...##.\",
\"#..###.######.....\",
\"#####.########...#\",
\"###########.######\",
\"####.###.#..######\",
\"######..###.######\",
\"###....####.######\",
\"###..######.######\",
\"###########.######\" };")))
 '(hl-sexp-background-color "#1c1f26")
 '(inhibit-startup-screen t)
 '(main-line-color1 "#1E1E1E")
 '(main-line-color2 "#111111")
 '(main-line-separator-style (quote chamfer))
 '(org-agenda-files
   (quote
    ("~/Dropbox/ORG/AaronArlotti.org" "~/Dropbox/ORG/SandboxLog.org")))
 '(powerline-color1 "#1E1E1E")
 '(powerline-color2 "#111111")
 '(vc-annotate-background "#222222")
 '(vc-annotate-color-map
   (quote
    ((20 . "#db4334")
     (40 . "#ea3838")
     (60 . "#abab3a")
     (80 . "#e5c900")
     (100 . "#fe8b04")
     (120 . "#e8e815")
     (140 . "#3cb370")
     (160 . "#099709")
     (180 . "#7fb07f")
     (200 . "#32cd32")
     (220 . "#8ce096")
     (240 . "#528d8d")
     (260 . "#1fb3b3")
     (280 . "#0c8782")
     (300 . "#00aff5")
     (320 . "#62b6ea")
     (340 . "#94bff3")
     (360 . "#e353b9"))))
 '(vc-annotate-very-old-color "#e353b9"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
