{:title       "Cryogen's Missing Manual"
 :layout      :post
 :summary     "
              Cryogen has set a really good and well thought out number of defaults.
              And should one decide to develop their own theme, it will be necessary to know
              1) its required structure such as directories, files, and assets,
              2) its required keywords on markdown files to publish posts or pages
              and 3) the context keywords available on templates.
              "
 :excerpt     "These are the three crucial aspects of Cryogen to effectively develop a theme."
 :description "The three crucial aspects of Cryogen to develop a theme."
 :date        "2019-07-07"
 :tags        ["research"
               "static-site-generator"
               "cryogen"]}

-------------------------------------------------------------------------------

I was looking for a simple static site generator that can parse and convert [markdown](https://daringfireball.net/projects/markdown) files to markup and found [Cryogen](http://cryogenweb.org).
And preferring anything related to [Clojure](https://clojure.org) or [ClojureScript](https://clojurescript.org), I decided to settle with it.

Cryogen is not really that new, in fact, it is already 5 years old (as of this writing, [initial commit](https://github.com/cryogen-project/cryogen/commit/36fa50133f0342c2d4e9e28cb8b2986df84dbd7e) was 2014).
But it did not really matter because it seems to be the only stable project available in Clojure to do the job.

Upon exploration, I ended up finding interesting but scattered bits of information on how it actually works.
And in order to not lose those crucial details, I decided to write them all here.

-------------------------------------------------------------------------------

Required structure
------------------

``` bash
themes/                   # directory containing cryogen's themes
└── <theme>/              # directory containing theme's files
    ├── html/             # directory containing theme's markup (*.html)
    │   ├── home.html     # file used for homepage if :previews? is false
    │   ├── previews.html # file used for homepage if :previews? is true
    │   ├── page.html     # file used for a page if :layout is :page
    │   ├── post.html     # file used for a post if :layout is :post
    │   ├── author.html   # file used for an author containing posts
    │   ├── archives.html # file used for archives grouped by date
    │   ├── tag.html      # file used for a tag containing posts
    │   ├── tags.html     # file used only for tags
    │   └── 404.html      # file used for broken urls
    ├── css/              # directory containing theme's styles (*.css)
    └── js/               # directory containing theme's behaviors (*.js)
```

**Note:** Both `base.html` and `post-content.html` are useful for decoupling but they are optional.

-------------------------------------------------------------------------------

Required keywords
-----------------

These are the required [keywords](https://clojure.org/reference/data_structures#Keywords) to publish a post or a page:

| Key       | Type      | Page      | Post                   | Rule                                   |
| :-------- | :-------- | :-------- | :--------------------- | :------------------------------------- |
| `:title`  | `String`  | `<title>` | `<yyyy-MM-dd>-<title>` | Can be omitted if `:date` is in map.   |
| `:layout` | `Keyword` | `:page`   | `:post`                | Specifies what `*.html` layout to use. |
| `:date`   | `String`  |           | `<yyyy-MM-dd>`         | Can be omitted if a date is in file.   |

**Note:** Cryogen's [documentation](http://cryogenweb.org/docs/creating-pages.html#page_contents 'Page Contents') state that `page-index` is a required keyword, but it is not.

-------------------------------------------------------------------------------

Context keywords
----------------

Each template contains specific sets of contexts stored in keywords (e.g. `:active-page`).

- To access a context, wrap a keyword in two pairs of braces (`{{ }}`) without the colon (`:`) (e.g. `{{ active-page }}`)
- Use `{% debug %}` to display all available keywords on a specific template (e.g. `home.html`)

### config.edn ###

These are the contexts from `config.edn` that can be accessed on all the templates:

| Context                 | Type                 | Example Value              |
| :---------------------- | :------------------- | :------------------------- |
| `:site-title`           | `String`             | `My Awesome Blog`          |
| `:author`               | `String`             | `Bob Bobbert`              |
| `:description`          | `String`             | `This blog is awesome`     |
| `:site-url`             | `String`             | `http://blogawesome.com`   |
| `:post-root`            | `String`             | `posts`                    |
| `:page-root`            | `String`             | `pages`                    |
| `:post-root-uri`        | `String`             | `posts-output`             |
| `:page-root-uri`        | `String`             | `pages-output`             |
| `:tag-root-uri`         | `String`             | `tags-output`              |
| `:author-root-uri`      | `String`             | `authors-output`           |
| `:public-dest`          | `String`             | `public`                   |
| `:blog-prefix`          | `String`             | `/blog`                    |
| `:rss-name`             | `String`             | `feed.xml`                 |
| `:rss-filters`          | `PersistentVector`   | `["cryogen"]`              |
| `:recent-posts`         | `Long`               | `3`                        |
| `:post-date-format`     | `String`             | `yyyy-MM-dd`               |
| `:archive-group-format` | `String`             | `yyyy MMMM`                |
| `:sass-src`             | `PersistentVector`   | `[]`                       |
| `:sass-path`            | `String`             | `sass`                     |
| `:compass-path`         | `String`             | `compass`                  |
| `:theme`                | `String`             | `blue`                     |
| `:resources`            | `PersistentVector`   | `["img"]`                  |
| `:keep-files`           | `PersistentVector`   | `[".git"]`                 |
| `:disqus?`              | `Boolean`            | `false`                    |
| `:disqus-shortname`     | `String`             | `""`                       |
| `:ignored-files`        | `PersistentVector`   | `[`"\\.#.*" ".*\\.swp$"`]` |
| `:previews?`            | `Boolean`            | `false`                    |
| `:posts-per-page`       | `Long`               | `5`                        |
| `:blocks-per-preview`   | `Long`               | `2`                        |
| `:clean-urls`           | `Keyword`            | `:trailing-slash`          |
| `:collapse-subdirs?`    | `Boolean`            | `false`                    |
| `:hide-future-posts?`   | `Boolean`            | `true`                     |
| `:klipse`               | `PersistentArrayMap` | `{}`                       |
| `:debug?`               | `Boolean`            | `false`                    |

### Undocumented ###

These are the undocumented contexts that can also be accessed on all the templates:

| Context            | Type                 | Example Value                   |
| :----------------- | :------------------- | :------------------------------ |
| `:active-page`     | `String`             | `home`                          |
| `:archives-uri`    | `String`             | `/blog/archives/`               |
| `:home-page`       | `PersistentArrayMap` | Same as `{`[`:post`](#:post)`}` |
| `:index-uri`       | `String`             | `/blog/`                        |
| `:latest-posts`    | `PersistentVector`   | `[{`[`:post`](#:post)`}]`       |
| `:navbar-pages`    | `PersistentVector`   | `[{`[`:page`](#:page)`}]`       |
| `:rss-uri`         | `String`             | `/blog/feed.xml`                |
| `:sidebar-pages`   | `PersistentVector`   | `[{`[`:post`](#:post)`}]`       |
| `:tags`            | `PersistentVector`   | `[{ :name }]`                   |
| `:tags-uri`        | `String`             | `/blog/tags/`                   |
| `:theme-resources` | `PersistentVector`   | `[]`                            |
| `:theme-sass-src`  | `PersistentVector`   | `[]`                            |
| `:title`           | `String`             | `My Awesome Blog`               |
| `:today`           | `String`             | `Jul 09, 2019 22:00:00`         |
| `:uri`             | `String`             | `/blog/`                        |
| `:selmer/context`  | `String`             | `/blog/`                        |

### Templates ###

These are the contexts that can only be accessed on specific templates:

| Context     | Type                 | `home` / `previews` | `page`   | `post`   | `author` | `archives` | `tag`    | `tags` |
| :---------- | :------------------- | :-----------------: | :------: | :------: | :------: | :--------: | :------: | :----: |
| `:home`     | `Boolean`            | &#10003;            | &#10003; |          |          |            |          |        |
| `:page`     | `PersistentArrayMap` | &#10003;            | &#10003; |          |          |            |          |        |
| `:post`     | `PersistentArrayMap` | &#10003;            |          | &#10003; |          |            | &#10003; |        |
| `:archives` | `Boolean`            |                     |          |          |          | &#10003;   |          |        |
| `:groups`   | `PersistentVector`   |                     |          |          | &#10003; | &#10003;   |          |        |
| `:name`     | `String`             |                     |          |          |          |            | &#10003; |        |

### :page ###

These are the contexts available on the `:page` keyword:

| Context          | Type                 | Example Value                                               |
| :--------------- | :------------------- | :---------------------------------------------------------- |
| `:content`       | `String`             | `""`                                                        |
| `:file-name`     | `String`             | `"2016-01-07-docs.html"`                                    |
| `:home?`         | `Boolean`            | `false`                                                     |
| `:navbar?`       | `Boolean`            | `true`                                                      |
| `:next`          | `PersistentArrayMap` | Same as `:page` but without `:content`, `:next` and `:prev` |
| `:page-index`    | `Long`               | `0`                                                         |
| `:prev`          | `PersistentArrayMap` | Same as `:page` but without `:content`, `:next` and `:prev` |
| `:toc`           | `String`             | `""`                                                        |
| `:klipse/global` | `PersistentArrayMap` | `{}`                                                        |
| `:klipse/local`  | `PersistentArrayMap` | `{}`                                                        |

### :post ###

These are the contexts available on the `:post` keyword:

| Context                    | Type                 | Example Value                                               |
| :------------------------- | :------------------- | :---------------------------------------------------------- |
| `:content`                 | `String`             | `""`                                                        |
| `:draft?`                  | `Boolean`            | `false`                                                     |
| `:file-name`               | `String`             | `2016-01-07-docs.html`                                      |
| `:formatted-archive-group` | `String`             | `2016 January`                                              |
| `:next`                    | `PersistentArrayMap` | Same as `:post` but without `:content`, `:next` and `:prev` |
| `:parsed-archive-group`    | `String`             | `Jan 01, 2016 00:00:00`                                     |
| `:prev`                    | `PersistentArrayMap` | Same as `:post` but without `:content`, `:next` and `:prev` |
| `:toc`                     | `String`             | `""`                                                        |
| `:klipse/global`           | `PersistentArrayMap` | `{}`                                                        |
| `:klipse/local`            | `PersistentArrayMap` | `{}`                                                        |

### :groups ###

These are the contexts available on each item of the `:groups` keyword:

| Context         | Type                    | Example Value           |
| :-------------- | :---------------------- | :---------------------- |
| `:group`        | `String`                | `2016 January`          |
| `:parsed-group` | `String`                | `Jan 01, 2016 00:00:00` |
| `:posts`        | `PersistentVector`      | `[]`                    |

-------------------------------------------------------------------------------

Bugs
----

These are the unexpected behaviors I encountered:

- `author.html` uses `home` as `:active-page` value
- `tag.html` and `tags.html` both uses `tags` as `:active-page value`
- `home.html` and `previews.html` has `:post` context on `:page` keyword
- `toc` starts at `h3` downwards and there's no option to change it

-------------------------------------------------------------------------------

Limitations
-----------

And these are the important features I think Cryogen should have:

- `categories` (there are only `archives` and `tags`)
