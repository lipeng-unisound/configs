(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "http://melpa.org/packages/") t)

(package-initialize)

(defun set-exec-path-from-shell-PATH ()
  (let ((path-from-shell (replace-regexp-in-string
			  "[ \t\n]*$"
			  ""
			  (shell-command-to-string "$SHELL --login -i -c 'echo $PATH'"))))
    (setenv "PATH" path-from-shell)
    (setq eshell-path-env path-from-shell) ; for eshell users
    (setq exec-path (split-string path-from-shell path-separator))))

(when window-system (set-exec-path-from-shell-PATH))

;;; Setup plugins for Go language
(setenv "GOPATH" "/work/local/lipeng/go")

(setq exec-path (cons "/usr/local/go/bin" exec-path))
(add-to-list 'exec-path "/work/local/lipeng/go/bin")
(add-hook 'before-save-hook 'gofmt-before-save)

(defun my-go-mode-hook ()
					; Use goimports instead of go-fmt
  (setq gofmt-command "goimports")
					; Call Gofmt before saving
  (add-hook 'before-save-hook 'gofmt-before-save)
					; Customize compile command to run go build
  (if (not (string-match "go" compile-command))
      (set (make-local-variable 'compile-command)
	   "go build -v && go test -v && go vet"))
					; Go oracle
  (load-file "$GOPATH/src/golang.org/x/tools/cmd/oracle/oracle.el")
					; Godef jump key binding
  (local-set-key (kbd "M-.") 'godef-jump))
(add-hook 'go-mode-hook 'my-go-mode-hook)

(defun auto-complete-for-go ()
  (auto-complete-mode 1))
(add-hook 'go-mode-hook 'auto-complete-for-go)

(with-eval-after-load 'go-mode
  (require 'go-autocomplete))

;;; color themes
(add-to-list 'custom-theme-load-path "/home/lipeng/.emacs.d/color-themes/")
(load-theme 'taming-mr-arneson t)
