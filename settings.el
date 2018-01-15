(use-package autopair
  :if(window-system)
  :ensure t)
  :config
  (autopair-global-mode)

(use-package erc)

(use-package evil
  :config
  (evil-mode 1))

(use-package isend-mode)

(use-package git)

(use-package powerline-center-theme
  :config
  (setq powerline-default-separator 'wave))
