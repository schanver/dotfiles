(setq user-full-name "schanver"
      user-mail-address "schanver@proton.me")

(setq doom-theme 'doom-dracula)
(setq display-line-numbers-type t)
(setq doom-font (font-spec :family "IosevkaNFM" :size 24))
(setq org-hide-emphasis-markers t)
(setq-default evil-conceal-level 3)

(use-package! org-modern
  :hook (org-mode . org-modern-mode)
  :config
  (setq org-modern-block-fringe nil
        org-modern-block-name '("⎡" . "⎦") ;; visual replacement for #+begin_ and #+end_
        org-modern-hide-stars t
        org-modern-star '("★" "•" "◦" "‣")))

(use-package! treemacs-projectile
  :after (treemacs projectile))
(map! "C-t" #'treemacs)

(use-package! org-fragtog
  :ensure t)
(add-hook 'org-mode-hook 'org-fragtog-mode)

(use-package! org-alert
  :ensure t)

(setq org-download-image-dir "~/org/roam/attachments/")

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
          ("b" "books" plain "%?"
           :target (file+head "books/${slug}.org"
                              "#+title: ${title}\n#+filetags: books\n\n")
           :unnarrowed t)
          ("p" "programming" plain "%?"
           :target (file+head "programming/${slug}.org"
                              "#+title: ${title}\n#+filetags: programming\n\n")
           :unnarrowed t)
          ("w" "writings" plain "%?"
           :target (file+head "writings/${slug}.org"
                              "#+title: ${title}\n#+filetags: writings\n\n")
           :unnarrowed t)
          ("u" "uni" plain "%?"
           :target (file+head "uni/${slug}.org" "#+title: ${title}\n#+filetags: uni\n")
           :unnarrowed t)))

  ;; Enable Org-roam database autosync
  (org-roam-db-autosync-mode))

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

(after! org-roam
  (map! :leader
        :prefix "n r"
        :desc "Find node"        "f" #'org-roam-node-find
        :desc "Insert node"      "i" #'org-roam-node-insert
        :desc "Add tag"          "t" #'org-roam-tag-add
        :desc "Remove tag"       "T" #'org-roam-tag-remove
        :desc "Show graph"       "g" #'org-roam-ui-mode
        :desc "Toggle buffer"    "l" #'org-roam-buffer-toggle
        :desc "Capture template" "c" #'org-roam-capture
        ;; Updated dailies commands
        :desc "Today"            "d" #'org-roam-dailies-capture-today
        :desc "Yesterday"        "y" #'org-roam-dailies-capture-yesterday
        :desc "Tomorrow"         "m" #'org-roam-dailies-capture-tomorrow
        :desc "Daily directory"  "D" #'org-roam-dailies-find-directory
        ;; Alternative commands if the above don't work
        :desc "Daily today"      "j" #'org-roam-dailies-goto-today
        :desc "Daily date"       "J" #'org-roam-dailies-goto-date
        ))

(setq org-download-image-dir "~/Pictures/doom/")
(defun my/org-agenda-deadline-countdown ()
  (let* ((tags '("klausur" "aufgabe"))
         (today (current-time))
         (max-days 30)
         (items '()))
(org-map-entries
     (lambda ()
       (let ((tags-list (org-get-tags))
             (deadline (org-entry-get nil "DEADLINE")))
         (when (and deadline (cl-intersection tags tags-list :test #'string=))
           (let* ((deadline-time (org-time-string-to-time deadline))
                  (days-left (floor (/ (float-time (time-subtract deadline-time today)) 86400))))
             (when (and (>= days-left 0) (<= days-left max-days))
               (let ((heading (org-get-heading t t t t)))
                 (push (format "%s in %d day(s)" heading days-left) items)))))))
     nil 'agenda)
    (if items
        (concat "⏳ Deadlines (next 30 days):\n" (string-join (sort items #'string<) "\n"))
      "No upcoming deadlines within 30 days for exams or assignments.")))
(setq org-agenda-custom-commands
      '(("w" "Weekly Agenda with Countdown"
         ((agenda "" ((org-agenda-span 'week)
                      (org-agenda-overriding-header
                       (concat (my/org-agenda-deadline-countdown) "\n\n"))))
          (alltodo "")))))
(after! org
  (setq org-habit-graph-column 60
  org-habit-preceeing-days 7
  org-habit-following-days 7))
(setq alert-default-style 'libnotify)
(setq org-alert-interval 300
      org-alert-notify-cutoff 10
      org-alert-notify-after-event-cutoff 10)

(setq org-format-latex-options
      (plist-put org-format-latex-options :scale 2.0))

(map! :leader
      :desc "Open the terminal" "v" #'vterm)

(after! org
  ;; Define the countdown function
(defun my/org-agenda-deadline-countdown ()
  "Return a string listing upcoming deadlines for klausur/aufgabe tasks in the next 30 days."
  (let* ((tags '("klausur" "aufgabe"))
         (today (current-time))
         (max-days 30)
         (items '()))
    (org-map-entries
     (lambda ()
       (let ((tags-list (org-get-tags))
             (deadline (org-entry-get nil "DEADLINE")))
         (when (and deadline (cl-intersection tags tags-list :test #'string=))
           (let* ((deadline-time (org-time-string-to-time deadline))
                  (days-left (floor (/ (float-time (time-subtract deadline-time today)) 86400))))
             (when (and (>= days-left 0) (<= days-left max-days))
               (let ((heading (org-get-heading t t t t)))
                 (push (cons days-left heading) items)))))))
     nil 'agenda)
    (if items
        (concat
         "⏳ Deadlines (next 30 days):\n"
         (string-join
          (mapcar (lambda (entry)
                    (format "%s in %d day(s)" (cdr entry) (car entry)))
                  (sort items (lambda (a b) (< (car a) (car b)))))
          "\n"))
      "No upcoming deadlines within 30 days for exams or assignments.")))

(setq org-agenda-custom-commands
      '(("X" "Daily Agenda"
         agenda ""
         ((org-agenda-span 'day)
          (org-agenda-start-day nil)
          (org-agenda-remove-tags t)
          (ps-number-of-columns 2)
          (ps-landscape-mode t))
         ("~/.agenda"))


        ("w" "Weekly Agenda with Countdown"
         ((agenda ""
                  ((org-agenda-span 'day)
                   (org-agenda-overriding-header
                    (concat (my/org-agenda-deadline-countdown) "\n\n"))))
          (alltodo ""))))))
(defun my/org-days-left ()
  "Return number of days left until DEADLINE or active timestamp, or empty string."
  (let* ((timestamp (or (org-entry-get nil "DEADLINE")
                        (org-entry-get nil "SCHEDULED")
                        (org-get-scheduled-time (point))
                        (org-get-deadline-time (point))))
         (today (current-time)))
    (if timestamp
        (let* ((time (if (stringp timestamp)
                         (org-time-string-to-time timestamp)
                       timestamp))
               (days-left (floor (/ (float-time (time-subtract time today)) 86400))))
          (if (>= days-left 0)
              (format "%d" days-left)
            ""))
      "")))  ;; explicitly return empty string if no timestamp
(after! treemacs
  (map!
        "M-p" #'treemacs))
      "")))

(add-hook 'org-mode-hook 'org-display-inline-images)

(setq org-gcal-client-id "842133277259-41ogj5sdd4ihiklv6mqamltm67i4kpiv.apps.googleusercontent.com"
      org-gcal-client-secret "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"
      org-gcal-file-alist '(("phatih.schanver@gmail.com" . "~/org/gcal.org")))
