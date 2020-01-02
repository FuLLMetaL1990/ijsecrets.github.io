ijsecrets.com
===========

My [homepage](https://ijsecrets.com)

-------------------------------------------------------------------------------

<!-- markdown-toc start - Don't edit this section. Run M-x markdown-toc-refresh-toc -->
**Table of Contents**

- [ijsecrets.com](#ijsecretscom)
    - [src](#src)
        - [Dependencies](#dependencies)
        - [Setup](#setup)
        - [Build](#build)
        - [Clean](#clean)
        - [Run server](#run-server)
            - [Development](#development)
            - [Production](#production)
    - [License](#license)

<!-- markdown-toc end -->

-------------------------------------------------------------------------------

src
---

`./src/` contains the files required to render the homepage.

### Dependencies ###

- [jq](https://stedolan.github.io/jq)
- [html-minifier](https://github.com/kangax/html-minifier)
- [clean-css](https://github.com/jakubpawlowicz/clean-css)
- [uglify-js](https://github.com/mishoo/UglifyJS2)
- [relateurl](https://github.com/stevenvachon/relateurl)
- [css-cli](https://github.com/css/csso-cli)
- [imagemin-cli](https://github.com/imagemin/imagemin)

### Setup ###

``` shell
$ yay -S jq
$ npm install -g html-minifier \
               clean-css       \
               uglify-js       \
               relateurl       \
               csso-cli        \
               imagemin-cli
```

### Build ###

``` shell
$ make
```

### Clean ###

``` shell
$ make clean
```

### Run server ###

#### Development ####

View un-optimized homepage.

``` shell
$ make dev-server
```

#### Production ####

View optimized homepage.

``` shell
$ make server
```

-------------------------------------------------------------------------------

License
-------

`ijsecrets.com` is licensed under [MIT](./LICENSE).
