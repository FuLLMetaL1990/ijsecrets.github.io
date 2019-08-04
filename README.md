ejelome.com
===========

My [homepage](https://ejelome.com)

-------------------------------------------------------------------------------

<!-- markdown-toc start - Don't edit this section. Run M-x markdown-toc-refresh-toc -->
**Table of Contents**

- [ejelome.com](#ejelomecom)
    - [Dependencies](#dependencies)
    - [Install](#install)
    - [Compile](#compile)
    - [Run](#run)
    - [Publish](#publish)
    - [Extras](#extras)
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

Install
-------

Setup and configure a [Cryogen](http://cryogenweb.org) template with existing `content`.

``` shell
$ make install
```

The command `make install` does the following:

1. Create a `tmp` directory
2. Move `.gitignore` and `content` directory to `tmp`
3. Generate a `cryogen` template in the current directory
4. Remove the generated `.gitignore`, `content` directory and `themes`' subdirectories
5. Move back `.gitignore` and `content` directory from `tmp` directory to current directory
6. Remove the created `tmp` directory
7. Clone [cryogen-theme-wooji](https://github.com/ejelome/cryogen-theme-wooji) as `themes/wooji`

-------------------------------------------------------------------------------

Compile
-------

Generate static files without running a server.

**Note:** `make` uses `make compile`.

``` shell
$ make compile
```

The command `make` or `make compile` does the following:

1. Run the command `lein run` (compile the files without running a web server)

-------------------------------------------------------------------------------

Run
---

Generate static files then run web server.

``` shell
$ make run
```

The command `make run` does the following:

1. Run the command `lein ring server` (compile the files then run a web server)

-------------------------------------------------------------------------------

Publish
-------

Copy `publish` files to `docs` directory then push to `master` branch.

``` shell
$ make publish
```

The command `make publish` does the following:

0. Re-compile, fix `sitemap.xml` then minify all markup, style, script and image files
1. Remove previously moved `docs` directory (if there is any)
2. Rename `public` directory to `docs` directory
3. Stage all the files to `git`
4. Commit the staged files with `date +%s` (timestamp) as message
5. Push the commit to `master` branch (`origin`)

-------------------------------------------------------------------------------

Extras
------

The following are convenience `make` commands:

| Command         | Description                                            |
| :-------------- | :----------------------------------------------------- |
| `fix-sitemap`   | Add trailing slash (`/`) after `.com` on `sitemap.xml` |
| `fix-all`       | Run all `fix-*` commands                               |
| `rel-nofollow`  | Add `rel="nofollow"` on external links                 |
| `optimize-html` | Minify all markup (`*.html`) files                     |
| `optimize-css`  | Minify `css/styles.css` file                           |
| `optimize-js`   | Minify `js/scripts.js` file                            |
| `optimize-img`  | Optimize all image files                               |
| `optimize-all`  | Run all `optimize-*` commands                          |

-------------------------------------------------------------------------------

License
-------

`ejelome.com` is licensed under [MIT](./LICENSE).
