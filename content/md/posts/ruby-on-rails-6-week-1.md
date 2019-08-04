{:title       "Ruby on Rails 6: Week 1"
 :layout      :post
 :summary     "
              Ruby on Rails is a server-side web application framework written in the Ruby programming language.
              It has strong emphasis on conventions (hence, Convention over Configuration or CoC) including Web standards, MVC, DRY and Active Record Pattern.
              It is geared towards programmer happiness and productivity by alleviating repetitive and tedious tasks through migrations, scaffolding and Rapid Application Development (RAD).

              This document will be about
              1) introduction and setup,
              2) create the app,
              3) views and controllers,
              4) models,
              5) connecting MVC,
              6) migrations,
              7) view helpers
              and 8) layouts.
              "
 :excerpt     "This is the week 1 summary of the learned lessons from The Pragmatic Studio's Ruby on Rails 6 course."
 :description "Week 1 summary of the learned lessons from The Pragmatic Studio's Ruby on Rails 6 course."
 :date        "2019-09-29"
 :tags        ["research"
               "web-application-framework"
               "ruby-on-rails"
               "ruby"]}

-------------------------------------------------------------------------------

So after learning [Ruby](https://www.ruby-lang.org) through [Pragmatic Studio](https://pragmaticstudio.com)'s [Ruby Programming](https://pragmaticstudio.com/courses/ruby) course,
it's time to learn [Ruby on Rails](https://rubyonrails.org) through their other course: [Ruby on Rails 6](https://pragmaticstudio.com/courses/rails).

It's unfortunate that there was no corresponding course plan so I decided to split the whole learned materials into weeks (8 lessons per week)
to avoid getting overwhelmed and not affect my work and life priorities.

There was also no corresponding reference book used so it will be a plain re-iteration of what have been learned throughout the course's video lessons.

At least, there were these extra documents provided that will come in handy along the way:

- [Rails commands and methods](https://pragmaticstudio.s3.amazonaws.com/courses/rails/Rails-Cheats.pdf) for commonly used Rails commands
- [Rails conventions](https://pragmaticstudio.s3.amazonaws.com/courses/rails/Rails-Conventions.pdf) to make sense of Rails' design decisions
- [Console shortcuts, tips, and tricks](https://pragmaticstudio.com/tutorials/rails-console-shortcuts-tips-tricks) to better utilize the Rails console

Finally, before starting, don't forget to read [The Rails Doctrine](https://rubyonrails.org/doctrine) to know **WHY** (or not) one should use Rails.

-------------------------------------------------------------------------------

Introduction and Setup
----------------------

### Install Rails ###

**Note:** This will install [Ruby on Rails](https://rubyonrails.org) thru [RVM](https://rvm.io).

1. Install [GPG](https://gnupg.org 'GNU Privacy Guard') keys:

   ``` shell
$ gpg2 --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 \
                   7D2BAF1CF37B13E2069D6956105BD0E739499BDB
```

2. Install `rvm` with `rails`:

   ``` shell
$ curl -sSL https://get.rvm.io | bash -s stable --rails
```

3. Source `rvm`:

   ``` shell
$ echo "
source ~/.rvm/scripts/rvm
" >> ~/.bashrc
. ~/.bashrc
```

### Install Yarn ###

1. Install [yarn](https://yarnpkg.com):

   ``` shell
$ sudo pacman -S yarn
```

-------------------------------------------------------------------------------

Create the App
--------------

### The skeleton app ###

**Note:** Just entering `rails` will display common commands.

1. Create a `rails` app:

   ``` shell
$ rails new <project>
```
  This command will:

  1. Create a `rails` skeleton (app structure)
  2. Install gem dependencies
  3. Install `webpacker`
  4. Install JS dependencies using `webpacker`

2. Move to directory:

   ``` shell
$ cd <project>
```

3. Run web server:

   ``` shell
$ rails s
```
   Then visit <http://localhost:3000>.
   <br />
   **Note:** `s` is a shorthand for `server`.

### The app structure ###

``` shell
<project>/            # project directory
├── app/              # application code
│   ├── models/       # handle storing and validating data to/from database
│   ├── views/        # handle interaction between controllers and clients
│   ├── controllers/  # handle interaction between views and models
│   ├── helpers/      # utility methods for views
│   ├── assets/       # static files (images, stylesheets)
│   ├── javascript/   # JS modules compiled by Webpack
│   ├── channels/     # real-time features using Action Cable
│   ├── mailers/      # generating and sending e-mails
│   └── jobs/         # running background jobs
├── config/           # application settings
│   ├── environments/ # environment settings
│   ├── initializers/ # startup settings
│   ├── webpack/      # webpack settings
│   └── locales/      # string translations
├── bin/              # command-line scripts
├── storage/          # uploaded files' storage using Active Storage
├── public/           # static files directly served on web server
├── test/             # application test files
├── lib/              # re-usable non-MVC source files
├── vendor/           # third-party dependencies
├── log/              # Rails log files
├── db/               # database and migration files
├── tmp/              # temporary application files
├── Rakefile
├── Gemfile           # application dependencies (gems)
├── Gemfile.lock
├── config.ru
├── babel.config.js
├── postcss.config.js
├── package.json
├── yarn.lock
└── README.md
```

-------------------------------------------------------------------------------

Views and Controllers
---------------------

### Request-response ###

``` shell
           request
/--------\ -------> /--------\
| Client |          | Server |
\--------/ <------- \--------/
           response
```

1. The **client** (e.g. web browser) sends a **request** to a server
2. The **server** (e.g. web server ) returns a **response** to the client

### Rails request-response lifecycle ###

``` shell
               request
/------------\ -------> /------------------------------\
| ---------- |          | ---------------------------- |
| | Client | |          | | Server                   | |
| ---------- |          | ---------------------------- |
|            |          |  |1                     ^    |
|            |          |  v       2              |9   |
|            |          | [Router] -> [[[Controller]]] |
|            |          |              |3  ^     |7 ^  |
|            |          |              v   |6    v  |8 |
|            |          |             [Model]   [View] |
|            |          |              |4  ^           |
|            |          |              v   |5          |
|            |          |             [Database]       |
\------------/ <------- \------------------------------/
               response
```

1. Once the server receives a request, it passes the request to the **router**
2. The **router** dispatches the request to the **controller**
3. The **controller** extracts the request to the **model**
4. The **model** connects to the **database**
5. The **database** transacts with the **model**
6. The **model** informs the changes to the **controller**
7. The **controller** passes the information to the **views**
8. The **views** generates the response and passes it to the **controller**
9. The **controller** passes the response to the server; returning it to the client

### Creating static app ###

1. Visit the desired URL (e.g. <http://localhost:3000/pages>)
   <br />You should get an error:

   ``` html
Routing Error

No route matches [GET] "/pages"
```

2. Create a connection to a Controller#Action pair:

   ``` ruby
# File: config/routes.rb
Rails.application.routes.draw do
  get "pages" => "pages#index"
end
```
   **Notes:**

   - The routes decides what controller#action pair to use on a URL pattern
   - The URL pattern should be plural as the controller name is plural

3. Reload the browser
   <br />You should get another error:

   ``` html
Routing Error

uninitialized constant PagesController
```
   **Note:** `uninitialized constant` implies that a controller file is missing.

4. Create a controller:

   ``` shell
$ rails g controller pages
Running via Spring preloader in process 54191
      create  app/controllers/pages_controller.rb
      invoke  erb
      create    app/views/pages
      invoke  test_unit
      create    test/controllers/pages_controller_test.rb
      invoke  helper
      create    app/helpers/pages_helper.rb
      invoke    test_unit
      invoke  assets
      invoke    scss
      create      app/assets/stylesheets/pages.scss
```
   **Notes:**

   - `g` is a shorthand for `generate`
   - The controller name must be plural

5. Reload the browser
   <br />You should get another error:

   ``` html
Routing Error

The action 'index' could not be found for PagesController
```
   **Note:** `Unknown action` implies that the action isn't defined in the controller.

6. Create a method corresponding to the controller action:

   ``` ruby
# File: app/controllers/pages_controller.rb
class PagesController < ApplicationController
  def index
  end
end
```

7. Reload the browser
   <br />You should get another error:

   ``` html
No template for interactive request

PagesController#index is missing a template for request formats: text/html
```
   **Notes:**

   - The controller looks for the file: `app/views/pages/index.html.erb`

8. Create the view:

   ``` shell
# File: app/views/pages/index.html.erb
$ echo '
<h1>Hello World!</h1>
' > app/views/pages/index.html.erb
```
   **Note:** Views use the [ERB](https://ruby-doc.org/stdlib-2.6.4/libdoc/erb/rdoc/ERB.html) templating system.

9. Reload the browser
   <br />You should see the text:

   ``` html
Hello World!
```

### Creating dynamic app ##

1. Prepare the data in the controller:

   ``` ruby
# File: app/controllers/pages_controller.rb
class PagesController < ApplicationController
  def index
    @title = "Hello World!"
    @messages = ["foo", "bar", "baz"]
  end
end
```
   **Note:** Instance variables (e.g. `@title`, `@messages`) contains the data that are passed to the views.

2. Render the instance variables in the views:

   ``` html
<%# File: app/views/pages/index.html.erb %>
<h1><%= @title %></h1>
<ul>
    <% @messages.each do |message|  %>
    <li><%= message %></li>
    <% end %>
</ul>
```
   **Notes:**

   - Use `<%# %>` to place a comment
   - Use `<%= %>` to do variable substitution
   - Use `<% %>` (scriptlets) to just execute blocks of Ruby code

3. Visit <http://localhost:3000/pages>
   <br />You should see the text:

   ``` html
Hello World!

* foo
* bar
* baz
```

**Notes:**

- The controller prepares the data
- The view simply renders the data

### Web server logs ###

- Every request-response cycle is logged in the console:

   ``` shell
Started GET "/pages" for ::1 at 2019-10-03 20:01:00 +0200
   (0.2ms)  SELECT sqlite_version(*)
Processing by PagesController#index as HTML
  Rendering pages/index.html.erb within layouts/application
  Rendered pages/index.html.erb within layouts/application (Duration: 0.4ms | Allocations: 170)
Completed 200 OK in 9ms (Views: 7.7ms | ActiveRecord: 0.0ms | Allocations: 6114)
```

- On development, all the logs will be stored at `log/development.log`

-------------------------------------------------------------------------------

Models
------

### Creating database ###

1. Create a model:

   ``` shell
$ rails g model page title:string message:string
Running via Spring preloader in process 63127
      invoke  active_record
      create    db/migrate/20191004093650_create_pages.rb
      create    app/models/page.rb
      invoke    test_unit
      create      test/models/page_test.rb
      create      test/fixtures/pages.yml
```
   **Notes:**

   - `g` is a shorthand for `generate`
   - The model name must be singular
   - Attributes are specified as `<field>:<type>`
   - Each model attributes represent a database column (except `id`, `created_at` and `updated_at`)


2. Create the table:

   ``` shell
# db/migrate/20191004101942_create_pages.rb
$ rails db:migrate
== 20191004101942 CreatePages: migrating ======================================
-- create_table(:pages)
   -> 0.0019s
== 20191004101942 CreatePages: migrated (0.0023s) =============================
```
   **Notes:**

   - Tables are created or modified only after the migration files are applied
   - Migration files are used to determine how to change the database schema
   - Migration files executes `.timestamp` which adds two timestamp columns (`created_at` and `updated_at`)
   - Migration is part of Rake tasks (type `rails -T` to see all Rake tasks or `rails -T db` for `db`-specific tasks)

3. Check migration status:

   ``` shell
$ rails db:migrate:status

database: db/development.sqlite3

 Status   Migration ID    Migration Name
--------------------------------------------------
   up     20191004101942  Create pages
```
   **Notes:**

   - Database configuration is found at `config/database.yml`
   - The database configuration determines the environment to use (`development`, `test`, or `production`)
   - By default, Rails uses the `development` environment

**Notes:**

- A corresponding table created is named plural
- A model wraps a table to conveniently perform [CRUD](https://en.wikipedia.org/wiki/Create,_read,_update_and_delete) operations
- The `id` column contains the primary key of each row
- The `created_at` column contains the timestamp when the row was created
- The `updated_at` column contains the timestamp when the row was modified

### Rails console ###

**Note:** The Rails console is a CLI to access the database thru an IRB session.

``` shell
$ rails c
```

**Notes:**

- `c` is a shorthand for `console`
- Type `exit` to exit from the console (or `ctrl+D`)
- Rails console loads the whole environment (e.g. `development`)
- Use the `reload!` method to reload the application without reopening the console

### Rails dbconsole ###

**Note:** The Rails dbconsole is also a CLI but does direct access to the database.

``` shell
$ rails db
```

**Notes:**

- `db` is a shorthand for `dbconsole`
- For SQLite, type `.quit` to exit from the dbconsole (or `ctrl+D`)

#### Direct database interaction ####

**Note:** These examples are for the SQLite database.

- List all tables:

  ``` sql
sqlite> .tables
ar_internal_metadata  pages  schema_migrations
```

- List schema of a table:

  ``` sql
sqlite> .schema pages
CREATE TABLE IF NOT EXISTS "pages" ...
```

- Display schema of the schema_migrations table:

  ``` sql
sqlite> .schema schema_migrations
CREATE TABLE IF NOT EXISTS "schema_migrations" ...
```

- Display all executed schema migrations:

  ``` sql
sqlite> SELECT * FROM schema_migrations;
20191004101942
```

### CRUD operations ###

#### Creating rows ####

1. Use the `new` method without arguments to create an object and update its attributes individually:

   ``` ruby
>> # Instantiate an object in memory:
>> p = Page.new
   (0.4ms)  SELECT sqlite_version(*)
=> #<Page id: ...

>> # Update attributes:
>> p.title = "Hello World!"
=> "Hello World!"
>> p.message = "Foo Bar Baz"
=> "Foo Bar Baz"

>> # Begin and commit transaction to database:
>> p.save
   (0.2ms)  begin transaction
  Page Create (0.7ms)  INSERT INTO "pages" ...
   (34.9ms)  commit transaction
=> true
```
   **Notes:**

   - When using the `new` method, the `save` method is required to perform database transactions
   - The return value `true` implies that the database transaction went successful

2. Use the `new` method with arguments (a hash) to create an object with updated attributes:

   ``` ruby
>> # Instantiate an object in memory:
>> p = Page.new(title: "Hello World!", message: "Foo Bar Baz")
=> #<Page id: ...

>> # Begin and commit transaction to database:
>> p.save
   (0.2ms)  begin transaction
  Page Create (0.8ms)  INSERT INTO "pages" ...
   (12.1ms)  commit transaction
 => true
```
   **Note:** Using the `new` method with arguments saves the time of updating attributes manually.

3. Use the `create` method to create an object with attributes and perform database transactions automatically:

   ``` ruby
>> # Instantiate an object in memory then begin and commit transaction to database:
>> p = Page.create(title: "Hello World!", message: "Foo Bar Baz")
   (0.2ms)  begin transaction
  Page Create (0.8ms)  INSERT INTO "pages" ...
   (11.4ms)  commit transaction
=> #<Page id: ...
```

#### Reading rows ####

- Use the `count` method to count all rows in the database:

  ``` ruby
>> Page.count
Page.count
   (0.4ms)  SELECT sqlite_version(*)
   (0.1ms)  SELECT COUNT(*) FROM "pages"
 => 1
```

- Use the `all` method to return all rows as objects:

  ``` ruby
>> Page.all
  Page Load (0.7ms)  SELECT "pages".* ...
=> #<ActiveRecord::Relation [#<Page id: ...
```

- Use the `find` method to find a row using the primary key:

  ``` ruby
>> Page.find(1)
  Page Load (0.2ms)  SELECT "pages".* ...
=> #<Page id: ...
```

- The `find` method will return an exception if the primary key does not exist:

  ``` ruby
>> Page.find(10)
  Page Load (0.3ms)  SELECT "pages".* ...
Traceback (most recent call last):
        1: from (irb):4
ActiveRecord::RecordNotFound (Couldn't find Page with 'id'=10)
```

- Use the `find_by` method to find a row with using a column name and its value:

  ``` ruby
>> Page.find_by(title: "Hello World!")
  Page Load (0.6ms)  SELECT "pages".* ...
 => #<Page id: ...
```

- The `find_by` method will return `nil` the column value does not exist:

  ``` ruby
>> Page.find_by(title: "Hello Universe!")
  Page Load (0.4ms)  SELECT "pages".* ...
=> nil
```

#### Updating rows ####

- Use the `update` method to update a row:

  ``` ruby
>> # Find a row from the database and get it as an object:
>> p = Page.find_by(title: "Hello World!")
  Page Load (0.4ms)  SELECT "pages".* ...
=> #<Page id: ...

>> # Update the column by updating the object's attributes:
>> p.update(message: "Baz Bar Foo")
   (0.2ms)  begin transaction
  Page Update (26.1ms)  UPDATE "pages" ...
   (12.2ms)  commit transaction
=> true
```

#### Deleting rows ####

- Use the `destroy` method to delete a row:

  ``` ruby
>> # Find a row from the database and get it as an object:
>> p = Page.find_by(title: "Hello World!")
  Page Load (0.4ms)  SELECT "pages".* ...
=> #<Page id: ...

>> # Delete a row:
>> p.destroy()
   (0.2ms)  begin transaction
  Page Destroy (0.7ms)  DELETE FROM "pages" ...
   (11.6ms)  commit transaction
 => #<Page id: ...
```

-------------------------------------------------------------------------------

Connecting MVC
--------------

### Putting the pieces together ###

1. Update the controller:

   ``` ruby
# File: app/controllers/pages_controller.rb
class PagesController < ApplicationController
  def index
    @pages = Page.all
  end
end
```
   **Notes:**

   - The `index` action is intended to display the **list** of all the rows of a table
   - The `Page` class is automatically available as part of the **convention**

2. Update the views:

   ``` html
<%# File: app/views/pages/index.html.erb %>
<ul>
    <% @pages.each do |p|  %>
    <li>
        <%= p.title %>: <%= p.message %>
    </li>
    <% end %>
</ul>
```

3. Visit <http://localhost:3000/pages>
   <br />You should see the text:

   ``` html
* Hello World!: Foo Bar Baz
```

### Separation of concerns ###

#### Model ####

- Transacts with the database table
- Returns table rows as objects to the controller
- Handles business logic (fat model, skinny controller)
- Doesn't know anything about the view

#### View ####

- Uses the data passed by the controller
- Generates an output to be sent back to the controller
- Doesn't know anything about the model

#### Controller ####

- Gets the data from the model
- Assigns the data as instance variables to the view
- Renders the view
- Decides what the model should do (but don't care how the model does it)
- Decides what views to render (but don't care how the views does it)

-------------------------------------------------------------------------------

Migrations
----------

- Create a new migration:

  ``` shell
$ rails g migration AddSlugExcerptToPages slug:string excerpt:string
Running via Spring preloader in process 306218
      invoke  active_record
      create    db/migrate/20191005184209_add_slug_excerpt_to_pages.rb
```
  **Notes:**

  - `g` is a shorthand for `generate`

  - The migation table name must be plural

  - Use the convention `Add<Columns>To<Model>s` when adding columns:
    <br />e.g.: `AddSlugExcerptToPages` generates `db/migrate/<timestamp>_add_slug_excerpt_to_pages.rb`

  - Use the convention `Remove<Columns>From<Model>s` when removing columns:
    <br />e.g.: `RemoveTitleContentFromPages` generates `db/migrate/<timestamp>_remove_slug_excerpt_from_pages.rb`

- Apply the new migration:

  ``` shell
$ rails db:migrate
== 20191005184209 AddSlugExcerptToPages: migrating ============================
-- add_column(:pages, :slug, :string)
   -> 0.0017s
-- add_column(:pages, :excerpt, :string)
   -> 0.0009s
== 20191005184209 AddSlugExcerptToPages: migrated (0.0028s) ===================
```

-------------------------------------------------------------------------------

View Helpers
------------

### Built-in methods ###

``` html
<%# File: app/views/pages/index.html.erb %>
<ul>
    <% @pages.each do |p|  %>
        <li>
            <a href="/<%= p.title.parameterize %>"><%= p.title %></a>
            <p><%= truncate(p.message, length: 1, separator: " ") %></p>
        </li>
    <% end %>
</ul>
```

**Notes:**

- Built-in view helpers are out-of-the box methods to help solve common view problems
- These methods are readily available in the view (e.g. `app/views/pages/index.html.erb`)
- In the above example, both `parametarize` and `truncate` are the built-in methods
- See [rails/actionview/lib/action_view/helpers](https://github.com/rails/rails/tree/master/actionview/lib/action_view/helpers) for the complete list of built-in view helpers

### Custom methods ###

1. Create a custom method in the view helper:

  ``` ruby
# File: app/helpers/pages_helper.rb
module PagesHelper
  def dunderify(page)
    page.title.parameterize.underscore
  end
end
```

2. Use it in the view:

``` html
<%# File: app/views/pages/index.html.erb %>
<ul>
    <% @pages.each do |p|  %>
        <li>
            <a href="/<%= dunderify(p) %>"><%= p.title %></a>
            <p><%= truncate(p.message, length: 1, separator: " ") %></p>
        </li>
    <% end %>
</ul>
```

**Notes:**

- Custom view helpers are manually created methods to help solve unique problems
- These custom methods are created in `app/helpers/pages_helper.rb`
- In the above example, the `dunder` method slugifies then separate words with underscore

### Business logic ###

1. Create a method in the model:

   ``` ruby
# File: app/models/page.rb
class Page < ApplicationRecord
  def has_crap?
    title.downcase =~ /crap/
  end
end
```
   **Note:** There's no need to put `self` before the `title` attribute since `self` refers to `Page` as context.

2. Create a method in the view helper using it:

   ``` ruby
# File: app/helpers/pages_helper.rb
module PagesHelper
  ...

  def title(page)
    if page.has_crap?
      "Not allowed"
    else
      page.title
    end
  end
end
```

3. Use it in the view:

   ``` ruby
<%# File: app/views/pages/index.html.erb %>
<ul>
    <% @pages.each do |p|  %>
        <li>
            <a href="/<%= dunderify(p) %>"><%= title(p) %></a>
            <p><%= truncate(p.message, length: 1, separator: " ") %></p>
        </li>
    <% end %>
</ul>
```

**Notes:**

- Business logic implements the unique business requirements (business rules)
- The business logic are created directly in the model (e.g. `app/models/page.rb`)
- In the above example, the `has_crap?` method check if the string has the word `crap`

-------------------------------------------------------------------------------

Layouts
-------

### Base ###



  ``` html
<%# File: app/views/layouts/application.html.erb %>
<!DOCTYPE html>
<html>
  <head>
    <title>Ror6Course</title>
    <%= csrf_meta_tags %>
    <%= csp_meta_tag %>

    <%= stylesheet_link_tag 'application', media: 'all', 'data-turbolinks-track': 'reload' %>
    <%= javascript_pack_tag 'application', 'data-turbolinks-track': 'reload' %>
  </head>

  <body>
    <%= yield %>
  </body>
</html>
```

**Notes:**

- The `csrf_meta_tags` generates a csrf token to protect from cross-site request forgery
- The `csp_meta_tag` generates a nonce to protect from replay attacks
- The `stylesheet_link_tag` generates the style sheet (css) link tag
- The `javascript_pack_tag` generates the javascript (js) script tag
- The `yield` is substituted according to the action file used (e.g. `index.html.erb`)

### Example ###

``` html
<%# File: app/views/layouts/application.html.erb %>
<!DOCTYPE html>
<html>
  <head>
    <title>Ror6Course</title>
    <%= csrf_meta_tags %>
    <%= csp_meta_tag %>
    <%= stylesheet_link_tag 'application', media: 'all', 'data-turbolinks-track': 'reload' %>
    <%= javascript_pack_tag 'application', 'data-turbolinks-track': 'reload' %>
  </head>
  <body>
    <header>
      <h1>Ror6Course</h1>
    </header>
    <main>
      <%= yield %>
    </main>
    <footer>
      <p>Copyright &copy;
        <%= Time.now.year %>
        <a href="/">Ror6Course</a>.
        Some rights reserved.
      </p>
    </footer>
  </body>
</html>
```

Let's continue to the second week: [Ruby on Rails 6: Week 2](ruby-on-rails-6-week-2).
