{:title       "Ruby on Rails 6: Week 5"
 :layout      :post
 :featured?   true
 :summary     "
              This document is the continuation of Ruby on Rails 6: Week 4 and will be about

              1) many-to-many associations,
              2) through associations,
              3) custom scopes and routes,
              4) friendly urls and callbacks
              and 5) deployment.
              "
 :excerpt     "This is the week 5 summary of the learned lessons from The Pragmatic Studio's Ruby on Rails 6 course."
 :description "Week 5 summary of the learned lessons from The Pragmatic Studio's Ruby on Rails 6 course."
 :date        "2019-11-10"
 :tags        ["research"
               "web-application-framework"
               "ruby-on-rails"
               "ruby"]}

-------------------------------------------------------------------------------

**Note:** This is the continuation of [Ruby on Rails 6: Week 4](ruby-on-rails-6-week-4).

This document will be the week 5 summary, the last week, of the learned lessons from [The Pragmatic Studio](https://pragmaticstudio.com)'s [Ruby on Rails 6](https://pragmaticstudio.com/courses/rails) course.

-------------------------------------------------------------------------------

Many-to-many Associations
-------------------------

**Notes:**
- A join model should have two foreign keys
- `<model_1>_id` references a row in the `<model_1>`'s table
- `<model_2> id` references a row in the `<model_2>`'s table
- The join model uses _one-to-many_ (`belongs_to`) relationship to connect the two models
- The joined models uses _many-to-many_ (`has_many`) relationship to connect to the join model

1. Create a new migration:

   ``` shell
$ rails g migration ChangeTagsToJoinTable
Running via Spring preloader in process 10644
      invoke  active_record
      create    db/migrate/20191110140201_change_tags_to_join_table.rb
```

2. Update migration file:

   ``` ruby
# File: db/migrate/<timestamp>_change_tags_to_join_table.rb
class ChangeTagsToJoinTable < ActiveRecord::Migration[6.0]
  def change
    add_column :tags, :user_id, :integer
    Tag.delete_all
  end
end
```
   **Notes:**

   - The `add_column` method takes three parameters (table, new column, and column type)
   - The model name referenced should be singular followed by `_id` suffix (e.g. `user_id`)
   - The `delete_all` method, without parameters, removes all the records of the mapped table
   - The column type must be provided to be able to roll back a dropped table

3. Apply migration:

   ``` shell
$ rails db:migrate
```

4. Update the models:

   ``` ruby
# File: app/models/tag.rb
class Tag < ApplicationRecord
  ...
  belongs_to :user
  ...
end
```

   ``` ruby
# File: app/models/user.rb
class User < ApplicationRecord
  has_many :tags, dependent: :destroy
  ...
end
```

   ``` ruby
# File: app/models/page.rb
class User < ApplicationRecord
  has_many :tags, dependent: :destroy
  ...
end
```

5. Open Rails console:

   ``` shell
$ rails c
```

6. Check that associations exists:

   ``` shell
 > Tag.column_names
=> ["id", "name", "page_id", ... "user_id"]
```
   **Note:** The `page_id` and `user_id` are the associations to `Page` and `User` models.

7. Test the associations:

   ``` ruby
 > tag = Tag.new(name: "hashtag")
  (0.4ms)  SELECT sqlite_version(*)
=> #<Tag id: nil, name: "hashtag", page_id: nil, ... user_id: nil>

 > tag.user
=> nil

 > tag.page
=> nil
```
   **Note:** Both `tag.user` and `tag.page` currently returns `nil` since their models aren't yet attached.

8. Associate a page and user:

   ``` ruby
 > user = User.create(username: "foo", password: "bar")
   (0.1ms)  begin transaction
   User Exists? (0.2ms)  SELECT 1 AS one FROM "users" ...
   User Create (0.2ms)  INSERT INTO "users" ...
   (11.8ms)  commit transaction
=> #<User id: 1, username: "foo", ...

 > tag.user = user
=> #<User id: 1, username: "foo", ...

 > page = Page.create(title: "Hello World!", message: "Halo there!")
   (0.1ms)  begin transaction
   Page Create (0.5ms)  INSERT INTO "pages" ...
   (10.9ms)  commit transaction
=> #<Page id: 1, title: "Hello World!", ...

 > tag.page = page
=> #<Page id: 3, title: "Hello World!", ...

 > tag.save
   (0.2ms)  begin transaction
   Tag Create (0.7ms)  INSERT INTO "tags" ...
   (35.5ms)  commit transaction
=> true
```
   **Note:** The `belongs_to` returns the direct associated entity (row).

9. Test association of page and user the other way:

   ``` ruby
 > user = User.find_by(username: "foo")
   User Load (0.4ms)  SELECT "users".* FROM "users" ...
=> #<User id: 1, username: "foo", ...
 > user.tags
   Tag Load (0.3ms)  SELECT "tags".* FROM "tags" ...
=> #<ActiveRecord::Associations::CollectionProxy [#<Tag id: 1, name: "hashtag", ...

 > page = Page.find_by(title: "Hello World!")
   Page Load (0.2ms)  SELECT "pages".* FROM "pages" ...
=> #<Page id: 1, title: "Hello World!", ...
 > page.tags
   Tag Load (0.2ms)  SELECT "tags".* FROM "tags" ...
=> #<ActiveRecord::Associations::CollectionProxy [#<Tag id: 1, name: "hashtag", ...
```
   **Note:** The `has_many` returns an array of associated entities (rows).

-------------------------------------------------------------------------------

Through Associations
--------------------

### through ###

**Note:** The `through` option is used to bypass the join model and access the other end model.

1. Access user from page:

   ``` ruby
 > page = Page.find_by(title: "Hello World!")
   Page Load (0.1ms)  SELECT "pages".* FROM "pages" ...
=> #<Page id: 1, ...
 > page.tags.each { |tag| tag.user.username }
  Tag Load (0.1ms)  SELECT "tags".* FROM "tags" ...
  User Load (0.1ms)  SELECT "users".* FROM "users" ...
=> [#<Tag id: 1, name: "hashtag", page_id: 1, ... user_id: 1>]
```
   **Note:** Notice that it required two database hits (1 from `tag` and 1 from `user`).

2. Access page from user:

   ``` ruby
 > user = User.find_by(username: "foo")
   User Load (0.1ms)  SELECT "users".* FROM "users" ...
=> #<User id: 1, username: "foo", ...
 > user.tags.each { |tag| tag.page.title }
   Tag Load (0.1ms)  SELECT "tags".* FROM "tags" ...
   Page Load (0.1ms)  SELECT "pages".* FROM "pages" ...
=> [#<Tag id: 1, name: "hashtag", page_id: 1, ... user_id: 1>]
```
   **Note:** This should have same effect as above.

3. Update the models:

   ``` ruby
# File: app/models/page.rb
class Page < ApplicationRecord
  ...
  has_many :users, through: :tags
  ...
end
```

   ``` ruby
# File: app/models/user.rb
class User < ApplicationRecord
  ...
  has_many :pages, through: :tags
  ...
end
```

4. Open Rails console:

   ``` shell
$ rails c
```

5. Access user from page:

   ``` ruby
 > page = Page.find_by(title: "Hello World!")
   Page Load (0.1ms)  SELECT "pages".* FROM "pages" ...
=> #<Page id: 1, title: "Hello World!", ...
 > page.users
   User Load (0.1ms)  SELECT "users".* FROM "users" ...
=> #<ActiveRecord::Associations::CollectionProxy [#<User id: 1, ...
```

6. Access page from user:

   ``` ruby
 > user = User.find_by(username: "foo")
   User Load (0.2ms)  SELECT "users".* FROM "users" ...
=> #<User id: 1, username: "foo", ...
 > user.pages
   Page Load (0.2ms)  SELECT "pages".* FROM "pages" ...
=> #<ActiveRecord::Associations::CollectionProxy [#<Page id: 1, ...
```

**Note:** Not only the other model can be accessed easily, it also hits the database only once.

### source ###

**Note:** The `source` option allows renaming of the models being associated.

1. Update the models:

   ``` ruby
# File: app/models/page.rb
class Page < ApplicationRecord
  ...
  has_many :authors, through: :tags, source: :user
  ...
end
```

   ``` ruby
# File: app/models/user.rb
class User < ApplicationRecord
  ...
  has_many :posts, through: :tags, source: :page
  ...
end
```
   **Notes:**

   - The alias is plural (`:authors`, `:posts`)
   - The `source` is singular (`:user`, `:page`)

4. Open Rails console:

   ``` shell
$ rails c
```

5. Access user from page:

   ``` ruby
 > page = Page.find_by(title: "Hello World!")
   (0.1ms)  SELECT sqlite_version(*)
   Page Load (0.2ms)  SELECT "pages".* FROM "pages" ...
=> #<Page id: 1, title: "Hello World!", ...
 > page.authors
   User Load (0.1ms)  SELECT "users".* FROM "users" ...
=> #<ActiveRecord::Associations::CollectionProxy [#<User id: 1, ...
```

5. Access page from user:

   ``` ruby
 > user = User.find_by(username: "foo")
   User Load (0.2ms)  SELECT "users".* FROM "users" ...
=> #<User id: 1, username: "foo", ...
 > user.posts
   Page Load (0.2ms)  SELECT "pages".* FROM "pages" ...
=> #<ActiveRecord::Associations::CollectionProxy [#<Page id: 1, ...
```

### Checkboxes ###

An example of implementing many-to-many relationship on checkboxes.

1. Create a new resource:

   ``` shell
$ rails g resource category title
```

2. Apply migration:

   ``` shell
$ rails db:migrate
```

3. Update the model:

   ``` ruby
# File: app/models/category.rb
class Category < ApplicationRecord
  validates :title, presence: true, uniqueness: true
end
```

4. Create a join model:

   ```
$ rails g model categorization page:references category:references
Running via Spring preloader in process 10482
      invoke  active_record
      create    db/migrate/<timestamp>_create_categorizations.rb
      create    app/models/categorization.rb
      invoke    test_unit
      create      test/models/categorization_test.rb
      create      test/fixtures/categorizations.yml
```
   **Note:** `<model>:references` will resolve to `<model>_id` as foreign keys.

5. Apply migration:

   ``` shell
$ rails db:migrate
```

6. Update the associated models:

   ``` ruby
# File: app/models/page.rb
class Page < ApplicationRecord
  ...
  has_many :categorizations, dependent: :destroy
  has_many :categoris, through: :categorizations
  ...
end
```

   ``` ruby
# File: app/models/category.rb
class Category < ApplicationRecord
  ...
  has_many :categorizations, dependent: :destroy
  has_many :pages, through: :categorizations
  ...
end
```

7. Open Rails console:

   ``` shell
$ rails c
```

8. Test the associations:

   1. Create categories:

      ``` ruby
 > Category.create([
     {title: "Music"},
     {title: "Art"},
     {title: "Math"},
     {title: "Sports"},
     {title: "Philosophy"},
     {title: "Science"}
 ])
    (0.6ms)  SELECT sqlite_version(*)
    (0.1ms)  begin transaction
   Category Exists? (0.3ms)  SELECT 1 AS one FROM "categories" ...
   Category Create (0.3ms)  INSERT INTO "categories" ("title", ...
    (10.1ms)  commit transaction
    (0.1ms)  begin transaction
   Category Exists? (0.2ms)  SELECT 1 AS one FROM "categories" ...
   Category Create (0.2ms)  INSERT INTO "categories" ("title", ...
    (9.6ms)  commit transaction
    (0.1ms)  begin transaction
   Category Exists? (0.2ms)  SELECT 1 AS one FROM "categories" ...
   Category Create (0.2ms)  INSERT INTO "categories" ("title", ...
    (9.3ms)  commit transaction
    (0.1ms)  begin transaction
   Category Exists? (0.2ms)  SELECT 1 AS one FROM "categories" ...
   Category Create (0.2ms)  INSERT INTO "categories" ("title", ...
    (8.3ms)  commit transaction
    (0.1ms)  begin transaction
   Category Exists? (0.2ms)  SELECT 1 AS one FROM "categories" ...
   Category Create (0.3ms)  INSERT INTO "categories" ("title", ...
    (9.4ms)  commit transaction
    (0.1ms)  begin transaction
   Category Exists? (0.2ms)  SELECT 1 AS one FROM "categories" ...
   Category Create (0.2ms)  INSERT INTO "categories" ("title", ...
    (9.7ms)  commit transaction
=> [#<Category id: 1, title: "Music", ...
```

   2. Associate a category to a page:

      ``` ruby
 > page = Page.find_by(title: "Hello World!")
   Page Load (0.2ms)  SELECT "pages".* FROM "pages" ...
=> #<Page id: 1, title: "Hello World!", ...
 > category = Category.find_by(title: "Philosophy")
   Category Load (0.5ms)  SELECT "categories".* FROM "categories" ...
=> #<Category id: 5, title: "Philosophy", ...
 > page.categories << category
   (0.2ms)  begin transaction
   Categorization Create (1.0ms)  INSERT INTO "categorizations" ...
   (10.9ms)  commit transaction
   Category Load (0.2ms)  SELECT "categories".* FROM "categories" ...
=> #<ActiveRecord::Associations::CollectionProxy [#<Category id: 5, title: "Philosophy", ...
```
   **Note:** `<<` is a shortcut for `push` method (e.g. `page.categories.push(category)`).

   3. Associate categories thru `<model>_ids`:

      ``` ruby
 > page.category_ids = [1, 2, 5]
   Category Load (0.8ms)  SELECT "categories".* FROM "categories" ...
   Category Load (0.5ms)  SELECT "categories".* FROM "categories" ...
   (0.2ms)  begin transaction
   Categorization Create (0.8ms)  INSERT INTO "categorizations" ...
   Categorization Create (0.4ms)  INSERT INTO "categorizations" ...
   (34.1ms)  commit transaction
 => [1, 2, 5]
2.6.3 :016 >
```
      **Note:** Assign an array containing IDs `category_ids` attribute.

   4. Empty associated categories with an empty array (`[]`):

      ``` ruby
 > page.category_ids = []
   Category Load (0.5ms)  SELECT "categories".* FROM "categories" ...
   (0.2ms)  begin transaction
   Categorization Destroy (0.9ms)  DELETE FROM "categorizations" ...
   (35.2ms)  commit transaction
=> []
```

9. Update partial view (`_form`):

   ``` ruby
<%# File: app/views/pages/_form.html.erb %>
<%= form_with(model: page, local: true) do |form| %>
    ...
    <%= form.collection_check_boxes(:category_ids, Category.all, :id, :title) %>
    ...
<% end %>
```

10. Update the controller:

   ``` ruby
# File: app/controllers/pages_controller.rb
class PagesController < ApplicationController
  ...
  def page_params
    params.require(:page).permit(
      ...
      category_ids: []
    )
  end
end
```
   **Notes:**

   - `category_ids` is not a keyword
   - It must have an empty array as initial value

-------------------------------------------------------------------------------

Custom Scopes and Routes
------------------------

**Notes:**

- `scope` allows for naming a query (e.g. `:recent`)
- `scope`s can be chained with other `scope`s
- `scope` names can be called by either the model or associated objects
- Chained `scope`s only executes a single database query

<div></div>

1. Update the model:

   - Without arguments:

     ``` ruby
# File: app/models/category.rb
class Category < ApplicationRecord
  ...
  scope :recent, -> { where("created_at < ?", Time.now).order("id desc") }
end
```
     **Note:** `->` is a shortcut for `lambda` that wraps a block for later use (lazy evaluated).

   - With Arguments:

        ``` ruby
# File: app/models/category.rb
class Category < ApplicationRecord
  ...
  scope :recent, ->(n=5) { where("created_at < ?", Time.now).order("id desc").limit(n) }
  scope :contains, ->(s="") { where("title LIKE ?", "%#{s}%") .all }
end
```

2. Open Rails console:

   ``` shell
$ rails c
```

3. Invoke `scope` name:

   ``` ruby
 > # Without arguments:
 > Category.recent
   Category Load (0.5ms)  SELECT "categories".* FROM "categories" ...
=> #<ActiveRecord::Relation [#<Category id: 6, ...
 > Category.recent.size
   (0.4ms)  SELECT COUNT(*) FROM (SELECT 1 AS one FROM "categories" ...
=> 5

 > # With arguments:
 > Category.recent(3)
   Category Load (0.5ms)  SELECT "categories".* FROM "categories" ...
=> #<ActiveRecord::Relation [#<Category id: 6, title: "Science", ...
 > Category.recent(3).size
   (0.6ms)  SELECT COUNT(*) FROM (SELECT 1 AS one FROM "categories" ...
=> 3
```

4. Chaining `scope`s:

   ``` ruby
 > Category.recent(3).contains("P")
   Category Load (0.2ms)  SELECT "categories".* FROM "categories" ...
=> #<ActiveRecord::Relation [#<Category id: 5, title: "Philosophy", ...
 > Category.recent(3).contains("P").size
   (0.5ms)  SELECT COUNT(*) FROM (SELECT 1 AS one FROM "categories" ...
=> 2
```

5. Call by an associated object:

   ``` ruby
 > page = Page.find_by(title: "Hello World!")
   Page Load (0.6ms)  SELECT "pages".* FROM "pages" ...
=> #<Page id: 1, title: "Hello World!", ...
 > page.categories.contains("s")
   Category Load (0.7ms)  SELECT "categories".* FROM "categories" ...
=> #<ActiveRecord::AssociationRelation [#<Category id: 1, title: "Music", ...
 > page.categories.contains("s").size
   (0.5ms)  SELECT COUNT(*) FROM "categories" ...
=> 2
```

6. Using `lambda` on model:

   ``` ruby
# File: app/models/category.rb
class Category < ApplicationRecord
  has_many :categorizations, -> { order(created_at: :desc) }, dependent: :destroy
  ...
end
```
   **Note:** `lambda`s can be used as a second parameter on `has_many` method.

-------------------------------------------------------------------------------

Friendly URLs and Callbacks
---------------------------

**Notes:**

- A friendly URL (a.k.a. vanity URL) is a URL that is both descriptive and memorable
- Instead of using numbers to represent entities, a human-readable equivalent is used

<div></div>

1. Create a new migration:
   <br />**Note:** Add a slug column to store the human-readable equivalent of the entity.

   ``` shell
$ rails g migration AddSlugToPages slug
Running via Spring preloader in process 14838
      invoke  active_record
      create    db/migrate/20191112213418_add_slug_to_pages.rb
```

2. Apply migration:

   ``` shell
$ rails db:migrate
== 20191112213418 AddSlugToPages: migrating ===================================
-- add_column(:pages, :slug, :string)
   -> 0.0025s
== 20191112213418 AddSlugToPages: migrated (0.0026s) ==========================
```

3. Update the model:

   ``` ruby
# File: app/models/page.rb
class Page < ApplicationRecord
  before_save :set_slug
  ...
  validates :title, presence: true, uniqueness: true
  ...
  private

  def set_slug
    self.slug = title.parameterize
  end
end
```
   **Notes:**

   - Make sure the column that the slug will refer to is unique (e.g. `.title`)
   - The `parameterize` method removes special characters from a string
   - The `parameterize` method, by default, separate words with a comma
   - The `parameterize` method, in this case, is used to make the friendly-URLs as slug
   - The `self` in `self.slug` indicates that it's an attribute not a local variable
   - The `self` in `self.slug` should only be used when writing to an attribute not when reading
   - The `before_save` method executes the callback (`set_slug`) before `save` (`create` or `update`)

4. Open Rails console:

   ``` shell
$ rails c
```

5. Test the `before_save` callback:

   ``` ruby
 > page = Page.create(title: "My Foo", message: "Foo bar baz")
   (0.1ms)  begin transaction
   Page Exists? (0.1ms)  SELECT 1 AS one FROM "pages" ...
   Page Create (0.3ms)  INSERT INTO "pages" ("title", "message", "created_at", "updated_at", "slug") VALUES (?, ?, ?, ?, ?)  [["title", "My Foo"], ["message", "Foo bar baz"], ["created_at", "2019-11-12 22:49:54.461300"], ["updated_at", "2019-11-12 22:49:54.461300"], ["slug", "my-foo"]]
   (8.6ms)  commit transaction
=> #<Page id: 3, title: "My Foo", ...
 > page.slug
=> "my-foo"
```

6. Add slug on all of existing entities:

   ``` ruby
> Page.all.each { |p| p.save }
  Page Load (0.4ms)  SELECT "pages".* FROM "pages"
  (0.1ms)  begin transaction
  Page Exists? (0.2ms)  SELECT 1 AS one FROM "pages" ...
  Page Update (0.5ms)  UPDATE "pages" SET "slug" = ?, "updated_at" = ? ...
  (9.9ms)  commit transaction
  (0.1ms)  begin transaction
  Page Exists? (0.2ms)  SELECT 1 AS one FROM "pages" ...
  Page Update (0.3ms)  UPDATE "pages" SET "slug" = ?, "updated_at" = ? ...
  (8.4ms)  commit transaction
  (0.1ms)  begin transaction
  Page Exists? (0.2ms)  SELECT 1 AS one FROM "pages" ...
  (0.1ms)  commit transaction
=> [#<Page id: 1, title: "Hello World!", ...
```

7. Check an attribute of all entities:

   ``` ruby
 > Page.pluck(:slug)
   (0.9ms)  SELECT sqlite_version(*)
   (0.2ms)  SELECT "pages"."slug" FROM "pages"
=> ["hello-world", "crappy-world", "my-foo"]
```
   **Note:** The `pluck` method returns an array from one or more specified attributes without loading all the records.

8. Test the `to_param` method:

   ``` ruby
 > page.to_param
=> "3"
```
   **Note:** The `to_param` method returns the entity ID that is used in the URLs.

9. Update the model:

   ``` ruby
class Page < ApplicationRecord
  ...
  def to_param
    slug
  end

  private
  ...
end
```
   **Note:** Override the `to_param` method use a slug instead of the default number.

10. Go back to console and test `to_param`:

   ``` ruby
 > reload!
 Reloading...
=> true

 > page.to_param
=> "my-foo"

 > app.page_path(page)
=> "/pages/my-foo"
```

11. Update the controller:

    ``` ruby
# File: app/controllers/pages_controller.rb
class PagesController < ApplicationController
  before_action :set_page, exclude: [:index, :new, :create]
  ...
  private
  ...
  def set_page
    @page = Page.find_by(slug: params[:id])
  end
end
```
    **Notes:**

    - Be sure to remove the occurence of `@page = Page.find(params[:id])` on resources with existing entity
    - The slug only applies to resource that contains an existing entity (hence, the `exclude`)

12. Check that `/my-foo` works:
    <br />Visit <http://localhost:3000/pages/my-foo>.

-------------------------------------------------------------------------------

Deployment
----------

### Environments ###

| Setup              | Development                          | Production                          |
| ------------------ | :----------------------------------- | :---------------------------------- |
| Config file        | `config/environments/development.rb` | `config/environments/production.rb` |
| Database           | SQLite                               | PostgreSQL                          |
| Logging            | Verbose                              |                                     |
| Auto-reload        | &#10004;                             |                                     |
| Caching            |                                      | &#10004;                            |
| Exceptions         | &#10004;                             |                                     |
| Error Pages        |                                      | &#10004;                            |
| Precompiled Assets |                                      | &#10004;                            |

**Notes:**

- Heroku auto-generates the `database.yml` that will be used with PostgreSQL database
- ^ there's no need to change the production environment settings in `config/database.yml`

### Preparation ###

1. Update the `Gemfile`:

   1. Put `sqlite3` gem in `development` and `test` group:

      ``` ruby
...
group :development, :test do
  gem 'sqlite3', '~> 1.4'
end
...
```

   2. Add `pg` gem in `production` group:
      <br />**Note:** `pg` is an adapter to interact with a PostgreSQL database.

      ``` ruby
...
group :production do
  gem 'pg'
end
...
```

2. Update the `Gemfile.lock`:

   ``` shell
$ bundle install --without production
```
   **Notes:**

   - Installing the new gems will update the `Gemfile.lock` file
   - The `--without production` excludes gems to be installed in our local environment (`:development`)
   - Heroku uses the `Gemfile.lock` to install the gems (including `production` gems) when the app gets deployed
   - On production, assets should end with an extension (e.g. `image_tag("logo")` to `image_tag("logo.png")`)

### Deployment ###

1. Stage and commit files:

   ``` shell
$ \
git add -A
git commit -m 'Initial deployment'
```

2. [Sign up](https://signup.heroku.com) (if not registered)

3. Install [Heroku CLI](https://devcenter.heroku.com/articles/heroku-cli)

4. Log in (interactively):

   ``` shell
$ heroku login -i
heroku: Enter your login credentials
Email [username@domain.ext]:
Password: ************
Logged in as username@domain.ext
```
   **Notes:**

   - `-i` is a shortcut for `--interactive`
   - `-i` uses the terminal-based login flow instead of opening a web browser

5. Create the Heroku repository:

   ``` shell
$ heroku create
Creating app... ⣾
Creating app... done, ⬢ <app>
https://<app>.herokuapp.com/ | https://git.heroku.com/<app>.git
```
   **Note:** `create` without any parameters creates a repo in Heroku with a random name.

6. Push the local changes to remote repo:

   ``` shell
$ git push heroku master
```
   **Notes:**

   - `master` is the branch we want to push from our local repo
   - Pushing to Heroku installs all the required gems (including the production gems)
   - ^ It precompiles assets such as images, styles and scripts

7. Apply migrations on production:

   ``` shell
$ heroku run rails db:migrate
```
   **Notes:**

   - `heroku run` executes a one-time process in a Heroku `<app>`
   - An `<app>` in Heroku runs inside a container called a **dyno**

8. Apply seed data on production:

   ``` shell
$ heroku run rails db:seed
```

9. Open the `<app>` with the default browser:

   ``` shell
$ heroku open
```

### Heroku commands ###

| Command    | Description                             |
| :--------- | :-------------------------------------- |
| `login`    | Log in to Heroku (browser)              |
| `login -i` | Log in to Heroku (shell)                |
| `create`   | Create a new Heroku app                 |
| `open`     | Open Heroku app with default browser    |
| `run`      | Execute a one-time process in container |
| `apps`     | List all of the Heroku apps             |
| `ps`       | Show the Heroku app status              |
| `logs`     | Show the Heroku app logs                |
| `logs -t`  | Show the Heroku app logs continuously   |
| `rename`   | Rename the Heroku app                   |
| `destroy`  | Destroy the Heroku app                  |

**Congratulations!** We've finally finished the course and learned enough `Ruby on Rails` :)
