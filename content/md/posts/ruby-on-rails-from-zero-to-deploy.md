{:title       "Ruby on Rails: From zero to deploy"
 :layout      :post
 :summary     "
              This document is a densed summary of the Ruby on Rails Tutorial's chapter 1: From zero to deploy.
              The goal is to focus solely on the project setup and deployment to Heroku."
 :excerpt     "This document is a densed summary of the Ruby on Rails Tutorial's chapter 1: From zero to deploy."
 :description "A densed summary of the Ruby on Rails Tutorial's chapter 1: From zero to deploy."
 :date        "2019-10-24"
 :tags        ["development"
               "web-application-framework"
               "ruby-on-rails"
               "ruby"]}

-------------------------------------------------------------------------------

This great book, [Ruby on Rails Tutorial](https://www.railstutorial.org), was finally updated to the 6th edition to cover [Ruby on Rails](https://rubyonrails.org) 6.
Unlike before, though, all chapters of the book isn't available online for free as it used to, however, in my opinion,
people who learned a somewhat complete sense of Rails will still benefit from its first 3 free chapters;
one being the first chapter: [From zero to deploy](https://www.railstutorial.org/book/beginning#cha-beginning) &mdash; which this document is about.

-------------------------------------------------------------------------------

Prerequisites
-------------

Before proceeding, make sure that the following are installed:

- [RVM](https://rvm.io)
- [Yarn](https://yarnpkg.com)

-------------------------------------------------------------------------------

**Note:** In this guide, we'll use the name `rails-fztd` (replace it with whatever name you want).

Setup
-----

1. Create and move to project directory:

   ``` shell
$ \
mkdir -p ~/Projects/
cd ~/Projects/
```

2. Create and move to Rails app:

   ``` shell
$ \
rails new rails-fztd
cd rails-fztd/
```

3. Run web server:

   ``` shell
$ rails s
```
   Then visit <http://localhost:3000>.

-------------------------------------------------------------------------------

Pre-deployment
--------------

### Project ###

1. Update the `Gemfile`:

   ``` ruby
# File: Gemfile
...
# gem 'sqlite3', '~> 1.4'
...
group :development, :test do
  ...
  gem 'sqlite3'
end

group :production do
  gem 'pg'
end
...
```
   **Notes:**

   - Move `sqlite3` gem to `:development, :test` groups
   - Create `:production` group then add `pg` gem in it
   - [Heroku](https://www.heroku.com) doesn't support [SQLite](https://www.sqlite.org) but enforces [PostgreSQL](https://www.postgresql.org) (hence `pg`)
   - Gems (e.g. `sqlite3` and `pg`) without a version will install the latest version
   <div></div>

2. Install `postgresql-libs` package:
   <br />**Note:** This package installs the essential shared libraries for PostgreSQL clients.

   ``` shell
$ sudo pacman -S postgresql-libs
```

3. Install `:development` gems:

   ```
$ bundle install --without production
```
   **Note:** The `--without production` parameter excludes installing gems specified in `:production` group.

### Heroku ###

1. [Sign up](https://signup.heroku.com) (if no account)

2. Install [Heroku CLI](https://devcenter.heroku.com/articles/heroku-cli):

   ``` shell
$ yay -S heroku-cli
```

3. Log in (interactively):

   ``` shell
$ heroku login --interactive
```
   **Note:** The `--interactive` parameter uses the terminal-based login flow instead of opening a web browser.

4. Create a new Heroku app:

   ``` shell
$ heroku apps:create rails-fztd
```
   **Note:** The `apps:create` parameter allows us to create a Heroku app with a specific name.

Deployment
----------

1. Stage and commit (local):

   ``` shell
$ \
git add -A
git commit -m 'Initial commit'
```

2. Push to Heroku `master` (remote):

   ``` shell
$ git push heroku master
```
   Then visit <https://rails-fztd.herokuapp.com>.

3. Check Heroku logs for possible errors:

   ``` shell
$ heroku logs
```

**Congratulations!** We've finally learned how to deploy our Rails app on Heroku :)
