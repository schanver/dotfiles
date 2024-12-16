
;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "schanver"
       user-mail-address "schanver@proton.me")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-gruvbox)

;;(setq doom-big-font (font-spec :family "Hack" :size 25))
;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
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

;; Enable treemacs integration with projectile
(use-package! treemacs-projectile
  :after (treemacs projectile))

;; Automatically enable big font mode after startup
;;(add-hook 'window-setup-hook #'doom-big-font-mode)


;; Enable org-alert for notifications
(use-package! org-alert
  :ensure t)
;; Org-roam node display customization
(setq org-roam-node-display-template
      (concat "${title:*} "
              (propertize "${tags:*}" 'face '(:foreground "yellow" :weight bold))))

;; Org-roam configuration
(use-package! org-roam
  :after org
  :config
 (setq org-roam-graph-viewer "firefox"
       org-roam-graph-executable "dot")
  ;; Org-roam directories and database settings
  (setq org-roam-directory "~/org/roam"
        org-roam-dailies-directory "daily/"
        org-roam-completion-everywhere t)

  ;; Org-roam capture templates
  (setq org-roam-capture-templates
        '(("d" "default" plain "%?"
           :target (file+head "${slug}.org"
                              "#+title: ${title}\n#+date: %U\n\n")
           :unnarrowed t)
          ("b" "books" plain "* About\n - Author: ${author}\n -Total Pages: ${Total Pages}\n -Start Date: %?  "
           :target (file+head "books/${slug}.org"
                              "#+title: ${title}\n#+filetags: books\n\n")
           :unnarrowed t)
          ("s" "series" plain "* About\n - Director: \n - Total Episodes: \n - Personal Rating:\n"
           :target (file+head "series/${slug}.org"
                              "#+title: ${title}\n#+filetags: series\n\n")
           :unnarrowed t)
          ("w" "writings" plain "%?"
           :target (file+head "writings/${slug}.org"
                              "#+title: ${title}\n#+filetags: writings\n\n")
           :unnarrowed t)
          ("u" "uni" plain "%?"
           :target (file+head "uni/${slug}.org"
                              "#+title: ${title}\n#+filetags: uni\n\n")
           :unnarrowed t)))

  ;; Enable Org-roam database autosync
  (org-roam-db-autosync-mode))

;; Org-roam UI for visualizing the graph
(use-package! websocket
    :after org-roam)
(use-package! org-roam-ui
  :after org-roam
  :hook (org-roam-mode . org-roam-ui-mode)
  :config
  (setq org-roam-ui-sync-theme t
        org-roam-ui-follow t
        org-roam-ui-update-on-save t
        org-roam-ui-open-on-start t))

;; Keybindings for Org-roam
(map! :leader
      :prefix "n r"
      :desc "Find node"        "f" #'org-roam-node-find
      :desc "Insert node"      "i" #'org-roam-node-insert
      :desc "Add tag"          "t" #'org-roam-tag-add
      :desc "Remove tag"       "T" #'org-roam-tag-remove
      :desc "Show graph"       "g" #'org-roam-ui-mode
      :desc "Toggle buffer"    "l" #'org-roam-buffer-toggle
      :desc "Capture template" "c" #'org-roam-capture
      ;; Daily notes
      :desc "Today"            "d" #'org-roam-dailies-capture-today
      :desc "Yesterday"        "y" #'org-roam-dailies-capture-yesterday
      :desc "Tomorrow"         "m" #'org-roam-dailies-capture-tomorrow
      :desc "Daily directory"  "D" #'org-roam-dailies-find-directory)

(map! :leader
      :desc "Open the terminal" "v" #'vterm)
