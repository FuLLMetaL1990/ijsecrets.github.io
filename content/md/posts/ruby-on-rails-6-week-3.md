{:title       "Ruby on Rails 6: Week 3"
 :layout      :post
 :summary     "
              This document is the continuation of Ruby on Rails 6: Week 2 and will be about

              1) custom queries,
              2) migrations revisited,
              3) model validations,
              4) handling validation errors,
              5) the flash
              and 6) one-to-many relationships.
              "
 :excerpt     "This is the week 3 summary of the learned lessons from The Pragmatic Studio's Ruby on Rails 6 course."
 :description "Week 3 summary of the learned lessons from The Pragmatic Studio's Ruby on Rails 6 course."
 :date        "2019-10-13"
 :tags        ["research"
               "web-application-framework"
               "ruby-on-rails"
               "ruby"]}

-------------------------------------------------------------------------------

**Note:** This is the continuation of [Ruby on Rails 6: Week 2](ruby-on-rails-6-week-2).

This document will be the week 3 summary of the learned lessons from [The Pragmatic Studio](https://pragmaticstudio.com)'s [Ruby on Rails 6](https://pragmaticstudio.com/courses/rails) course.

The number of lessons look lesser but in fact, the last lesson consists of multiple videos explaining [Active Record Associations](https://edgeguides.rubyonrails.org/association_basics.html) in Rails.

-------------------------------------------------------------------------------

Custom Queries
--------------

### Rails console ###

Open the Rails console (`rails c` ) then do the following:

- Use the `where` method of a model (e.g. `Page`) to do custom queries:

  ``` ruby
 > Page.where("title = ?", "Hello World!")
   Page Load (0.6ms)
   SELECT "pages".* FROM "pages"
   WHERE (title = 'Hello World!')
   LIMIT ?  [["LIMIT", 11]]
=> #<ActiveRecord::Relation [#<Page id: 1, ...
```
  **Notes:**

  - The question mark (`?`) acts as the placeholder for the value
  - The `where` method maps the `WHERE` clause of an SQL query

- Use the `order` method to order the mapped objects of the model:

  ``` ruby
 > Page.order("id desc")
   Page Load (0.6ms)
   SELECT "pages".* FROM "pages"
   ORDER BY id desc
   LIMIT ?  [["LIMIT", 11]]
=> #<ActiveRecord::Relation [#<Page id: 2, ...
```
  **Notes:**

  - The `order` method maps the `ORDER BY` clause of an SQL query
  - Similar in SQL, an optional sorting (`asc` or `desc`) can be included

- Custom queries can be chained together:

  ``` ruby
 > Page.where("title LIKE ?", "%world%").order("id desc")
   Page Load (0.6ms)
   SELECT "pages".* FROM "pages"
   WHERE (title LIKE '%world%')
   ORDER BY id desc
   LIMIT ?  [["LIMIT", 11]]
 => #<ActiveRecord::Relation [#<Page id: 2, ...
```
  **Notes:**

  - Use the placeholder to convert Ruby date type to SQL date type
  - Use the placeholder on number literals with underscores (e.g. `9_000`)
  - The `where` method also accepts comma-separated hashes (e.g. `id: 1`)
  - The `order` method also accepts a hash and keyword pair (e.g. `id: :asc`)

- Use the `to_sql` to preview the generated SQL without running the query:

  ``` ruby
 > Page.where("title LIKE ?", "%world%").order("id desc").to_sql
=> "SELECT \"pages\".* FROM \"pages\" WHERE (title LIKE '%world%') ORDER BY id desc"
```

### Model and Controller ###

1. Update the model:

   ``` ruby
# File: app/models/page.rb
class Page < ApplicationRecord
  ...
  def self.with_world
    where("title LIKE ?", "%world%").order("id desc")
  end
end
```
   **Notes:**

   - The `self` identifies the method as a class method
   - A class method, unlike instance method can only be called directly
   - Unlike class method, the instance method can only be called in an instance
   - The model should be the only one in MVC to decide how to manage the data

2. Update the controller:

   ``` ruby
# File: app/controllers/pages_controller.rb
class PagesController < ApplicationController
  def index
    @pages = Page.with_world
  end
  ...
end
```
   **Note:** The controller only defers the data received from the model to the view.

-------------------------------------------------------------------------------

Migrations Revisited
--------------------

1. Create a new migration:

   ``` shell
$ rails g migration AddImagePathToPage image_path:string
Running via Spring preloader in process 9443
      invoke  active_record
      create    db/migrate/20191015181055_add_image_path_to_page.rb
```
   **Notes:**

   - It will generate the file `db/migrate/<timestamp>_add_<field>_to_<model>.rb`
   - To **add**, Use the format `Add<Field>To<Model>`, separating fields by `Add`
   - To **remove**, Use the format `Remove<Field>From<Model>`, also separated by `Add`

2. Set default values by editing the migration file

   ``` ruby
# File: db/migrate/20191015181055_add_image_path_to_page.rb
class AddImagePathToPage < ActiveRecord::Migration[6.0]
  def change
    add_column :pages, :image_path, :string, default: "placeholder.png"
  end
end
```
   **Note** Default values cannot be specified in CLI (a reason to edit the file).

3. Apply the migration:

   ``` shell
$ rails db:migrate
== 20191015181055 AddImagePathToPage: migrating ===============================
-- add_column(:pages, :image_path, :string, {:default=>"placeholder.png"})
   -> 0.0017s
== 20191015181055 AddImagePathToPage: migrated (0.0017s) ======================
```
   **Note:** It will update the `db/schema.rb` file.

4. Or undo the last migration:

   ``` shell
$ rails db:rollback
== 20191015181055 AddImagePathToPage: reverting ===============================
-- remove_column(:pages, :image_path, :string, {:default=>"placeholder.png"})
   -> 0.0220s
== 20191015181055 AddImagePathToPage: reverted (0.0505s) ======================
```
   **Notes:**

   - All the data of the removed column will be lost
   - It's normal to do a rollback to edit the migration file then re-apply migration

-------------------------------------------------------------------------------

Model Validations
-----------------

### Model ###

**Note:** Validation is an example of a business rule.

- Use the `validates` method to validate an attribute:

  ``` ruby
# File: app/models/page.rb
class Page < ApplicationRecord
  validates :title, presence: true
...
end
```
  **Notes:**

  - `:title` is the model attribute to validate
  - `presence: true` is a hash which is a validator
  - Multiple model attributes and validators can be put together, separated by comma (`,`)
  - Model attributes must be on the left while validators must be on the right
  - Some validators can have multiple options provided within a hash
  - When using [regex](https://en.wikipedia.org/wiki/Regular_expression), use `\A` instead of `^` and `\z` instead of `$`

### Console ###

Open the Rails console (`rails c` ) then do the following:

- Create an instance then save to notice a problem:

  ``` ruby
 > p = Page.new
=> #<Page id: nil, ...

 > p.save
=> false
```
  **Note:** A return of `false` implies that the instance is not committed to the database.

- Use the `errors` method to inspect for possible errors:

  ``` ruby
 > p.errors
 => #<ActiveModel ...
 @messages={:title=>["can't be blank"]},
 @details={:title=>[{:error=>:blank}]}>
```

- Specify the model attribute key to limit the error with a model attribute:

  ``` ruby
 > p.errors[:title]
=> ["can't be blank"]
```

- Use the `errors.full_messages` methods to only get error messages:

  ``` ruby
 > p.errors.full_messages
=> ["Title can't be blank"]
```

- Use the `errors.full_messages.to_sentence` methods to merge them to one sentence:

  ``` ruby
 > p.errors.full_messages.to_sentence
=> "Title can't be blank"
```

- Use `errors.any?` methods to check if an instance has any errors:

  ``` ruby
 > p.errors.any?
=> true
```

-------------------------------------------------------------------------------

Handling Validation Errors
--------------------------

- Update the controller's `create` and `update` methods:

  ``` ruby
# File: app/controllers/pages_controller.rb
class PagesController < ApplicationController
  ...
    def update
    @page = Page.find(params[:id])

    if @page.update(page_params)
      redirect_to @page
    else
      render :edit
    end
  end
  ...
  def create
    @page = Page.new(page_params)

    if @page.save
      redirect_to @page
    else
      render :new
    end
  end
  ...
end
```
  **Notes:**

  - The `update` and `save` methods return a boolean that can be used in the condition
  - The `create` method was replaced with `new` since we need an instance to refer to
  - The `:edit` and `:new` keywords re-displays the forms re-populated with only valid submitted values

- Create a shared partial:

  ``` shell
$ \
mkdir -p app/views/shared/
echo '
<% if object.errors.any? %>
    <h2>Submit failed!</h2>
    <ul>
        <% object.errors.full_messages.each do |message| %>
            <li><%= message %></li>
        <% end %>
    </ul>
<% end %>
' > app/views/shared/_errors.html.erb
```
  **Notes:**

  - The `shared/` directory can be any name
  - It is intended for re-usable partials for the whole app

- Update the view's `_form` partial:

  ``` html
{%# File: app/views/pages/_form.html.erb %}
<%= form_with(model: page, local: true) do |form| %>
  ...
  <%= render "shared/errors", object: page %>
  <hr />
  ...
<% end %>
```
  **Notes:**

  - Partials can use other partials (nested partials)
  - Invalid submitted form fields are wrapped with `div#field_with_errors`

- Update the global style sheet:

  ``` scss
// File: app/assets/stylesheets/global.scss
...
$color-warning: #FBF1A9;
$color-danger: #E7040F;
...
.field_with_errors {
    label {
        color: $color-danger;
    }
    input,
    textarea {
        background: $color-warning;
    }
}
```

-------------------------------------------------------------------------------

The Flash
---------

**Note:** While validation errors are for failed submissions, flashes are for successful ones.

- Update the controller methods performing redirects:

  ``` ruby
# File: app/controllers/pages_controller.rb
class PagesController < ApplicationController
  ...
  def update
    @page = Page.find(params[:id])

    if @page.update(page_params)
      redirect_to @page, notice: "Page successfully updated!"
    else
      render :edit
    end
  end
  ...
  def create
    @page = Page.new(page_params)

    if @page.save
      redirect_to @page, notice: "Page successfully created!"
    else
      render :new
    end
  end

  def destroy
    @page = Page.find(params[:id])
    @page.destroy
    redirect_to pages_path, notice: "Page successfully deleted!"
  end
  ...
end
```
  **Notes:**

  - Flashes are temporary messages between actions (e.g. `create`, `update`, and `destroy`)
  - Flashes are gone when another action is performed (e.g. a page refresh)
  - The `notice: "<msg>"` or `alert: "<msg>"` are conveniences when using redirects
  - For non-redirects, use the plain `flash[:notice]` or `flash[:alert]`

- Create an application-wide partial:

  ``` html
<!-- File: app/views/layouts/_flash.html.erb -->
<% if flash[:notice] %>
    <%= flash[:notice] %>
<% end %>

<% if flash[:alert] %>
    <%= flash[:alert] %>
<% end %>
```
  **Note:** While not necessary, the reasoning to make flash a partial is to avoid bloating the base html file.

- Use the partial in the application-wide view:

  ``` html
<!-- File: app/views/layouts/application.html.erb -->
...
<main>
    <%= render "layouts/flash" %>
    <%= yield %>
</main>
...
```
  **Note:** The reason to put it in the application-wide view is to render it on all of app's action views.

- Use the `add_flash_types` method to add a custom flash type:

  ``` ruby
# File: app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  add_flash_types(:custom)
end
```

-------------------------------------------------------------------------------

One-to-many
-----------

### belongs_to ###

The `belongs_to` is the `one` in the `one-to-many` relationship and is the **child**.

1. Create a new resource:

   ``` shell
$ rails g resource tag name:string page:references
```
   **Notes:**

   - The resource name must be singular
   - This generates complete routes and a migration file
   - The `resource` command is intended for RESTful applications where there's no view
   - The `<model>:references` adds `belongs_to :<model>` to the generated model
   - The `belongs_to` method tells Rails its relationship to another model (parent)
   - The `belongs_to` model keyword must be in singular (e.g. `:page`)
   - The `belongs_to` also creates a foreign key column (`<model>_id`) to link with another model
   - To remove the generated resource files, simply replace `g` with `d` (shortcut for `destroy`)

2. Apply migration:

   ``` shell
$ rails db:migrate
```

3. Open Rails console:

   ``` shell
$ rails c
```

4. Associate a model object with the foreign key:

   ``` ruby
 > p = Page.find(1)
   (0.4ms)  SELECT sqlite_version(*)
   Page Load (0.2ms)  SELECT "pages".* ...
=> #<Page id: 1, ...
 > t = Tag.create(name: "hashtag", page_id: p.id)
   (0.1ms)  begin transaction
   Page Load (0.1ms)  SELECT "pages".* ...
   Tag Create (0.4ms)  INSERT INTO "tags" ...
   (9.7ms)  commit transaction
=> #<Tag id: 1, ...
2.6.3 :003 >
```
   **Notes:**

   - The foreign key is the `<model>_id`
   - Model relationships are called **associations**

5. Associate a model object with an object itself:

   ``` ruby
 > p = Page.find(1)
   (0.5ms)  SELECT sqlite_version(*)
   Page Load (0.2ms)  SELECT "pages".* ...
=> #<Page id: 1, ...
 > t = Tag.create(name: "hashtag", page: p)
   (0.1ms)  begin transaction
   Tag Create (0.3ms)  INSERT INTO "tags" ...
   (9.7ms)  commit transaction
=> #<Tag id: 1, ...
```

6. Access the associated model object:

   ``` ruby
 > # Access the foreign key:
 > t.page_id
 => 1

 > # Access the object:
 > t.page
 => #<Page id: 1, ...
```

### has_many ###

The `has_many` is the `many` in the `one-to-many` relationship and is the **parent**.

1. Update the model:

   ``` ruby
# File: app/models/page.rb
class Page < ApplicationRecord
  has_many :tags
  ...
end
```
   **Notes:**

   - The `has_many` model keyword must be in plural (e.g. `:tags`)
   - The `has_many` creates the specified name as an instance method

3. Open Rails console:

   ``` shell
$ rails c
```

4. List associated model objects:

   ``` ruby
 > p = Page.find(1)
  (0.4ms)  SELECT sqlite_version(*)
  Page Load (0.2ms)  SELECT "pages".* ...
=> #<Page id: 1, ...
 > t = Tag.create(name: "hashtag", page: p)
   (0.2ms)  begin transaction
   Tag Create (0.8ms)  INSERT INTO "tags" ...
   (11.4ms)  commit transaction
=> #<Tag id: 1, ...
 > p.tags
   Tag Load (0.6ms)  SELECT "tags".* ...
=> #<ActiveRecord::Associations::CollectionProxy [#<Tag id: 1, ...
```

5. Create an associated model object thru the parent object:

   ``` ruby
 > p = Page.find(1)
   (0.4ms)  SELECT sqlite_version(*)
   Page Load (0.2ms)  SELECT "pages".* ...
=> #<Page id: 1, ...
 > p.tags.create(name: "hashtag")
   (0.1ms)  begin transaction
   Tag Create (0.3ms)  INSERT INTO "tags" ...
   (36.0ms)  commit transaction
=> #<Tag id: 1, ...
```
   **Note:** The foreign key is automatically set.

### dependent ###

The `dependent` option cascades the method (e.g. `destroy`) to associated model objects.

1. Update the model:

   ``` ruby
# File: app/models/page.rb
class Page < ApplicationRecord
  has_many :tags, dependent: :destroy
  ...
end
```
   **Notes:**

   - The `dependent` option prevents associated model objects to be orphaned (no parent)
   - Only use `dependent` on `hash_many` associations since their existence depends on parent model objects

2. Open Rails console:

   ``` shell
$ rails c
```

2. Destroying associated children don't remove the parent:

   ``` ruby
 > p = Page.find(1)
   (0.3ms)  SELECT sqlite_version(*)
   Page Load (0.2ms)  SELECT "pages".* ...
=> #<Page id: 1, ...
 > t = Tag.create(name: "hashtag", page: p)
   (0.1ms)  begin transaction
   Tag Create (0.2ms)  INSERT INTO "tags" ...
   (1898.3ms)  commit transaction
=> #<Tag id: 1, ...
 > t.destroy
   (0.2ms)  begin transaction
   Tag Destroy (0.8ms)  DELETE FROM "tags" ...
   (36.2ms)  commit transaction
=> #<Tag id: 1, ...
 > p = Page.find(1)
   Page Load (0.4ms)  SELECT "pages".* ...
=> #<Page id: 1, ...
 > p.tags
  Tag Load (0.5ms)  SELECT "tags".* ...
=> #<ActiveRecord::Associations::CollectionProxy []>
```

3. But destroying the parent also removes the associated children:

   ``` ruby
 > p = Page.find(1)
   (0.4ms)  SELECT sqlite_version(*)
   Page Load (0.2ms)  SELECT "pages".* ...
=> #<Page id: 1, ...
 > t = Tag.create(name: "hashtag", page: p)
   (0.1ms)  begin transaction
   Tag Create (0.4ms)  INSERT INTO ...
   (35.3ms)  commit transaction
=> #<Tag id: 1, ...
 > p.destroy
   (0.1ms)  begin transaction
   Tag Load (0.3ms)  SELECT "tags".* ...
   Tag Destroy (0.5ms)  DELETE FROM ...
   Page Destroy (0.2ms)  DELETE FROM ...
   (35.5ms)  commit transaction
=> #<Page id: 1, ...
 > p = Page.find(1)
   Page Load (0.5ms)  SELECT "pages".* ...
 Traceback (most recent call last):
         1: from (irb):6
 ActiveRecord::RecordNotFound (Couldn't find Page with 'id'=1)
 > t = Tag.find(1)
   Tag Load (0.7ms)  SELECT "tags".* ...
 Traceback (most recent call last):
         2: from (irb):7
         1: from (irb):7:in `rescue in irb_binding'
 ActiveRecord::RecordNotFound (Couldn't find Tag with 'id'=1)
```

### Nested resources ###

**Note:** Nested resources allows associated models to have a heirarchy in URLs.

1. Visit the desired URL (e.g. <http://localhost:3000/pages/1/tags>)
   <br />You should get an error:

   ``` html
Routing Error

No route matches [GET] "/pages/1/tags"
```

2. Update the route:

   ``` ruby
# File: config/routes.rb
Rails.application.routes.draw do
  root "pages#index"

  resources :pages do
    resources :tags
  end
end
```
   **Note:** This makes the `:tags` routes to be nested inside the `:pages` routes.

3. Visit the defined routes ([/rails/info/routes](http://localhost:3000/rails/info/routes))
   <br />Enter `tags` on the `Path` field to highlight the nested URLs:
   ``` html
| Helper             | HTTP Verb | Path                                    | Controller#Action |
| Path / Url         |           | [ tags                                ] |                   |
|--------------------|-----------|-----------------------------------------|-------------------|
| page_tags_path     | GET       | /pages/:page_id/tags(.:format)          | tags#index        |
|                    | POST      | /pages/:page_id/tags(.:format)          | tags#create       |
| new_page_tag_path  | GET       | /pages/:page_id/tags/new(.:format)      | tags#new          |
| edit_page_tag_path | GET       | /pages/:page_id/tags/:id/edit(.:format) | tags#edit         |
| page_tag_path      | GET       | /pages/:page_id/tags/:id(.:format)      | tags#show         |
|                    | PATCH     | /pages/:page_id/tags/:id(.:format)      | tags#update       |
|                    | PUT       | /pages/:page_id/tags/:id(.:format)      | tags#update       |
|                    | DELETE    | /pages/:page_id/tags/:id(.:format)      | tags#destroy      |
```
   **Note:** Nested resources avoids resorting to (ugly?) query strings (e.g. `/tags?page_id=1`).

4. Reload the browser
   <br />You should get another error:

   ``` html
Routing Error

The action 'index' could not be found for TagsController
```

5. Update the controller:

   ``` ruby
# File: app/controllers/tags_controller.rb
class TagsController < ApplicationController
  def index
    @page = Page.find(params[:page_id])
    @tags = @page.tags
  end
end
```

6. Reload the browser
   <br />You should get another error:

   ``` html
No template for interactive request

TagsController#index is missing a template for request formats: text/html
```

7. Create the view:

   ``` shell
$ \
mkdir -p app/views/tags/
echo '
<h1>Tags for <%= link_to @page.title, @page %></h1>
<ul>
    <% @tags.each do |tag| %>
        <li><%= tag.name %></li>
    <% end %>
</ul>
' > app/views/tags/index.html.erb
```

8. Reload the browser
   <br />You should see the text:

   ``` html
Tags for Hello World!

* hashtag
```

### Forms ###

#### New ####

1. Visit the desired URL (e.g. <http://localhost:3000/pages/1/tags/new>)
   <br />You should get an error:

   ``` html
Unknown action

The action 'new' could not be found for TagsController
```

2. Update the controller:

   ``` ruby
# File: app/controllers/tags_controller.rb
class TagsController < ApplicationController
  ...
  def new
    @page = Page.find(params[:page_id])
    @tag = @page.tags.new
  end
end
```

4. Reload the browser
   <br />You should get another error:

   ``` html
No template for interactive request

TagsController#new is missing a template for request formats: text/html
```

5. Create a shared partial:

   ``` html
$ \
mkdir -p app/views/tags/
echo '
<%= form_with(model: page, local: true) do |form| %>
    <%= render "shared/errors", object: page.last %>
    <hr />
    <%= form.label :name %>
    <%= form.text_field :name %>
    <%= form.submit %>
<% end %>
' > app/views/tags/_form.html.erb
```
   **Notes:**

   - `form_with`'s `model` (`page`) is an array (`[@page, @tag]`) consisting of parent and child models
   - `form_with`'s generated `action` attribute points to `/<parent>/<parent_id>/<child>` (e.g. `/pages/1/tags`)
   - `render`'s `object` (`page.last`) refers to the child model (`@tag`)

6. Create the view:

   ``` shell
$ \
mkdir -p app/views/tags/
echo '
<h1>New Tag</h1>
<%= render "form", page: [@page, @tag] %>
' > app/views/tags/new.html.erb
```

7. Reload the browser
   <br />You should see the text followed by a form:

   ``` html
New Tag
```

#### Create ####

1. Click the `Create Tag` submit button and get an error:

   ``` html
Unknown action

The action 'create' could not be found for TagsController
```

2. Update the controller:

   ``` ruby
# File: app/controllers/tags_controller.rb
class TagsController < ApplicationController
  ...
  def create
    @page = Page.find(params[:page_id])
    @tag = @page.tags.new(tag_params)

    if @tag.save
      redirect_to @page, notice: "Tag successfully created!"
    else
      render :new
    end
  end

  private

  def tag_params
    params.require(:tag).permit(:name)
  end
end
```
   **Note:** `redirect_to` in this case, points back to the parent's show page (`@page`).

3. Reload the browser and confirm form re-submission
   <br />You should be redirected to the show page with the text:

   ``` html
Tag successfully created!
```

#### Remove duplicates with before_action ####

**Note:** The `before_action` method can remove duplicated code used across the controller.

1. Update the controller:

   ``` ruby
class TagsController < ApplicationController
  before_action :set_tag

  def index
    @tags = @page.tags
  end

  def new
    @tag = @page.tags.new
  end

  def create
    @tag = @page.tags.new(tag_params)

    if @tag.save
      redirect_to @page, notice: "Tag successfully created!"
    else
      render :new
    end
  end

  private

  def tag_params
    params.require(:tag).permit(:name)
  end

  def set_tag
    @page = Page.find(params[:page_id])
  end
end
```
   **Notes:**

   - The `before_action` method calls a method before executing a controller action
   - The `before_action` can include (`:only`) or exclude (`:except`) controller actions to be affected

Let's continue to the last part: [Ruby on Rails 6: Week 4](ruby-on-rails-6-week-4).
