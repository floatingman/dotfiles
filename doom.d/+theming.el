;;; private/floatingman/+theming -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2021 Daniel Newman
;;
;; Author: Daniel Newman <http://github/dnewman>
;; Maintainer: Daniel Newman <dan@danlovesprogramming.com>
;; Created: January 03, 2021
;; Modified: January 03, 2021
;; Version: 0.0.1
;; Keywords:
;; Homepage: https://github.com/dnewman/+theming
;; Package-Requires: ((emacs 27.1) (cl-lib "0.5"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;
;;
;;; Code:

;; (setq neo-theme 'icons)
(doom-themes-neotree-config)
(setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
      doom-themes-enable-italic t) ; if nil, italics is universally disabled
(doom-themes-org-config)

(defun fm/reload-theme-in-all-frames ()
  "Function to force the reloading of the active theme in all frames.
   To be called from emacsclient after modifying the theme file"
  (dolist (frame (visible-frame-list))
    (with-selected-frame frame (doom/reload-theme))))

(setq +ivy-buffer-icons t)

(provide '+theming)
;;; +theming.el ends here
