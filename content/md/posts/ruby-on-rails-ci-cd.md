{:title       "Ruby on Rails: CI / CD"
 :layout      :post
 :summary     "
              This is a quick tour for demonstrating CI (Continuous Integration) and Continuous Delivery (CD) with Ruby on Rails, Travis CI and Heroku.
              It is quite dense and requires a fair amount of knowledge on the tools and practices specified on the prerequisites.
              "
 :excerpt     "A quick tour for demonstrating CI / CD with Ruby on Rails, Travis CI and Heroku."
 :description "A quick tour for demonstrating CI / CD with Ruby on Rails."
 :date        "2019-10-26"
 :tags        ["development"
               "web-application-framework"
               "ruby-on-rails"
               "ruby"]}

-------------------------------------------------------------------------------

This is a step-by-step guide to demonstrate
Continuous Integration (automated build) and
Continuous Delivery (manual deployment) using
an application created with Ruby on Rails,
Travis CI as the CI build tool
and Heroku as the hosting platform to handle CD.

-------------------------------------------------------------------------------

Prerequisites
-------------

- [Ruby](https://www.ruby-lang.org)
- [Ruby on Rails](https://rubyonrails.org)
- [Git](https://git-scm.com)
- [GitHub](https://github.com) account
- [GitHub Flow](https://guides.github.com/introduction/flow)
- [Travis CI](https://travis-ci.com) account
- [Travis CI Client](https://github.com/travis-ci/travis.rb)
- [Heroku](https://dashboard.heroku.com) account
- [Heroku Flow](https://www.heroku.com/flow)
- [Heroku CLI](https://devcenter.heroku.com/articles/heroku-cli)

-------------------------------------------------------------------------------

Notable info
------------

- [Continuous Deployment](https://en.wikipedia.org/wiki/Continuous_deployment) (or automated Continuous Delivery) is not supported out of the box in Heroku and is not part of the Heroku Flow
- [GitFlow](https://nvie.com/posts/a-successful-git-branching-model), while very popular, contradicts the very essence of CD / CD (hint: **continuous**); plus overkill for a one-man project like this

-------------------------------------------------------------------------------

Legends
-------

For consistency, we'll use the following variables so you can modify it with your own:

- `<username>` to represent the username
- `<repo>` to represent the repo name

-------------------------------------------------------------------------------

SCM
---

**Note:** SCM stands for **Source Code Management** (also referred to as [Version Control](https://en.wikipedia.org/wiki/Version_control)).

### GitHub ###

1. [Sign in](https://github.com/login) (or [Sign up](https://github.com/join) if not registered)
2. Create a [new](https://github.com/new) repo

### GitHub Settings ###

**Note:** These settings are personal preferences, applying them are optional:

- **Disable force pushing** on `master` branch:

  1. Go to **Branches** (`/<username>/<repo>/settings/branches`)
  2. On **Branch protection rules**, click **Add rule**
  3. On **Branch name pattern**, type `master`
  4. Click **Create**

### GitHub Issues ###

1. Create a **New Issue** (`/<username>/<repo>/issues/new`)
2. Enter a **Title** (e.g. _Create rails boilerplate_)
3. Click **Submit new issue**

-------------------------------------------------------------------------------

App
---

### Local repo ###

1. Clone the repo:

   ``` shell
$ git clone git@github.com:<username>/<repo>.git
```

2. Move to repo:

   ``` shell
$ cd <repo>
```

### Boilerplate ###

1. Create the boilerplate:

   ``` shell
$ git checkout -b rails-boilerplate
```

2. Generate the rails app:

   ``` shell
$ rails new . -f
```
   **Notes:**

   - `.` generates the app in the current directory
   - `-f` overwrites any existing files

3. Update the `Gemfile`:

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

4. Install only `:development` gems:

   ```
$ bundle --without production
```

5. Apply migration:

   ``` shell
$ rails db:migrate
```

### .travis.yml ###

1. Add `.travis.yml`:

   ``` shell
$ \
echo '
language: ruby
cache:
  bundler: true
  yarn: true
  directories:
  - node_modules
bundler_args: "--without production"
script:
- yarn
- bundle exec rails db:migrate
- bundle exec rails t
branches:
  only:
  - master
' > .travis.yml
```
   **Notes:**

   - The build begins only when the `.travis.yml` file is found
   - The `language` uses the `ruby` environment on Travis CI
   - Travis CI uses `rvm` to provide Ruby implementations
   - Since `rvm` is not specified, it uses`.ruby-version`'s
   - The `cache` caches installed packages to speedup builds
   - The `bundler_args` adds extra parameters when installing w/ `bundler`
   - The `script` runs `bundle install --jobs=3 --retry=3` by default
   - The `script` are the commands you type on your terminal locally
   - The `branches` only builds on the specified repo branches

2. Stage, commit then push:

   ``` shell
$ \
git add -A
git commit -m 'Add Rails boilerplate'
git push -u origin rails-boilerplate
```
   **Notes:**

   - `-A` is a shortcut for `git add .` then `git add -u`.
   - `-u` adds upstream reference so the next git push will refer the same branch

-------------------------------------------------------------------------------

CI
--

### Travis CI ###

**Note:** Travis CI is **Free for Open Source** projects.

1. Go to [Travis CI](https://travis-ci.com)
2. Click **Sign in with GitHub** or **Sign up with GitHub**
3. Click **Authorize travis-pro**
4. Go to [Settings](https://travis-ci.com/account)
5. On the **Repositories**, click **Activate**
6. Click **Approve & Install**
7. Locate the `<repo>` then click **Settings**

### Travis CI Settings ###

**Note:** These settings are personal preferences, applying them are optional:

- Toggle on **Auto cancel branch builds**
- Toggle on **Auto cancel pull request builds**

**Notes:**

- Travis CI integration can be found on GitHub at `/<username>/<repo>/settings/installations`
- Travis CI build can be found on its website at `/<username>/<repo>`

### GitHub Pull Request ###

1. Go back to GitHub and open a pull request:

   - **Title**: `rails-boilerplate`
   - **Leave a comment**: `Closes #1: Create rails boilerplate`
   - Click **Create pull request**

2. A check called **Travis CI - Pull Request** should appear

3. Wait for the check to complete then go to **Branches** and update GitHub Settings

### Re: GitHub Settings ###

**Note:** These settings are personal preferences, applying them are optional:

1. Go to **Branches** `/<username>/<repo>/settings/branches`

2. On **Branch protection rules**, click **Edit**

3. Switch on the following:

   - **Require status checks to pass before merging**
   - **Require branches to be up to date before merging**
   - **Travis CI - Pull Request**
   - **Include administrators**

4. Click **Save changes**

### README: Build Status ###

1. Update local repo's `README` with:

   ``` html
# <repo> [![Build Status](https://travis-ci.com/<username>/<repo>.svg?branch=master)](https://travis-ci.com/<username>/<repo>)
```

2. Stage, commit then push

3. The same checks should appear
   <br />**Note:** Except this time, **Merge pull request** is unclickable until checks are complete.

-------------------------------------------------------------------------------

CD
--

### Heroku ###

[Login](https://id.heroku.com/login) (or [Sign up](https://signup.heroku.com) if not registered)


### Pipelines ###

#### Staging ####

1. [Create New App](https://dashboard.heroku.com/new-app)

   - **App name**: `staging-<repo>`

   - **Choose a region**: `Europe`

   - **Add to pipeline...** > **Add this app to a pipeline** > **Create new pipeline**:

     - **Name the pipeline**: `staging-<repo>`

     - **Choose a stage to add this to**: `staging`

   - Click **Create app**

2. On **Deployment method**, click **GitHub**

3. On **Connect to GitHub**, click **Connect to GitHub**

4. Click **Authorize heroku**

5. On **Connect to GitHub**, type repo `<repo>` in **repo-name** then click **Search**

6. Locate the `<repo>` then click **Connect**

7. On **Automatic deploys**

   - On **Choose a branch to deploy**, select `master`
   - Switch on **Wait for CI to pass before deploy**
   - Click **Enable Automatic Deploys**

#### Production ####

1. On **Connected to a pipeline**, click **pipeline overview**

2. On **PRODUCTION** column, click **Add app**

3. Click **Create new app...**

   - **App name**: `<repo>`
   - **Choose a region**: `Europe`
   - Click **Create app**

4. Click `<repo>`
5. On **Installed add-ons**, click **Configure Add-ons**
6. On **Add-ons**, type `pos`, then select **Heroku Postgres**
7. On **Plan name**, select **Hobby Dev - Free**, then click **Provision**
8. Go back to **Dashboard**, then click `staging-<repo>`

### Review Apps ###

1. Update local repo with `app.json`:

   ``` shell
$ echo '
{
  "name": "<repo>",
  "scripts": {},
  "env": {},
  "formation": {},
  "addons": [],
  "buildpacks": [],
  "stack": "heroku-18"
}
' > app.json
```

2. Stage, commit then push

### Heroku CLI ###

1. Install [Heroku CLI](https://devcenter.heroku.com/articles/heroku-cli):

   ``` shell
$ yay -S heroku-cli
```

2. Log in (interactively):

   ``` shell
$ heroku login -i
```
   **Notes:**

   - `-i` is a shortcut for `--interactive`
   - `-i` uses the terminal-based login flow instead of opening a web browser

### Re: .travis.yml ###

1. Install `travis`:

   ``` shell
$ gem install travis
```

2. Update `.travis.yml`:

``` yaml
# File: .travis.yml
...
deploy:
  provider: heroku
  api_key:
    secure: <token>
  app: staging-<repo>
  on:
    repo: <username>/<repo>
```

3. Log in on Travis CI:

   ``` shell
$ travis login --pro --auto
```
   **Notes:**

   - Use GitHub login credentials to log in
   - `--pro` distinguishes un/paid services
   - `--auto` skips password authentication

4. Encrypt Heroku auth token:

   ``` shell
$ travis encrypt $(heroku auth:token) \
                 --add deploy.api_key \
                 --com
```
   **Notes:**

   - `--add deploy.api_key` automatically adds the encrypted token to `deploy.api_key.secret`.
   - `--com` distinguishes un/paid services

5. Stage, commit then push

6. Go back to GitHub, **Merge pull request** then **Confirm merge**

### Re: Review Apps ###

1. Go back to Dashboard, then click `<repo>`

2. On **REVIEW APPS**, click **Enable Review Apps...**

3. Switch on **Create new review apps for new pull requests automatically**
   <br />**Enable this option if you want every new pull request to create an app.**

4. Click **Enable**

**Note:**

- There should be an accessible heroku app whenever a new pull request is made (or updated)
- Temporary environment for PRs becomes available at `staging-<repo>-pr-<n>.herokuapp.com`

### Promote to Production ###

1. Click **Promote to Production**
2. Click **Promote**

This is Continuous Delivery.

**Congratulations!** We now learned how to do CI / CD with Ruby on Rails :)
