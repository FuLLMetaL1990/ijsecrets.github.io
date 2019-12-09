ejelome.com
===========

My [homepage](https://ejelome.com)

-------------------------------------------------------------------------------

<!-- markdown-toc start - Don't edit this section. Run M-x markdown-toc-refresh-toc -->
**Table of Contents**

- [ejelome.com](#ejelomecom)
    - [Dependencies](#dependencies)
    - [Setup](#setup)
    - [Install](#install)
    - [Compile](#compile)
    - [Server](#server)
    - [Publish](#publish)
    - [Others](#others)
    - [License](#license)

<!-- markdown-toc end -->

-------------------------------------------------------------------------------

Dependencies
------------

Install dependencies:

``` shell
$ npm install -g html-minifier \
                 clean-css     \
                 uglify-js     \
                 relateurl     \
                 csso-cli      \
                 imagemin-cli
```

-------------------------------------------------------------------------------

Setup
-----

``` shell
$ git clone --recursive https://github.com/ejelome/ejelome.com.git
```

**Note:** `--recursive`also clones `hugo-theme-mod-kiera` submodule.

-------------------------------------------------------------------------------

Install
-------

Setup and configure an existing [Hugo](https://gohugo.io) template:

``` shell
$ make install
```

The command `make install` does the following:

1. Install [hugo](https://gohugo.io)
2. Install [hugo-theme-mod-kiera](https://github.com/ejelome/hugo-theme-mod-kiera) as `mod-kiera`

-------------------------------------------------------------------------------

Compile
-------

Generate static files without running a server.


``` shell
$ make compile
```

The command `make compile` does the following:

1. Compile markdown files to `public/`

-------------------------------------------------------------------------------

Server
------

Generate static files to `content/` and run the web server.

**Note:** `make` uses `make server`.

``` shell
$ make server
```

The command `make` or `make run` does the following:

1. Open `content/index.html` using the default browser
2. Run `hugo` web server with auto navigate on file change

-------------------------------------------------------------------------------

Publish
-------

Copy `publish` files to `docs/` directory then push to `master` branch.

``` shell
$ make publish
```

The command `make publish` does the following:

1. Execute `compile`, `optimize-`(`html`,`css`,`js`,`img`), `rep-asset-urls` and `rel-nofollow`
2. Remove existing `docs/` (if there is any)
2. Rename `public/` to `docs/`
3. Stage all the files to `git`
4. Commit the staged files with `date +%s` (`timestamp`) as message
5. Push the commit to `master` branch (`origin`)

-------------------------------------------------------------------------------

Others
------

The following are convenience `make` commands:

| Command          | Description                                            |
| :--------------- | :----------------------------------------------------- |
| `clean`          | Remove files and directories specified in `.gitignore` |
| `optimize-html`  | Minify `.html` files                                   |
| `optimize-css`   | Minify `css/styles.css` to `css/styles.min.css`        |
| `optimize-js`    | Minify `js/scripts.js` to `js/scripts.min.js`          |
| `optimize-img`   | Optimize images                                        |
| `rep-asset-urls` | Replace `.css` and `.js` urls to minified urls         |
| `rel-nofollow`   | Add `rel="nofollow"` on `href`s with external links    |

-------------------------------------------------------------------------------

License
-------

`ejelome.com` is licensed under [MIT](./LICENSE).
