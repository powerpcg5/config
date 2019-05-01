;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; emacs
;; .emacs for GNU Emacs 26.1
;;
;; 2310 Wednesday, 27 March 2019 (EDT) [17982]
;;
;; Austin Kim
;;
;; Modified:
;;   0030 Thursday, 28 March 2019 (EDT) [17983]
;;   1332 Saturday, 30 March 2019 (EDT) [17985]
;;   2019 Tuesday, 2 April 2019 (EDT) [17988]
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Scroll window up/down by one line
(global-set-key (kbd "M-p") (kbd "C-u 1 M-v"))
(global-set-key (kbd "M-n") (kbd "C-u 1 C-v"))

;; Set default window size to 40 lines
(progn (setq initial-frame-alist '((width . 80) (height . 48) (left . 666)
              (tool-bar-lines . 0) (background-color . "#fff7e9"))))
(progn (setq default-frame-alist '((width . 80) (height . 48) (left . 666)
              (tool-bar-lines . 0) (background-color . "#fff7e9"))))

;; Set default font
(add-to-list 'initial-frame-alist '(font . "Menlo-14"))
(add-to-list 'default-frame-alist '(font . "Menlo-14"))

;; Display line and column numbers
(setq line-number-mode t)
(setq column-number-mode t)

;; Indent using spaces (rather than tabs)
(setq-default indent-tabs-mode nil)

;; Unicode hexadecimal input via C-q
(setq read-quoted-char-radix 16)

;; Set indentation to two spaces
(setq c-basic-offset 2)

;; Turn off auto-indentation
(electric-indent-mode 0)
