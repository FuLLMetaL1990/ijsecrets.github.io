{:title       "Ruby on Rails 6: Week 2"
 :layout      :post
 :summary     "
              This document is the continuation of Ruby on Rails 6: Week 1 and will be about

              1) stylesheet and image assets
              2) routes,
              3) forms
              and 4) and partials.
              "
 :excerpt     "This is the week 2 summary of the learned lessons from The Pragmatic Studio's Ruby on Rails 6 course."
 :description "Week 2 summary of the learned lessons from The Pragmatic Studio's Ruby on Rails 6 course."
 :date        "2019-10-06"
 :tags        ["research"
               "web-application-framework"
               "ruby-on-rails"
               "ruby"]}

-------------------------------------------------------------------------------

**Note:** This is the continuation of [Ruby on Rails 6: Week 1](ruby-on-rails-6-week-1).

This document will be the week 2 summary of the learned lessons from [The Pragmatic Studio](https://pragmaticstudio.com)'s [Ruby on Rails 6](https://pragmaticstudio.com/courses/rails) course.

The number of lessons look lesser but in fact, half of them consists of multiple videos to make sense of [CRUD](https://en.wikipedia.org/wiki/Create,_read,_update_and_delete) in Rails.

-------------------------------------------------------------------------------

Style Sheet and Image Assets
---------------------------

### Gem ###

Install a CSS framework:

``` shell
$ bundle add tachyons-rails
```

**Notes:**

- `bundle add` will add the gem to the `Gemfile` then execute `bundle install`
- In this example, we installed [tachyons](https://tachyons.io)

### Images ###

1. Add image(s):

   ``` shell
$ wget https://ejelome.com/img/logo.png -P app/assets/images/
```
   **Notes:**

   - The image directory is located at `app/assets/images/`
   - `wget` is a CLI network downloader and `-P` specifies the destination path

2. Update the base html:

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
            <a href="/">
              <%= image_tag("logo") %>
            </a>
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
   **Notes:**

   - The `image_tag` looks for the image with similar name in the image directory
   - The base html is located at `app/views/layouts/application.html.erb`

### Style Sheets ###

Add style sheet(s):

``` shell
# File: app/assets/stylesheets/global.scss
$ echo '
$bg-color: #EEEEEE;
$font-color: #111111;

body {
  background: $bg-color;
  color: $font-color;
}
' > app/assets/stylesheets/global.scss
```

**Notes:**

- The style sheets are located at `app/assets/stylesheets/`
- The style sheets in the directory are bundled using the directives specified in `app/assets/stylesheets/application.css`
- The `*= require_tree .` directive includes all the style sheets in the directory
- The `*= require_self` directive simply includes itself after all were included
- Use the app-specific style sheet to only affect its pages (e.g. `app/assets/stylesheets/pages.scss`)

### Default database values ###

1. Update the seeds file:

   ``` ruby
# File: db/seeds.rb
Page.create!(
  [
    {
      title: "Hello World!",
      slug: "hello-world",
      message: "Foo Bar Baz",
      excerpt: "Foo..."
    },
    {
      title: "Crappy World!",
      slug: "crappy-world",
      message: "Qux Quux Quuz",
      excerpt: "Qux..."
    }
  ]
)
```
   **Notes:**

   - The seeds file is located at `db/seeds.rb`
   - The `create!` method is similar to the `create` method except that it raises an exception when it fails
   - The default values specified in `db/seeds.rb` are applied to the `development` database

2. Populate the database:

   ``` shell
$ rails db:reset
```
   **Notes:**

   - The `db:reset` drops the database, applies the migration, then loads the seed data
   - Use `db:seed` to create new sets of seeds (duplicates)
   - Use `db:seed:replant` to empty all tables and re-seed

-------------------------------------------------------------------------------

Routes
------

### Show Page ###

1. Visit the desired URL (e.g. <http://localhost:3000/pages/1>)
   <br />You should get an error:

   ``` html
Routing Error

No route matches [GET] "/pages/1"
```

2. Add the route:

   ``` ruby
# File: config/routes.rb
Rails.application.routes.draw do
  ...
  get "pages/:id" => "pages#show"
end
```
   **Notes:**

   - The `:id` is a variable that acts as a placeholder holding the value of its position (e.g. `1`)
   - The `#show` action is a view intended to **show** the complete detail of a specific primary key

3. Reload the browser
   <br />You should get another error:

   ``` html
Routing Error

The action 'show' could not be found for PagesController
```

4. Add the controller:

   ``` ruby
# File: app/controllers/pages_controller.rb
class PagesController < ApplicationController
  ...
  def show
    @page = Page.find(params[:id])
  end
end
```
   **Notes:**

   - Unlike `index` displaying a list (`@pages`), `show` is only concerned with one (`@page`)
   - The `find` method looks for a row in the database using its argument as primary key
   - The `params` is a hash containing the variables (placeholders) as key/value pairs
   - Use the `fail` method to force Rails to raise an exception, to inspect the contents of `params`

5. Reload the browser
   <br />You should get another error:

   ``` html
No template for interactive request

PagesController#show is missing a template for request formats: text/html
```

6. Create the view:

   ``` html
# File: app/views/pages/show.html.erb
$ echo '
<h1><%= title(@page) %></h1>
<p><%= @page.message %></p>
' > app/views/pages/show.html.erb
```

7. Reload the browser
   <br />You should see the text:

   ``` html
Hello World!

Foo Bar Baz
```

### Linking Pages ###

- Use the `link_to` method to generated dynamic URLs:

  ``` html
<%= link_to "Pages", "/pages" %>

<!--
Equivalent to:
<a href="/pages">Pages</a>
-->
```
  **Notes:**

  - The `link_to` method's arguments, by convention, should not be wrapped in parens
  - Avoiding hard-coding paths by using routes to dynamically generate URLs

- Visit the defined routes ([/rails/info/routes](http://localhost:3000/rails/info/routes)):
  <br />
  <br />**Notes:**

  - The defined routes displays all of the application's URLs
  - Helper `Path` (e.g. `pages_path` for relative url)
  - Helper `Url` (e.g. `pages_url` for full url)
  - HTTP Verb (e.g. `GET`, `POST`, `PATCH`, `PUT`, `DELETE`)
  - Path Match (e.g. `/pages(.:format)`)
  - `.:format` are any optional characters that might be included in the pattern
  - Controller#Action (e.g. `pages/#show`) that is executed when the URL is visited

- Use the routes' path method (e.g. `pages_path`) instead of a hard-coded path:

  ``` html
<%= link_to "Pages", pages_path %>

<!--
Generates:
<a href="/pages">Pages</a>
-->
```

- Assign an alias to a blank route:

  ``` ruby
# File: config/routes.rb
Rails.application.routes.draw do
  ...
  get "pages/:id" => "pages#show", as: "page"
end
```
  **Note:** The alias should be singular since the route is only dealing with a one thing.

- Use the route alias to generate a URL with that route:

  ``` html
<%# File: app/views/pages/index.html.erb %>
<ul>
    <% @pages.each do |page| %>
    <li>
        <%= link_to page.title, page %>
    </li>
    <% end %>
</ul>
```
  **Notes:**

  - The `*_path` method automatically maps the `id` (primary key) from the passed object (e.g. `page`)
  - Rails uses the singular path (e.g. `page_path`) when the 2nd argument of `link_to` method is the model object

- Use the `root` route in to map a route to the index page of the application:

  ``` ruby
# File: config/routes.rb
Rails.application.routes.draw do
  root "pages#index"

  get "pages" => "pages#index"
  get "pages/:id" => "pages#show", as: "page"
end
```
  Visiting <http://localhost:3000> is now similar to <http://localhost:3000/pages>.

- Use the `root_path` to wrap the application logo to point to the index page:

  ``` html
<%# File: app/views/layouts/application.html.erb %>
...
<%= link_to image_tag("logo"), root_path %>
...
```

### Routes in console ###

``` ruby
$ rails c
 > # pages#index (relative path):
 > app.pages_path
=> "/pages"

 > # pages#index (full url):
 > app.pages_url
=> "http://www.example.com/pages"

 > # pages#show (relative path):
 > app.page_path(Page.find(1))
  Page Load (0.1ms)  SELECT "pages".* FROM "pages" WHERE "pages"."id" = ? LIMIT ?  [["id", 1], ["LIMIT", 1]]
 => "/pages/1"

 > # pages#show (full url):
 > app.page_url(Page.find(1))
  Page Load (0.3ms)  SELECT "pages".* FROM "pages" WHERE "pages"."id" = ? LIMIT ?  [["id", 1], ["LIMIT", 1]]
 => "http://www.example.com/pages/1"

 > # root path:
 > app.root_path
=> "/"
```

### The resources method ###

**Notes:**

- The method `resources` creates the seven different routes that is mapped to the controller

#### Example setup ####

Use `resources` method with the controller (e.g. `:pages`) as a keyword argument:

``` ruby
# File: config/routes.rb
Rails.application.routes.draw do
  root "pages#index"

  resources :pages
end
```

#### Example result ####

The `resources` method automates the manual process of incrementally including routes:

| HTTP Verb | Path (Resource) | Controller#Action | Purpose (Entity)  |
| :-------- | :-------------- | :---------------- | :---------------- |
| GET       | /pages          | pages#index       | List entities     |
| GET       | /pages/new      | pages#new         | Show create form  |
| POST      | /pages          | pages#create      | Create an entity  |
| GET       | /pages/:id      | pages#show        | Display an entity |
| GET       | /pages/:id/edit | pages#edit        | Show edit form    |
| PATCH     | /pages/:id      | pages#update      | Update an entity  |
| DELETE    | /pages/:id      | pages#delete      | Delete an entity  |

-------------------------------------------------------------------------------

Forms
-----

### Edit Page ###

1. Visit the desired URL (e.g. <http://localhost:3000/pages/1/edit>)
   <br />You should get an error:

   ``` html
Routing Error

No route matches [GET] "/pages/1/edit"
```

2. Add the route:

   ``` ruby
# File: config/routes.rb
Rails.application.routes.draw do
  ...
  get "pages/:id/edit" => "pages#edit", as: "edit_page"
end
```

3. Update `show`'s view to link to `edit` view:

   ``` html
<%# File: app/views/pages/show.html.erb %>
<h1><%= title(@page) %></h1>
<p><%= @page.message %></p>
<%= link_to "Edit", edit_page_path(@page) %>
```

4. Reload the browser
   <br />You should get another error:

   ``` html
Routing Error

The action 'edit' could not be found for PagesController
```

4. Add the controller:

   ``` ruby
# File: app/controllers/pages_controller.rb
class PagesController < ApplicationController
  ...
  def edit
    @page = Page.find(params[:id])
  end
end
```
   **Note:** The `edit` action has similar block as `show` action.

5. Reload the browser
   <br />You should get another error:

   ``` html
No template for interactive request

PagesController#edit is missing a template for request formats: text/html
```

6. Create the view:

   ``` html
# File: app/views/pages/edit.html.erb
$ echo '
<h1>Edit <%= title(@page) %></h1>
<%= form_with(model: @page, local: true) do |form| %>
    <ul>
        <li>
            <%= form.label :title %>
            <br />
            <%= form.text_field :title %>
        </li>
        <li>
            <%= form.label :slug %>
            <br />
            <%= form.text_field :slug %>
        </li>
        <li>
            <%= form.label :message %>
            <br />
            <%= form.text_area :message, rows: 5 %>
        </li>
        <li>
            <%= form.label :excerpt %>
            <br />
            <%= form.text_area :excerpt, rows: 5 %>
        </li>
    </ul>
    <%= form.submit %>
<% end %>
' > app/views/pages/edit.html.erb
```
   **Notes:**

   - The `form_with` view helper method combines the use cases of `form_for` and `form_tag` methods
   - The `form_with` passes a form builder through a block parameter (e.g. `|form|`)
   - The passed form builder provide methods to generate html forms for model attributes
   - The keywords (e.g. `:title`) are the model attributes that the form builder will use
   - Each form build methods can take optional parameters (e.g. `rows: 5`) to customize form fields
   - By default, `form_with` submits the form with `AJAX` request
   - Specifying the option `local: true` submits the form normally
   - The `submit` method uses `Update ...` as text because the `form_with` view helper method recognizes that an entity already exists in the database

7. Reload the browser
   <br />You should see the text:

   ``` html
Edit Hello World!

* Title
  ----------------
  | Hello World! |
  ----------------
* Slug
  ----------------
  | hello-world  |
  ----------------
* Message
  ----------------
  | Foo Bar Baz  |
  |              |
  |              |
  |              |
  |              |
  ----------------
* Excerpt
  ----------------
  | Foo...       |
  |              |
  |              |
  |              |
  |              |
  ----------------

-------------
[Update Page]
-------------
```

### Update Page ###


1. Click the `Update Page` button to submit the form
   <br />You should get an error:

   ``` html
Routing Error

No route matches [PATCH] "/pages/1"
```

2. Add the route:

   ``` ruby
# File: config/routes.rb
Rails.application.routes.draw do
  ...
  patch "pages/:id" => "pages#update"
end
```
   **Notes:**

   - In Rails, `PATCH` is the HTTP verb used when updating a model attribute
   - The pattern for update is similar to show, except that it uses a different verb to do a different action
   - Rails overrides the `form[method=post]` with `input[name="_method" value="patch"]` to implement `PATCH`
   - The patch route doesn't need an alias (`as:`) since it is not used to generate a link

3. Reload the browser and confirm form re-submission
   <br />You should get another error:

   ``` html
Routing Error

The action 'update' could not be found for PagesController
```

4. Add the controller:

   ``` ruby
# File: app/controllers/pages_controller.rb
class PagesController < ApplicationController
  ...
  def update
    @page = Page.find(params[:id])
    @page.update(params[:page])
  end
end
```
   **Notes:**

   - In Rails, instance variables in controllers (e.g. `@page`) are gone once the action is executed
   - The instance variables, though look similar on each controller action, are not really related
   - The `params` object contains the form values as a hash and named after the model (e.g. `:page`)

5. Reload the browser and confirm form re-submission
   <br />You should get another error:

   ``` html
ActiveModel::ForbiddenAttributesError in PagesController#update

ActiveModel::ForbiddenAttributesError
```
   **Notes:**

   - For security reasons, Rails doesn't allow mass assignment of attributes to be updated
   - Rails require the attributes that we want to be updated to be explicitly specified

6. Update the controller:

   ``` ruby
# File: app/controllers/pages_controller.rb
class PagesController < ApplicationController
  ...
  def update
    @page = Page.find(params[:id])
    page_params = params.require(:page).permit(
      :title,
      :slug,
      :message,
      :excerpt
    )
    @page.update(page_params)
  end
end
```
   **Notes:**

   - The `require` method checks if the keyword exist in the hash, otherwise, it raises an error
   - The `permit` method takes a comma-separated attributes as keys that are allowed to be updated
   - Any form fields that are submitted with the form but not found in the `permit` method are all ignored
   - To allow all attributes to be updated, use the destructive (side-effect) version: `permit!`

7. Reload the browser and confirm form re-submission
   <br />You should not see any error but nothing will seem to work (but it does, look at the console):
   ``` shell
...
No template found for PagesController#update, rendering head :no_content
Completed 204 No Content in 5ms (ActiveRecord: 0.3ms | Allocations: 1125)
```

8. Update the controller:

   ``` ruby
# File: app/controllers/pages_controller.rb
class PagesController < ApplicationController
  ...
  def update
    @page = Page.find(params[:id])
    page_params = params.require(:page).permit(
      :title,
      :slug,
      :message,
      :excerpt
    )
    @page.update(page_params)
    redirect_to page_path(@page)
  end
end
```
   **Notes:**

   - The `redirect_to` method redirects an action to another
   - Specifying just the model in the `redirect_to` assumes it's from the `show` route path
   - Based on that assumption, `redirect_to @page` is similar to `redirect_to page_path(@page)`
   - In Rails, non-`GET` actions are redirected (using `redirect_to`) instead of rendering views

9. Reload the browser
   <br />You should be redirected to the show page (e.g. <http://localhost:3000/pages/1>).

### New Page ###

1. Visit the desired URL (e.g. <http://localhost:3000/pages/new>)
   <br />You should get an error:

   ``` html
ActiveRecord::RecordNotFound in PagesController#new

Couldn't find Page with 'id'=new
```

2. Add the route:

   ``` ruby
# File: config/routes.rb
Rails.application.routes.draw do
  ...
  get "pages/new" => "pages#new", as: "new_page"
  ...
end
```
   **Note:** The `new` route must come before the `show` route because the routes are read from top to bottom.

3. Reload the browser
   <br />You should get another error:

   ``` html
Routing Error

The action 'new' could not be found for PagesController
```

4. Add the controller:

   ``` ruby
# File: app/controllers/pages_controller.rb
class PagesController < ApplicationController
  ...
  def new
    @page = Page.new
  end
end
```
   **Note:** The instance variable is just assigned with an empty class instance.

5. Reload the browser
   <br />You should get another error:

   ``` html
No template for interactive request

PagesController#new is missing a template for request formats: text/html
```

6. Create the view:

   ``` html
# File: app/views/pages/new.html.erb
$ echo '
<h1>New Page</h1>
<%= form_with(model: @page, local: true) do |form| %>
    <ul>
        <li>
            <%= form.label :title %>
            <br />
            <%= form.text_field :title %>
        </li>
        <li>
            <%= form.label :slug %>
            <br />
            <%= form.text_field :slug %>
        </li>
        <li>
            <%= form.label :message %>
            <br />
            <%= form.text_area :message, rows: 5 %>
        </li>
        <li>
            <%= form.label :excerpt %>
            <br />
            <%= form.text_area :excerpt, rows: 5 %>
        </li>
    </ul>
    <%= form.submit %>
<% end %>
' > app/views/pages/new.html.erb
```
   **Note:** The `submit` method uses `Create ...` as text because the `form_with` view helper method recognizes that the entity doesn't exist yet in the database.

7. Reload the browser
   <br />You should see the text:

   ``` html
New Page

* Title
  ----------------
  |              |
  ----------------
* Slug
  ----------------
  |              |
  ----------------
* Message
  ----------------
  |              |
  |              |
  |              |
  |              |
  |              |
  ----------------
* Excerpt
  ----------------
  |              |
  |              |
  |              |
  |              |
  |              |
  ----------------

-------------
[Create Page]
-------------
```

### Create Page ###

1. Click the `Create Page` button to submit the form
   <br />You should get an error:

   ``` html
Routing Error

No route matches [POST] "/pages"
```

2. Add the route:

   ``` ruby
# File: config/routes.rb
Rails.application.routes.draw do
  ...
  post "pages" => "pages#create"
end
```
   **Note:** The post route doesn't need an alias (`as:`) since it is not used to generate a link.

3. Reload the browser and confirm form re-submission
   <br />You should get another error:

   ``` html
Routing Error

The action 'create' could not be found for PagesController
```

4. Add the controller:

   ``` ruby
# File: app/controllers/pages_controller.rb
class PagesController < ApplicationController
  ...
  def create
    @page = Page.create(params[:page])
    redirect_to @page
  end
end
```

5. Reload the browser and confirm form re-submission
   <br />You should get another error:

   ``` html
ActiveModel::ForbiddenAttributesError in PagesController#create

ActiveModel::ForbiddenAttributesError
```

6. Update the controller:

   ``` ruby
# File: app/controllers/pages_controller.rb
class PagesController < ApplicationController
  ...
  def create
    page_params = params.require(:page).permit(
      :title,
      :slug,
      :message,
      :excerpt
    )
    @page = Page.create(page_params)
    redirect_to @page
  end
end
```

7. Re-factor the duplicate `page_params` as a `private` method:

   ``` ruby
# File: app/controllers/pages_controller.rb
class PagesController < ApplicationController
  ...
  def update
    @page = Page.find(params[:id])
    @page.update(page_params)
    redirect_to page_path(@page)
  end

  ...

  def create
    @page = Page.create(page_params)
    redirect_to @page
  end

  private

  def page_params
    params.require(:page).permit(
      :title,
      :slug,
      :message,
      :excerpt
    )
  end
end
```
   **Notes:**

   - The `private` method prevents the methods below it to be callable outside the class
   - The redundant variable turned method (e.g. `page_params`) is a virtual attribute accessible on other methods

8. Reload the browser and confirm form re-submission
   <br />You should be redirected to its show page (e.g. <http://localhost:3000/pages/3>).

9. Add an `Add` button on the index view

   ``` html
<%# File: app/views/pages/index.html.erb %>
...
<%= link_to "Add", new_page_path(@page) %>
```
   This will help as a convenience to go to the new page and create a new page.

### Destroy Page ###

1. Add a delete link on a `GET` page:
   <br />**Note:** Except for the `new` page since there's nothing to delete from there.

   ``` html
<%# File: app/views/pages/show.html.erb %>
...
<%= link_to "Delete", @page, method: :delete,
                      data: { confirm: "Are you sure you want to delete this page?" } %>
```
   **Notes:**

   - The `@page` is a shortcut for `page_path(@page)` since it already know it's in the `page_path`
   - The `method: :delete` is required to tell that the link is not a `GET` action but a `DELETE` action
   - The `data` contains custom data attributes (`data-*`) used by JavaScript to fake `DELETE` request

2. Click the `Delete` link then click `OK`
   <br />You should get an error:

   ``` html
Routing Error

No route matches [DELETE] "/pages/1"
```

3. Add the route:

   ``` ruby
# File: config/routes.rb
Rails.application.routes.draw do
  ...
  delete "pages/:id" => "pages#destroy"
end
```

4. Refresh the page then click `Continue`
   <br />You should get another error:

   ``` html
Unknown action

The action 'destroy' could not be found for PagesController
```

5. Update the controller:

   ``` ruby
# File: app/controllers/pages_controller.rb
...
def destroy
  @page = Page.find(params[:id])
  @page.destroy
  redirect_to pages_path
end
...
```

6. Refresh the page then click `Continue`
   <br />The page should be deleted and redirect to the index page.

-------------------------------------------------------------------------------

Partials
--------

1. Create a partial template:

   ``` html
<%# File: app/views/pages/_form.html.erb %>
<%= form_with(model: page, local: true) do |form| %>
    <ul>
        <li>
            <%= form.label :title %>
            <br />
            <%= form.text_field :title %>
        </li>
        <li>
            <%= form.label :slug %>
            <br />
            <%= form.text_field :slug %>
        </li>
        <li>
            <%= form.label :message %>
            <br />
            <%= form.text_area :message, rows: 5 %>
        </li>
        <li>
            <%= form.label :excerpt %>
            <br />
            <%= form.text_area :excerpt, rows: 5 %>
        </li>
    </ul>
    <%= form.submit %>
<% end %>
```
   **Notes:**

   - Partial template names must be prefixed by a single underscore (e.g. `_form.html.erb`)
   - Instead of using instance variables (e.g. `@page`) use a local variable (e.g. `page`)

2. Replace duplicate forms with the partial template:

   - On the `new` view:

     ``` html
<%# File: app/views/pages/new.html.erb %>
...
<%= render "form", page: @page %>
```

   - On the `edit` view:

     ``` html
<%# File: app/views/pages/edit.html.erb %>
...
<%= render "form", page: @page %>
```

**Notes:**

- Partial templates (or just **partials**) are re-usable part of views that can be used in other views
- Treat partials as pure functions that returns a component (the chunks of views)
- There is must be no underscore when referring to the partial template names
- Prefix partial templates with its directory (e.g. `layouts/`) if it's not inside an app's view directory

Let's continue to the third week: [Ruby on Rails 6: Week 3](ruby-on-rails-6-week-3).
