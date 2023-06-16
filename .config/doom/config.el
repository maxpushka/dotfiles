;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "John Doe"
      user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Iosevka" :size 12 :weight 'semi-light)
;;     doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;;(setq doom-theme 'doom-one)
(setq doom-theme 'doom-xcode)
(setq doom-font (font-spec :family "IosevkaTerm Nerd Font" :size 14 :weight 'normal))

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; Enable continuous scroll for PDF
(setq doc-view-continuous t)

;; Automatically select the currently opened file
(setq treemacs-follow-mode t)

;; Enable relative line numbers
(setq display-line-numbers-type 'relative)

(custom-set-variables
 '(mac-alternate-modifier       'meta)
 '(ns-alternate-modifier        'meta)
 '(mac-command-modifier         'control)
 '(ns-command-modifier          'control)
 '(mac-right-alternate-modifier 'meta)
 '(ns-right-alternate-modifier  'meta)
 '(mac-right-command-modifier   'super)
 '(ns-right-command-modifier    'super))

;; Disable buffering delay to increase apparent performance of vterm
(setq vterm-timer-delay nil)

(map! :leader
      :desc "Find file in project"
      "f p" #'project-find-file)

(after! flycheck
  (require 'flycheck-google-cpplint)
  (setq flycheck-c/c++-googlelint-executable "cpplint"
        flycheck-c/c++-cppcheck-executable "cppcheck"
        flycheck-python-pylint-executable "pylint"
        flycheck-r-lintr-executable "R"
        flycheck-pylintrc "~/.pylintrc"
        flycheck-cppcheck-standards '("c++20"))
  (flycheck-add-next-checker 'c/c++-cppcheck '(warning . c/c++-googlelint)))

(setq lsp-clients-clangd-args
          '("-j=4"
            "--background-index"
            "--clang-tidy"
            "--completion-style=bundled"
            "--pch-storage=memory"
            "--header-insertion=never"
            "--header-insertion-decorators=0"))

(add-hook! 'lsp-after-initialize-hook
  (run-hooks (intern (format "%s-lsp-hook" major-mode))))

(defun my-c++-linter-setup ()
  (flycheck-add-next-checker 'lsp 'c/c++-googlelint))
(add-hook 'c++-mode-lsp-hook #'my-c++-linter-setup)

(defun my-python-linter-setup ()
  (flycheck-add-next-checker 'lsp 'python-pylint))
(add-hook 'python-mode-lsp-hook #'my-python-linter-setup)

(defun my-r-linter-setup ()
   (flycheck-add-next-checker 'lsp 'r-lintr))
(add-hook 'R-mode-lsp-hook #'my-r-linter-setup)

(use-package! flycheck-clang-analyzer
  :init
  (require 'flycheck-clang-analyzer)
  (flycheck-clang-analyzer-setup))
