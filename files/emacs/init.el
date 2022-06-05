(require 'org)

(org-babel-tangle-file (expand-file-name "init-org.org" user-emacs-directory)
                       (expand-file-name "init-org.el" user-emacs-directory))
(load (expand-file-name "init-org.el" user-emacs-directory))
