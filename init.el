
;;; This file bootstraps the configuration, which is divided into
;;; a number of other files.

(let ((minver 23))
  (unless (>= emacs-major-version minver)
    (error "Your Emacs is too old -- this config requires v%s or higher" minver)))

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))
(require 'init-benchmarking) ;; Measure startup time

(defconst *spell-check-support-enabled* nil) ;; Enable with t if you prefer
(defconst *is-a-mac* (eq system-type 'darwin))

;;----------------------------------------------------------------------------
;; Bootstrap config
;;----------------------------------------------------------------------------
(require 'init-compat)
(require 'init-utils)
(require 'init-site-lisp) ;; Must come before elpa, as it may provide package.el
(require 'init-elpa)      ;; Machinery for installing required packages
(require 'init-exec-path) ;; Set up $PATH

;;----------------------------------------------------------------------------
;; Load configs for specific features and modes
;;----------------------------------------------------------------------------

(require-package 'wgrep)
(require-package 'project-local-variables)
(require-package 'diminish)
(require-package 'scratch)
(require-package 'mwe-log-commands)

;; (require 'init-frame-hooks)
;; (require 'init-xterm)
(require 'init-themes)
;; (require 'init-osx-keys)
(require 'init-gui-frames)
(require 'init-proxies)
(require 'init-dired)
(require 'init-isearch)
(require 'init-uniquify)
(require 'init-ibuffer)
(require 'init-flycheck)

(require 'init-recentf)
(require 'init-ido)
(require 'init-hippie-expand)
(require 'init-auto-complete)
(require 'init-windows)
(require 'init-sessions)
(require 'init-fonts)
(require 'init-mmm)

(require 'init-editing-utils)

;; (require 'init-darcs)
(require 'init-git)

(require 'init-crontab)
;; (require 'init-textile)
(require 'init-markdown)
(require 'init-csv)
;; (require 'init-erlang)
(require 'init-javascript)
(require 'init-php)
(require 'init-org)
;(require 'init-nxml)
(require 'init-css)
;(require 'init-haml)
(require 'init-python-mode)
;(require 'init-haskell)
;(require 'init-ruby-mode)
;(require 'init-rails)
(require 'init-sql)

(require 'init-paredit)
(require 'init-lisp)
(require 'init-slime)
(require 'init-clojure)
(require 'init-common-lisp)

(when *spell-check-support-enabled*
  (require 'init-spelling))

(require 'init-marmalade)
(require 'init-misc)

(require 'init-dash)
(require 'init-ledger)
;; Extra packages which don't require any configuration

(require-package 'gnuplot)
;; (require-package 'lua-mode)
(require-package 'htmlize)
(require-package 'dsvn)
(when *is-a-mac*
  (require-package 'osx-location))
(require-package 'regex-tool)

;;----------------------------------------------------------------------------
;; Allow access from emacsclient
;;----------------------------------------------------------------------------
;; (require 'server)
;; (unless (server-running-p)
;;  (server-start))


;;----------------------------------------------------------------------------
;; Variables configured via the interactive 'customize' interface
;;----------------------------------------------------------------------------
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))


;;----------------------------------------------------------------------------
;; Allow users to provide an optional "init-local" containing personal settings
;;----------------------------------------------------------------------------
(when (file-exists-p (expand-file-name "init-local.el" user-emacs-directory))
  (error "Please move init-local.el to ~/.emacs.d/lisp"))
(require 'init-local nil t)


;;----------------------------------------------------------------------------
;; Locales (setting them earlier in this file doesn't work in X)
;;----------------------------------------------------------------------------
(require 'init-locales)

(add-hook 'after-init-hook
          (lambda ()
            (message "init completed in %.2fms"
                     (sanityinc/time-subtract-millis after-init-time before-init-time))))

;; ---- Tern
(add-hook 'js-mode-hook (lambda () (tern-mode t)))
(eval-after-load 'tern
   '(progn
      (require 'tern-auto-complete)
      (tern-ac-setup)))
;; -- End tern

;; (global-set-key [(control p)] 'simp-project-find-file)
(projectile-global-mode)
(setq projectile-enable-caching t)
(global-set-key [(control p)] 'projectile-find-file)


(setq ring-bell-function #'ignore)
(provide 'init)
;; (disable-paredit-mode)

;; (global-set-key "\C-c" 'comment-or-uncomment-region)

(global-set-key (kbd "C-x ;") 'comment-or-uncomment-region)
(global-set-key [C-tab] 'other-window)

;; R shortcuts
;; ESS Mode (.R file)
(define-key ess-mode-map "\C-e" 'ess-eval-line-and-step)
(define-key ess-mode-map "\C-p" 'ess-eval-function-or-paragraph-and-step)
(define-key ess-mode-map "\C-r" 'ess-eval-region)

;; iESS Mode (R console)
(define-key inferior-ess-mode-map "\C-u" 'comint-kill-input)
(define-key inferior-ess-mode-map "\C-w" 'backward-kill-word)
(define-key inferior-ess-mode-map "\C-a" 'comint-bol)
(define-key inferior-ess-mode-map [home] 'comint-bol)

;; Comint Mode (R console as well)
(define-key comint-mode-map "\C-e" 'comint-show-maximum-output)
(define-key comint-mode-map "\C-r" 'comint-show-output)
(define-key comint-mode-map "\C-o" 'comint-kill-output)
(setq-default indent-tabs-mode nil)
(setq-default tab-width 2)

(add-hook 'ess-mode-hook
 '(lambda()
       (setq indent-tabs-mode nil
                            tab-width 2)))



;; Local Variables:
;; coding: utf-8
;; no-byte-compile: t
;; End:
