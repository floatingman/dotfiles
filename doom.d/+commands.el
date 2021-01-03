;;; private/floatingman/+commands.el -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2021 Daniel Newman
;;
;; Author: Daniel Newman <http://github/dnewman>
;; Maintainer: Daniel Newman <dan@danlovesprogramming.com>
;; Created: January 03, 2021
;; Modified: January 03, 2021
;; Version: 0.0.1
;; Keywords:
;; Homepage: https://github.com/dnewman/+commands
;; Package-Requires: ((emacs 27.1) (cl-lib "0.5"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;
;;
;;; Code:

(defalias 'ex! 'evil-ex-define-cmd)

;; File operations
(ex! "cp"     #'+evil:copy-this-file)
(ex! "mv"     #'+evil:move-this-file)
(ex! "rm"     #'+evil:delete-this-file)

(provide '+commands)
;;; +commands.el ends here
