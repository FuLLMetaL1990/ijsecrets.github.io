{:title       "Spacemacs Configuration Layers"
 :layout      :post
 :summary     "
              After successfully setting up Arch Linux, you may wish to configure the Spacemacs text editor (if you also happen to use it) to start doing development.
              Spacemacs has the concept of \"layers\" for organizing packages and their configurations to make them work seemlessly with other related packages.
              "
 :excerpt     "This a brief how-to guide to configure Spacemacs Configuration Layers."
 :description "A brief how-to guide to configure Spacemacs Configuration Layers."
 :date        "2019-08-04"
 :tags        ["sysadmin"
               "text-editor"
               "emacs"
               "spacemacs"]}

-------------------------------------------------------------------------------

**Note:** This is the continuation of [Setup Arch Linux](setup-arch-linux)'s [Spacemacs](setup-arch-linux#spacemacs) section.

-------------------------------------------------------------------------------

Shortcuts
---------

| Keybinding  | Description               |
| :---------- | :------------------------ |
| `SPC f e d` | Open `.spacemacs` dotfile |
| `SPC f e R` | Sync `.spacemacs` changes |

-------------------------------------------------------------------------------

Layers
------

### Org ###

1. Add [Org layer](http://develop.spacemacs.org/layers/+emacs/org/README.html) on `dotspacemacs-configuration-layers` for [Org mode](https://orgmode.org) support:

   ``` emacs-lisp
(org :variables
     org-enable-github-support t
     org-enable-bootstrap-support t
     org-enable-reveal-js-support t
     org-publish-project-alist
     `(("html"
        :base-extension "org"
        :base-directory ,(concat (vc-call-backend 'Git 'root default-directory) ".org/")
        :publishing-directory ,(vc-call-backend 'Git 'root default-directory)
        :publishing-function org-md-publish-to-md
        :section-numbers nil
        :recursive t)
       ("all"
        :components ("html"))))
```

2. Update `dotspacemacs/user-config`:

   ``` emacs-lisp
(with-eval-after-load 'org
  ;; Enable org-babel languages:
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp t)
     (shell . t))))
```

### Ivy ###

1. Add [Ivy layer](http://develop.spacemacs.org/layers/+completion/ivy/README.html) on `dotspacemacs-configuration-layers` for [Ivy](https://oremacs.com/swiper) support:

   ``` emacs-lisp
(ivy :variables
     ivy-enable-advanced-buffer-information t)
```

### Shell ###

1. Add [Shell layer](http://develop.spacemacs.org/layers/+tools/shell/README.html) on `dotspacemacs-configuration-layers` for shell support:

   ``` emacs-lisp
(shell :variables
       shell-default-shell 'shell)
```

### Git ###

1. Install [gitflow-avh](https://github.com/petervanderdoes/gitflow-avh):

   ``` shell
$ yay -S gitflow-avh
```

2. Add [Git layer](http://develop.spacemacs.org/layers/+source-control/git/README.html) on `dotspacemacs-configuration-layers` for [git](https://git-scm.com) support:

   ``` emacs-lisp
(git :variables
     git-magit-status-fullscreen t
     magit-repository-directories '(("~/Projects/" . 2)))
```

3. Update `dotspacemacs/user-config`:

   ``` emacs-lisp
;; Set default prefixes:
(defun set-default-gitflow-config ()
  (magit-set "master"    "gitflow.branch.master")
  (magit-set "develop"   "gitflow.branch.develop")
  (magit-set "feature/"  "gitflow.prefix.feature")
  (magit-set "release/"  "gitflow.prefix.release")
  (magit-set "bugfix/"   "gitflow.prefix.bugfix")
  (magit-set "hotfix/"   "gitflow.prefix.hotfix")
  (magit-set "support/"  "gitflow.prefix.support")
  (magit-set "v"         "gitflow.prefix.versiontag")
  (magit-set "origin"    "gitflow.origin")
  (magit-set "false"     "gitflow.feature.start.fetch"))

(add-hook 'magit-mode-hook 'set-default-gitflow-config)

;; Spacemacs as git $EDITOR:
(global-git-commit-mode t)
```

### GitHub ###

1. Create a [personal access token](https://github.com/settings/tokens):

   1. Go to [New personal access token](https://github.com/settings/tokens/new)
   2. Add **Token description** (e.g. `magithub`)
   3. Under **Select scopes**, check `repo` and `gist` checkboxes
   4. Click **Generate token**
   5. Click copy icon (between check icon and **Delete** button)

2. Add token to `.gitconfig`:

   ``` shell
$ git config --global github.oauth.token <token>
```

3. Add [GitHub layer](http://develop.spacemacs.org/layers/+source-control/github/README.html) on `dotspacemacs-configuration-layers` for [GitHub](https://github.com) support:

   ``` emacs-lisp
github
```

4. Enable [Magithub](https://github.com/vermiculus/magithub):

   ``` shell
$ \
git config --global --bool magithub.online true
git config --global --bool magithub.status.includeStatusHeader true
git config --global --bool magithub.status.includePullRequestsSection true
git config --global --bool magithub.status.includeIssuesSection true
```

5. Update `dotspacemacs/user-config`:

   ``` emacs-lisp
;; Enable magit-git-pulls:
(add-hook 'magit-mode-hook 'turn-on-magit-gh-pulls)
```

### JavaScript ###

1. Install prerequisites:

   ``` shell
$ npm install -g tern        \
                 js-beautify \
                 eslint
```

2. Add [JavaScript layer](http://develop.spacemacs.org/layers/+lang/javascript/README.html) on `dotspacemacs-configuration-layers` for [JavaScript](https://www.ecma-international.org/publications/standards/Ecma-262.htm) support:

   ``` emacs-lisp
(javascript :variables
            javascript-fmt-tool 'web-beautify
            js2-basic-offset 2
            js-indent-level 2)
```

### HTML ###

1. Install [js-beautify](https://github.com/beautify-web/js-beautify):

   ``` shell
$ npm install -g js-beautify
```

2. Add [HTML layer](http://develop.spacemacs.org/layers/+lang/html/README.html) on `dotspacemacs-configuration-layers` for [HTML](https://html.spec.whatwg.org) and [CSS](https://www.w3.org/Style/CSS) support :

   ``` emacs-lisp
(html :variables
      web-fmt-tool 'web-beautify)
```

### Markdown ###

1. Install [vmd](https://github.com/yoshuawuyts/vmd):

   ``` shell
$ npm install -g vmd
```

2. Add [Markdown layer](http://develop.spacemacs.org/layers/+lang/markdown/README.html) `dotspacemacs-configuration-layers` for [Markdown](https://daringfireball.net/projects/markdown) support:

   ``` emacs-lisp
(markdown :variables
          markdown-live-preview-engine 'vmd)
```
