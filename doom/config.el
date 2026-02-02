(setq user-full-name "schanver"
      user-mail-address "schanver@proton.me")

(setq doom-theme 'doom-gruvbox)
(setq display-line-numbers-type t)
(setq doom-font (font-spec :family "IosevkaTerm Nerd Font Mono" :size 28))
;(add-hook! 'doom-init-ui-hook #'doom-big-font-mode)
(setq org-hide-emphasis-markers t)
(setq-default evil-conceal-level 3)

(use-package! org-modern
  :hook (org-mode . org-modern-mode)
  :config
  (setq org-modern-block-fringe nil
        org-modern-block-name '("⎡" . "⎦") ;; visual replacement for #+begin_ and #+end_
        org-modern-hide-stars nil
        org-modern-star '("★" "•" "◦" "‣")))

(after! treemacs
  (treemacs-project-follow-mode 1)
  (treemacs-follow-mode 1)
  (treemacs-filewatch-mode 1))

(use-package! org-fragtog
  :ensure t)
(add-hook 'org-mode-hook 'org-fragtog-mode)

(use-package! org-alert
  :ensure t)

(setq org-download-image-dir "~/org/roam/attachments/")

(setq org-roam-node-display-template
      (concat (propertize "${tags:30} " 'face '(:foreground "green" :weight bold))
              "${title:*}"))

;; Org-roam configuration
(use-package! org-roam
  :after org
  :config
  (require 'org-roam-dailies)
  (setq org-roam-graph-viewer "firefox"
        org-roam-graph-executable "dot")
  ;; Org-roam directories and database settings
  (setq org-roam-directory "~/org/roam"
        org-roam-dailies-directory "daily/"
        org-roam-completion-everywhere t)

  ;; Org-roam capture templates
  (setq org-roam-capture-templates
        '(
          ("T" "Thought/Fleeting Note" plain
           "%?"
           :target (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
                              "#+title: ${title}\n#+filetags: :thoughts:%^{Topic}:\n#+date: %U\n")
           :unnarrowed t)
          
          ("p" "private" plain "%?"
           :target (file+head "$private/${slug}.org"
                              "#+title: ${title}\n#+filetags: private\n\n")
           :unarrowed nil)

          ("c" "programming" plain "%?"
           :target (file+head "${slug}.org"
                              "#+title: ${title}\n#+filetags: programming\n\n")
           :unnarrowed t)

          ("w" "writings" plain "%?"
           :target (file+head "${slug}.org"
                              "#+title: ${title}\n#+filetags: writings\n\n")
           :unnarrowed t)

          ("u" "university notes" plain "%?"
           :target (file+head "${slug}.org"
                              "#+title: ${title}\n#+filetags: uni\n")
           :unnarrowed t)

          ("m" "modules" plain "%?"
           :target (file+head "${slug}.org"
                              "#+title: ${title}\n#+filetags: uni \n\n* Modulinformation\n** Lehrer:\n** Email:\n** Moodle:\n\n* Termine und Aufgaben\n** Notizen\n")
           :unnarrowed t)
          
          ("t" "Trackers")
          
          ("tb" "Book Entry" plain
           "** ${title}\n:PROPERTIES:\n:STATUS: %^{Status|ON LIST|READING|FINISHED|DROPPED}\n:AUTHOR: %^{Author}\n:GENRE: %^{Genre}\n:PAGES_READ: %^{Pages Read}\n:TOTAL_PAGES: %^{Total Pages}\n:RATING: %^{Rating}\n:ADDED: %U\n:END:\n%?"
           :target (file+head "trackers/book_list.org"
                              "#+title: Books\n#+filetags: :tracker:books:\n\n")
           :unnarrowed t)

          ("tf" "Film Entry" plain
           "** ${title}\n:PROPERTIES:\n:STATUS: %^{Status|WATCHLIST|WATCHED/DROPPED}\n:DIRECTOR: %^{Director}\n:^{}WATCH_DATE: %^{Watch Date}\n:RATING: %^{Rating} \n:ADDED: %U\n:END:\n%?"
           :target (file+head "trackers/film_list.org"
                              "#+title: Films\n#+filetags: :tracker:films:\n\n")
           :unnarrowed t)

          ("ts" "TV Series Entry" plain
           "** ${title}\n:PROPERTIES:\n:STATUS: %^{Status|WATCHLIST|WATCHING|WATCHED|DROPPED| ON HOLD} \n:EPISODES: %^{Total Episodes}\n:WATCHED: %^{Episodes Watched}^{}\n:ADDED: %U\n:END:\n%?"
           :target (file+head "trackers/series_list.org"
                              "#+title: TV Series\n#+filetags: :tracker:series:\n\n")
           :unnarrowed t)

          ("tg" "Game Entry" plain
           "** ${title}\n:PROPERTIES:\n:STATUS: %^{Status|BACKLOG|PLAYING|COMPLETED} \n:PLATFORM: %^{Platform}\n:GENRE: %^{Genre}\n:ADDED: %U\n:END:\n%?"
           :target (file+head "trackers/game_list.org"
                              "#+title: Games\n#+filetags: :tracker:games:\n\n")
           :unnarrowed t)

          ;; Inbox for quick capture
          ("i" "Inbox" plain
           "* TODO %?\n:PROPERTIES:\n:ADDED: %U\n:END:\n"
           :target (file "inbox.org")
           :unnarrowed t)))

  ;; Enable Org-roam database autosync
  (org-roam-db-autosync-mode))

(use-package! websocket
    :after org-roam)
(use-package! org-roam-ui
  :after org-roam
  :commands (org-roam-ui-mode org-roam-ui-open)
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
        :desc "Show graph"       "g" #'org-roam-ui-open
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
      "")))

(add-hook 'org-mode-hook 'org-display-inline-images)

(yas-global-mode 1)

(global-set-key (kbd "C-c z") #'zen-mode)

(require 'org-habit)
(add-to-list 'org-modules 'org-habit)

(setq org-log-into-drawer t)

(setq org-agenda-custom-commands
      '(("d" "Dashboard"
         ((tags "STATUS=\"WATCHLIST\""
                ((org-agenda-overriding-header "🎬 Films to Watch")
                 (org-agenda-files '("~/org/roam/trackers/film_list.org"))
                 (org-agenda-prefix-format "  %-12:c %s")))
          (tags "STATUS=\"READING\"|STATUS=\"ON LIST\""
                ((org-agenda-overriding-header "📚 Books to Read")
                 (org-agenda-files '("~/org/roam/trackers/book_list.org"))
                 (org-agenda-prefix-format "  %-12(org-entry-get nil \"STATUS\") ")))
          (tags "STATUS=\"PLAYING\""
                ((org-agenda-overriding-header "🎮 Games - Currently Playing")
                 (org-agenda-files '("~/org/roam/trackers/game_list.org"))
                 (org-agenda-prefix-format "  %-12(org-entry-get nil \"STATUS\") ")))
          (tags "CATEGORY=\"inbox\""
                ((org-agenda-overriding-header "📥 Inbox")
                 (org-agenda-files '("~/org/roam/inbox.org"))))))))
