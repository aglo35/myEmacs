;; convert tabs to spaces
;; More modes: http://www.emacswiki.org/CategoryModes

;; :PROPERTIES:
;; :ID:       dc89b408-1534-43bd-a4bc-5b4e8f78091a
;; :END:

(defun untab-all ()
  (untabify (point-min)
            (point-max))
  nil)

(defun add-write-contents-hooks-hook ()
  (add-hook 'write-contents-hooks 'untab-all nil t ))

(add-hook 'emacs-lisp-mode-hook     #'add-write-contents-hooks-hook)
(add-hook 'c-mode-common-hook       #'add-write-contents-hooks-hook)
(add-hook 'sh-mode-hook             #'add-write-contents-hooks-hook)
(add-hook 'text-mode-hook           #'add-write-contents-hooks-hook)
(add-hook 'sql-mode-hook            #'add-write-contents-hooks-hook)
(add-hook 'css-mode-hook            #'add-write-contents-hooks-hook)

;; matches *.properties files
(add-hook 'conf-javaprop-mode-hook  #'add-write-contents-hooks-hook)

;; remove trailing whitespace
;; :PROPERTIES:
;; :ID:       53b0fb30-745f-46e6-b19d-7450c65a9e62
;; :END:

(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; disable saving of backups
;; :PROPERTIES:
;; :ID:       aad9560e-1778-4e42-a5c7-4b7f7d0ca973
;; :END:
;; Disable those backup files with ~ suffix, because I keep important
;; files under version control anyway.

(setq make-backup-files nil)

;; Log when a cerain TODO item was finished
;; by Allar
(setq org-log-done 'time)

;; automatically reload files that were changed on disk by another process
;; :PROPERTIES:
;; :ID:       07075c6d-1c4f-4c2a-923b-5000d6d53938
;; :END:

(global-auto-revert-mode t)

;; automatically save edited files
;; :PROPERTIES:
;; :ID:       9655c6d1-9f70-406c-ac12-6fabb3c588ef
;; :END:
;; This prevents accidently leaving edited files open in the background
;; with important unsaved changes, especially when using emacsclient with
;; emacs daemon.

;; Save edited files when Emacs frame looses focus.

(defun save-all ()
    (interactive)
    (save-some-buffers t))

(add-hook 'focus-out-hook 'save-all)

;; Save edited files when Emacs frame is closed.

(defun save-all2 (frame)
    (interactive)
    (save-some-buffers t))

(add-hook 'delete-frame-functions 'save-all2)

;; disable large file warning
;; :PROPERTIES:
;; :ID:       42d49ed4-4971-4d43-ad6d-533a7e2a8b1a
;; :END:
;; Disable messages that look like
;; : foo.bar file is large; really open?'

(setq large-file-warning-threshold nil)

;; make indentation commands use space only (never tab character)
;; :PROPERTIES:
;; :ID:       360562e3-6093-492a-ac71-69418ae16435
;; :END:
;; emacs 23.1, 24.2, default to t

(setq-default indent-tabs-mode nil)

;; keyboard shortcuts to ident/dedent selected region
;; :PROPERTIES:
;; :ID:       96329b02-873f-4e56-a439-2307c298f6cf
;; :END:
;; - Idents/dedents by 4 spaces.
;; - Select text and use keys: <, >

(defun my-indent-region (N)
  (interactive "p")
  (if (use-region-p)
      (progn (indent-rigidly (region-beginning) (region-end) (* N 4))
             (setq deactivate-mark nil))
    (self-insert-command N)))

(defun my-unindent-region (N)
  (interactive "p")
  (if (use-region-p)
      (progn (indent-rigidly (region-beginning) (region-end) (* N -4))
             (setq deactivate-mark nil))
    (self-insert-command N)))

(global-set-key ">" 'my-indent-region)
(global-set-key "<" 'my-unindent-region)

;; do not ask for confirmation when following symlinks
;; :PROPERTIES:
;; :ID:       024f9153-7367-4965-842d-a33b1742d2e0
;; :END:

(setq vc-follow-symlinks t)

;; mouse middle click should paste at text cursor location
;; :PROPERTIES:
;; :ID:       433d6ae7-aa4d-4cc7-9661-01e88aca765f
;; :END:

;; Otherwise, by default it inserts text at mouse click location.

(setq mouse-yank-at-point t)

;; text alignment addons
;; :PROPERTIES:
;; :ID:       e24b5296-7561-43c0-bab8-2996aa14666b
;; :END:
;; + From http://stackoverflow.com/questions/3633120/emacs-hotkey-to-align-equal-signs
;; + Another information: https://gist.github.com/700416
;; + Use rx function http://www.emacswiki.org/emacs/rx

(defun align-to-colon (begin end)
  "Align region to colon (:) signs"
  (interactive "r")
  (align-regexp begin end
                (rx (group (zero-or-more (syntax whitespace))) ":") 1 1 ))

(defun align-to-comma (begin end)
  "Align region to comma signs"
  (interactive "r")
  (align-regexp begin end
                (rx "," (group (zero-or-more (syntax whitespace))) ) 1 1 ))


(defun align-to-equals (begin end)
  "Align region to equal signs"
  (interactive "r")
  (align-regexp begin end
                (rx (group (zero-or-more (syntax whitespace))) "=") 1 1 ))

(defun align-to-hash (begin end)
  "Align region to hash ( => ) signs"
  (interactive "r")
  (align-regexp begin end
                (rx (group (zero-or-more (syntax whitespace))) "=>") 1 1 ))

;; work with this
(defun align-to-comma-before (begin end)
  "Align region to equal signs"
  (interactive "r")
  (align-regexp begin end
                (rx (group (zero-or-more (syntax whitespace))) ",") 1 1 ))

;; set emacs theme
;; :PROPERTIES:
;; :ID:       71b64629-1da9-4fd9-9155-d5f585a91cbb
;; :END:
;; Register custom Emacs themes directory.

(add-to-list 'custom-theme-load-path "~/.emacs.d/elpa/dracula-theme-20170308.2107")

;; Load nice looking color theme.

(load-theme 'dracula t)

;; enable current line highlighting
;; :PROPERTIES:
;; :ID:       32098c70-55d7-47cd-bcf3-4c6050e21ae9
;; :END:
;; Enable highlighting

(global-hl-line-mode 1)

;; Ensure that no underlines are used for current line highlight.

(set-face-attribute hl-line-face nil :underline nil)

;; show matching parenthesis
;; :PROPERTIES:
;; :ID:       598e7a70-9ef4-4cae-9ef2-b21eea7843da
;; :END:

(show-paren-mode 1)

;; IMenu
;; :PROPERTIES:
;; :ID:       3fde28ce-f668-4269-b819-38917f5707f7
;; :END:
;; Always show IMenu.

(add-hook 'my-mode-hook 'imenu-add-menubar-index)

(defun try-to-add-imenu ()
  (condition-case nil
      (imenu-add-to-menubar "IMenu")
    (error
     nil)))
(add-hook 'font-lock-mode-hook 'try-to-add-imenu)

;; Make IMenu entries ordered alphabetically.

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("d9129a8d924c4254607b5ded46350d68cc00b6e38c39fc137c3cfb7506702c12" default)))
 '(imenu-sort-function (quote imenu--sort-by-name))
 '(inhibit-startup-screen t)
 '(paradox-github-token t)
 '(tab-stop-list
   (quote
    (4 8 12 16 20 24 28 32 36 40 44 48 52 56 60 64 68 72 76 80 84 88 92 96 100 104 108 112 116 120))))

;; show opened file in window title
;; :PROPERTIES:
;; :ID:       fca36bba-50d2-4fdc-b7c4-67e0191ef6df
;; :END:
;; Show only file name (no path) in window title.

(setq-default frame-title-format "%b")

;; disable annoying notification beeps
;; :PROPERTIES:
;; :ID:       2fa10617-ba88-4315-82af-edbc98a32991
;; :END:

(setq ring-bell-function 'ignore)

;; left-side navigation menu
;; :PROPERTIES:
;; :ID:       91cf1483-8d0a-4a7f-ba56-e6361e55bed8
;; :END:

(eval-after-load "tree-widget"
  '(if (boundp 'tree-widget-themes-load-path)
       (add-to-list 'tree-widget-themes-load-path "~/.emacs.d/extensions/")))

(autoload 'imenu-tree "imenu-tree" "Imenu tree" t)
(autoload 'tags-tree "tags-tree" "TAGS tree" t)

;; disable top toolbar
;; :PROPERTIES:
;; :ID:       14ca0b2c-319b-4912-ba69-24ce795971f4
;; :END:

(tool-bar-mode -1)

;; enable upcase-region / downcase-region commands
;; :PROPERTIES:
;; :ID:       9c155106-4d39-4f55-8568-f9492a76050a
;; :END:
;; For mysterious reasons these commands are disabled by default because
;; they are unfriendly for beginners. Here we enable them anyway.

;; Commands convert selected region into upper or lower case.

(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)

;; enable scroll commands
;; :PROPERTIES:
;; :ID:       7bc58818-7795-4fcb-8177-823b585aaa94
;; :END:
;; For mysterious reasons these commands are disabled by default because
;; they are unfriendly for beginners. Here we enable them anyway.

(put 'scroll-left 'disabled nil)
(put 'scroll-right 'disabled nil)

;; enable horizontal scrolling with mouse
;; :PROPERTIES:
;; :ID:       3dfcffc7-7caa-48ba-8006-5bd6fe83e176
;; :END:

(global-set-key (kbd "<mouse-7>") '(lambda ()
   (interactive)
   (scroll-left 4)))

(global-set-key (kbd "<mouse-6>") '(lambda ()
   (interactive)
   (scroll-right 4)))

;; enable manually downloaded and installed extensions
;; :PROPERTIES:
;; :ID:       e6559a43-499b-4ba8-ac3a-939d4fa19bc7
;; :END:
;; Register custom Emacs extensions directory. I downloaded there various
;; emacs extensions from the internet.

(add-to-list 'load-path "~/.emacs.d/extensions/")

;; Load some useful extensions from that directory.

;;(require 'elisp-format)     ;; Load extension to format elisp code.
;;(require 'json-reformat)
;;(require 'puppet-mode)
;;(require 'rainbow-mode)     ;; show colors by color codes
;;(require 'bind-key)         ;; utility to simplify key binding
;;(require 'php-mode)         ;; major made for edinig PHP files

;; web mode
;; :PROPERTIES:
;; :ID:       9ea3d984-70a8-470e-808f-8fd1b6890130
;; :END:
;; + http://web-mode.org/

(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))

;; enable additional package repositories
;; :PROPERTIES:
;; :ID:       b449aaad-355b-4d3e-ba7c-e97d0d3f7c57
;; :END:

(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")
                         ("melpa" . "http://melpa.org/packages/")))

;; keyboard shortcut F5: full text search across all agenda files
;; :PROPERTIES:
;; :ID:       11a1a6e2-cf2b-499f-b18a-5ba0c077129c
;; :END:

(global-set-key (kbd "<f5>") 'org-search-view)

;; keyboard shortcut F6: publish ORG document as HTML file
;; :PROPERTIES:
;; :ID:       8b7943f1-7e50-4884-ac99-7e26dd7ec551
;; :END:

(global-set-key (kbd "<f6>") 'org-html-export-to-html)

;; keyboard shortcut F7: produce program source code from ORG document (tangle)
;; :PROPERTIES:
;; :ID:       751efc3b-a479-4c0e-8480-a4152ce9247c
;; :END:

(global-set-key (kbd "<f7>") 'org-babel-tangle)

;; recursively load org/agenda documents into RAM
;; :PROPERTIES:
;; :ID:       9dbca967-f919-40a5-8da1-aa8e5f763e3d
;; :END:
;; In order to
;; + use instant full text search over org mode documents
;; + be able to display aggredated day/week agendas and TODO lists
;; + navigate between org documents using UUID links
;; + ...
;; emacs needs to parse all org mode files after startup and before these
;; features are used.


;; Recursively find .org files in provided directory.

(defun sa-find-org-file-recursively (directory &optional filext)
  "Return .org and .org_archive files recursively from DIRECTORY.
If FILEXT is provided, return files with extension FILEXT instead."
  ;; FIXME: interactively prompting for directory and file extension
  (let* (org-file-list
         (case-fold-search t)           ; filesystems are case sensitive
         (file-name-regex "^[^.#].*")   ; exclude .*
         (filext (if filext filext "org$\\\|org_archive"))
         (fileregex (format "%s\\.\\(%s$\\)" file-name-regex filext))
         (cur-dir-list (directory-files directory t file-name-regex)))
    ;; loop over directory listing
    (dolist (file-or-dir cur-dir-list org-file-list) ; returns org-file-list
      (cond
       ((file-regular-p file-or-dir) ; regular files
        (if (string-match fileregex file-or-dir) ; org files
            (add-to-list 'org-file-list file-or-dir)))
       ((file-directory-p file-or-dir)
        (dolist (org-file (sa-find-org-file-recursively file-or-dir filext)
                          org-file-list) ; add files found to result
          (add-to-list 'org-file-list org-file)))))))

;; visual tweaks
;; :PROPERTIES:
;; :ID:       3131aad1-95f2-47cb-862f-f01cce97de6d
;; :END:
;; Use indentation to make org-mode file structure more visible.

(setq org-startup-indented t)

;; Remove leading stars for less visual garbage.

(setq org-hide-leading-stars t)

;; I use underscores "_" a lot in variable/parameter names. I don't want
;; those to be formatted as subscript.

(setq org-export-with-sub-superscripts nil)

;; Use beautiful dark theme for HTML exported files

(setq org-html-head-extra (concat "<link rel=\"stylesheet\" type=\"text/css\" href=\"http://thomasf.github.io/solarized-css/solarized-dark.min.css\" />"))

;; use UUID based document hyperlinks
;; :PROPERTIES:
;; :ID:       c266395e-0dcb-4bbe-9016-fe9da951f788
;; :END:
;; Enable linking between org documents using global unique ID's that
;; will be automatically generated and inserted on demand.

;; UUID is awesome because you can rename file or even headings within
;; file but link will remain working.

(require 'org-id)
(setq org-id-link-to-org-use-id t)

;; + Map keyboard combination C-c l to store link to current location.
;; + Afterwards keyboard shortcut C-c C-l inserts stored link into
;;   desired location within document.

;; (bind-key "C-c l" 'org-store-link)

;; org-mode/babel customizations
;; :PROPERTIES:
;; :ID:       d3a738b2-4298-41b2-879d-66e936624dc7
;; :END:

;; Do syntax highlighting for code blocks embedded in org documents..

(setq org-src-fontify-natively t)

;; integration of various programming languages
;; :PROPERTIES:
;; :ID:       bfba10ad-bcb6-43f9-b3a3-80a573174f0b
;; :END:
;; This way syntax highlighting will work for embedded source code
;; snippets right from the org-mode document.

(org-babel-do-load-languages
 'org-babel-load-languages
 '((R . t)
   (ditaa . t)
   (dot . t)
   (emacs-lisp . t)
   (gnuplot . t)
   (haskell . t)
   (ocaml . t)
   (python . t)
   (ruby . t)
   (screen . t)
   (sh . t)
   (sql . t)
   (sqlite . t)))

;; graphviz integration
;; :PROPERTIES:
;; :ID:       949cb074-bf9e-494f-9dbc-0d7c354b00d6
;; :END:
;; Register proper major mode for editing embedded grophviz source code
;; blocks.

(add-to-list 'org-src-lang-modes (quote ("dot" . graphviz-dot)))

;; Set indent width to 4 spaces.

(setq graphviz-dot-indent-width 4)

;; disable security confirmation for executing embedded code (WARNING!)
;; :PROPERTIES:
;; :ID:       4709787d-128d-49cb-8192-607e62158f83
;; :END:
;; Warning! Confirmation is for security purposes. Do not use this
;; setting when working with untrusted documents.

;; Otherwise constant confirmations are annoying.

;; Enable prompt-free code running:

(setq org-confirm-babel-evaluate nil        ;; for running code blocks
      org-confirm-elisp-link-function nil   ;; for elisp links
      org-confirm-shell-link-function nil)  ;; for shell links

;; miscellaneous
;; :PROPERTIES:
;; :ID:       e8706479-d51c-4480-8222-9c46b58cc631
;; :END:

;; Include additional personalized settings from another file.

;; (load "~/.emacs.d/my.init.el")



(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
