(setq vc-follow-symlinks t)

(when (file-newer-than-file-p (expand-file-name "init-org.org" user-emacs-directory)
                              (expand-file-name "init-org.elc" user-emacs-directory))
  (require 'org)
  (org-babel-tangle-file (expand-file-name "init-org.org" user-emacs-directory)
                         (expand-file-name "init-org.el" user-emacs-directory))
  (byte-compile-file (expand-file-name "init-org.el" user-emacs-directory)))
(load (expand-file-name "init-org.elc" user-emacs-directory))
