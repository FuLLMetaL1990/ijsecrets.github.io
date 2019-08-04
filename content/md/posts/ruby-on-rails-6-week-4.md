{:title       "Ruby on Rails 6: Week 4"
 :layout      :post
 :summary     "
              This document is the continuation of Ruby on Rails 6: Week 3 and will be about

              1) user account model,
              2) user signup,
              3) edit user account,
              4) sign in,
              5) authentication,
              6) current user,
              7) sign out,
              8) authorization
              and 9) admin users.
              "
 :excerpt     "This is the week 4 summary of the learned lessons from The Pragmatic Studio's Ruby on Rails 6 course."
 :description "Week 4 summary of the learned lessons from The Pragmatic Studio's Ruby on Rails 6 course."
 :date        "2019-10-20"
 :tags        ["research"
               "web-application-framework"
               "ruby-on-rails"
               "ruby"]}

-------------------------------------------------------------------------------

**Note:** This is the continuation of [Ruby on Rails 6: Week 3](ruby-on-rails-6-week-3).

This document will be the week 4 summary of the learned lessons from [The Pragmatic Studio](https://pragmaticstudio.com)'s [Ruby on Rails 6](https://pragmaticstudio.com/courses/rails) course.

-------------------------------------------------------------------------------

User Account Model
------------------

1. Create a new resource:

   ``` shell
$ rails g resource user username password:digest
```
   **Note:**

   - By default, fields are set to `string` type (e.g. `username` will be `string`)
   - The `password:digest` pair uniquely includes `has_secure_password` in the model
   - The `has_secure_password` add methods to set and authenticate passwords with [bcrypt](https://en.wikipedia.org/wiki/Bcrypt)
   - The `password:digest` pair uniquely uses `:password_digest` as column name (not `:password`) in the migration file
   - The `password:digest` pair uniquely uses `password_digest: <%= BCrypt::Password.create('secret') %>` in the fixtures

2. Apply the new migration:

   ``` shell
$ rails db:migrate
```

3. Install the `bcrypt` gem:

   ``` shell
$ \
# Uncomment bcrypt in Gemfile:
sed -i "s/# gem 'bcrypt'/gem 'bcrypt'/g" Gemfile

# Install the gem:
bundle install
```

4. Update model for validations:

   ``` ruby
# File: app/models/user.rb
class User < ApplicationRecord
  ...
  validates :username, presence: true,
                       uniqueness: { case_sensitive: false }
  ...
end
```
   **Note:**

   - The `presence` option requires the field to be filled
   - The `uniqueness` option ensures that the field is unique in the database
   - The `uniqueness` by default, is case sensitive, so we set it to `false`

5. Open Rails console:

   ``` shell
$ rails c
```

6. Then test out the new resource:

   ``` ruby
 > # Create a user with blank fields:
 > u = User.create
   (0.4ms)  SELECT sqlite_version(*)
   (0.1ms)  begin transaction
  User Exists? (0.1ms)  SELECT 1 AS one FROM "users" ...
   (0.1ms)  rollback transaction
=> #<User id: nil, ...

 > # Check the errors caused by validations:
 > u.errors.full_messages
=> ["Password can't be blank", "Username can't be blank"]

 > # Create a valid user:
 > u = User.create(username: "foobar", password: "bazqux")
   (0.1ms)  begin transaction
  User Exists? (0.2ms)  SELECT 1 AS one FROM "users" ...
  User Create (0.2ms)  INSERT INTO "users" ("username", "password_digest", ...
   (35.9ms)  commit transaction
=> #<User id: 1, username: "foobar", password_digest: [FILTERED], ...

 > # Check the password:
 > u.password
=> "bazqux"

 > # Confirm the password is hashed:
 > u.password_digest
=> "$2a$12$6tjss5ROGLRVayuhx0et8.p4f9CTx//lDwCbq5IYiTnFspOZTNXG6"

 > # Map a new object from the database:
 > reload!
Reloading...
=> true
 > u = User.find(1)
   (0.1ms)  SELECT sqlite_version(*)
  User Load (0.2ms)  SELECT "users".* ...
=> #<User id: 1, ...

 > # Check for the password field:
 > u.password
=> nil

 > # Check for the password_digest:
 > u.password_digest
=> "$2a$12$6tjss5ROGLRVayuhx0et8.p4f9CTx//lDwCbq5IYiTnFspOZTNXG6"
```
   **Notes:**

   - The `has_secure_password` automatically added validations for the `password` field.
   - Notice that although the attribute used is `password`, the SQL used the field `password_digest`
   - The `password` attribute from the `u.password` is not a field attribute, but a virtual attribute
   - Using `save` requires another virtual attribute called `password_confirmation` to validate `password`

-------------------------------------------------------------------------------

User Sign Up
------------

### New ###

1. Visit the desired URL (e.g. <http://localhost:3000/signup>)
   <br />You should get an error:

   ``` html
Routing Error

No route matches [GET] "/signup"
```

2. Update the route:

   ``` ruby
# File: config/routes.rb
Rails.application.routes.draw do
  ...
  resources :users
  get "signup" => "users#new"
end
```
   **Note:** The generated resources can be overridden by adding a specific route definition after it.

3. Reload the browser
   <br />You should get another error:

   ``` html
Unknown action

The action 'new' could not be found for UsersController
```

4. Update the controller:

   ``` ruby
# File: app/controllers/users_controller.rb
class UsersController < ApplicationController
  def new
    @user = User.new
  end
end
```

5. Reload the browser
   <br />You should get another error:

   ``` html
No template for interactive request

UsersController#new is missing a template for request formats: text/html
```

6. Create a partial template:

   ``` shell
$ \
mkdir -p app/views/users/
echo '
<%= form_with(model: user, local: true) do |form| %>
    <%= render "shared/errors", object: user %>
    <ul>
        <li>
            <%= form.label :username %>
            <br />
            <%= form.text_field :username %>
        </li>
        <li>
           <%= form.label :password %>
            <br />
            <%= form.password_field :password %>
        </li>
        <li>
            <%= form.label :password_confirmation %>
            <br />
            <%= form.password_field :password_confirmation %>
        </li>
    </ul>
    <%= form.submit %>
<% end %>
' > app/views/users/_form.html.erb
```

7. Create the view:

   ``` shell
$ \
mkdir -p app/views/users/
echo '
<h1>Sign Up</h1>
<%= render "form", user: @user %>
' > app/views/users/new.html.erb
```

8. Reload the browser
   <br />You should see the text followed by a form:

   ``` html
Sign Up
```

### Create ###

1. Fill the form with valid values then click `Create User`:
   <br />You should get an error:

   ``` html
Unknown action

The action 'create' could not be found for UsersController
```

2. Update the controller:

   ``` ruby
# File: app/controllers/users_controller.rb
class UsersController < ApplicationController
  ...
  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to @user, notice: "Registration successful!"
    else
      render :new
    end
  end

  private

  def user_params
    params.required(:user).permit(
      :username,
      :password,
      :password_confirmation
    )
  end
end
```

### Show ###

1. Reload the browser and confirm form re-submission
   <br />You should get another error:

   ``` html
Unknown action

The action 'show' could not be found for UsersController
```

2. Update the controller:

   ``` ruby
# File: app/controllers/users_controller.rb
class UsersController < ApplicationController
  ...
  def show
    @user = User.find(params[:id])
  end
  ...
end
```

3. Reload the browser
   <br />You should get another error:

   ``` html
No template for interactive request

UsersController#show is missing a template for request formats: text/html
```

4. Create the view:

   ``` shell
$ \
mkdir -p app/views/users/
echo '
<h1>Welcome <%= @user.username %>!</h1>
' > app/views/users/show.html.erb
```

5. Reload the browser
   <br />You should see the text:

   ``` html
Welcome <username>!
```

-------------------------------------------------------------------------------

Edit User Account
-----------------

### Edit ###

1. Visit the desired URL (e.g. <http://localhost:3000/users/1/edit>)
   <br />You should get an error:

   ``` html
Unknown action

The action 'edit' could not be found for UsersController
```

2. Update the controller:

   ``` ruby
# File: app/controllers/users_controller.rb
class UsersController < ApplicationController
  ...
  def edit
    @user = User.find(params[:id])
  end
  ...
end
```

3. Reload the browser
   <br />You should get another error:

   ``` html
No template for interactive request

UsersController#edit is missing a template for request formats: text/html
```

4. Create the view:

   ``` shell
$ \
mkdir -p app/views/users/
echo '
<h1>Edit User</h1>
<%= render "form", user: @user %>
' > app/views/users/edit.html.erb
```

5. Reload the browser
   <br />You should see the text followed by a form:

   ``` html
Edit User
```

### Update ###

1. Click `Update User`:
   <br />You should get an error:

   ``` html
Unknown action

The action 'update' could not be found for UsersController
```

2. Update the controller:

   ``` ruby
# File: app/controllers/users_controller.rb
class UsersController < ApplicationController
  ...
  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      redirect_to @user, notice: "Update successful!"
    else
      render :edit
    end
  end
  ...
end
```

3. Reload the browser and confirm form re-submission
   <br />You should see the text:

   ``` html
Update successful!

Welcome <username>!
```
   **Note:** By default, `:password` and `:password_confirmation` fields aren't validated when empty.

### Destroy ###

1. Update the view:

   ``` html
<%# File: app/views/users/show.html.erb %>
<%= link_to "Delete", @user,
                      method: :delete,
                      data: { confirm: "Are you sure you want to delete this user account?" } %>
```

2. Click the `Delete` link and confirm submission
   <br />You should get an error:

   ``` html
Unknown action

The action 'destroy' could not be found for UsersController
```

3. Update the controller:

   ``` ruby
# File: app/controllers/users_controller.rb
class UsersController < ApplicationController
  ...
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to users_path, notice: "User successfully deleted!"
  end
  ...
end
```

### Index ###

1. Reload the browser and confirm form re-submission
   <br />You should get another error:

   ``` html
Unknown action

The action 'index' could not be found for UsersController
```

2. Update the controller:

   ``` ruby
# File: app/controllers/users_controller.rb
class UsersController < ApplicationController
  def index
    @users = User
  end
  ...
end
```

3. Reload the browser
   <br />You should get another error:

   ``` html
No template for interactive request

UsersController#index is missing a template for request formats: text/html
```

4. Create the view:

   ``` shell
$ \
mkdir -p app/views/users/
echo '
<h1>Registered Users</h1>
<ul>
  <% @users.each do |user| %>
  <li>
    <%= link_to user.username, user %>
  </li>
  <% end %>
</ul>
' > app/views/users/index.html.erb
```

5. Reload the browser
   <br />You should see the text:

   ``` html
User successfully deleted!

Registered Users
```

### Refactor ###

Update controller:

``` ruby
# File: app/controllers/users_controller.rb
class UsersController < ApplicationController
  before_action :set_user, except: [:index, :create, :new]

  def index
    @users = User.all
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to @user, notice: "Registration successful!"
    else
      render :new
    end
  end

  def new
    @user = User.new
  end

  # def edit
  # end

  # def show
  # end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: "Update successful!"
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to users_path, notice: "User successfully deleted!"
  end

  private

  def user_params
    params.required(:user).permit(
      :username,
      :password,
      :password_confirmation
    )
  end

  def set_user
    @user = User.find(params[:id])
  end
end
```

-------------------------------------------------------------------------------

Sign In
-------

**Notes:**

- [HTTP](https://en.wikipedia.org/wiki/Hypertext_Transfer_Protocol) is a [stateless protocol](https://en.wikipedia.org/wiki/Stateless_protocol)
- In stateless protocol, receivers (e.g. server) don't keep information
- To manage state ([stateful](https://en.wikipedia.org/wiki/State_\(computer_science\))), receivers uses [sessions](https://en.wikipedia.org/wiki/Session_\(computer_science\))
- In this example, session data will be stored using [cookies](https://en.wikipedia.org/wiki/HTTP_cookie)

<div></div>

1. Generate a controller:

   ``` shell
$ rails g controller sessions
```

2. Update routes:

   ``` ruby
# File: config/routes.rb
Rails.application.routes.draw do
  ...
  resource :session, only: [:new, :create, :destroy]
  get "signin" => "sessions#new"
  ...
end
```
   **Notes:**

   - The singular form `resource` generates route definitions without requiring an explicit `ID`
   - Unlike other routes, the session data is not stored in the database, not making use of `ID`
   - For consistency, the singular form `:session` is used to correspond to the singular `resource`
   - However, the `Controller#Action` pair for the route definitions will still use plural (e.g. `sessions#new`)
   - The `only` option specifies which routes to be generated to prevent unnecessary existence of unused routes
   - We override `:new`'s route with `"signin"` to mask the (weird?) URL `/session/new`

3. Visit the desired URL (e.g. <http://localhost:3000/signin>)
   <br />You should get an error:

   ``` html
Unknown action

The action 'new' could not be found for SessionsController
```

4. Update the controller:

   ``` ruby
# File: app/controllers/sessions_controller.rb
class SessionsController < ApplicationController
  def new
  end
end
```
   **Note:** The method is necessarily empty since there's no corresponding model to get data from.

5. Reload the browser
   <br />You should get another error:

   ``` html
No template for interactive request

SessionsController#new is missing a template for request formats: text/html
```

6. Create the view:

   ```
$ \
mkdir -p app/views/sessions/
echo '
<h1>Sign In</h1>
<%= form_with(url: session_path, local: true) do |form| %>
    <ul>
        <li>
            <%= form.label :username %>
            <br />
            <%= form.text_field :username %>
        </li>
        <li>
            <%= form.label :password %>
            <br />
            <%= form.password_field :password %>
        </li>
    </ul>

    <%= form.submit "Sign In" %>
<% end %>
' > app/views/sessions/new.html.erb
```
   **Notes:**

   - Use the `url` option since there's no model attached to the session
   - Override the default `submit` label (`Save`) with `Sign In`

7. Reload the browser
   <br />You should see the text followed by a form:

   ``` html
Sign In
```

-------------------------------------------------------------------------------

Authentication
--------------

**Notes:**

- Authentication is the process of verifying the identity of a user or service
- It is distinguishing a registered from a non-registered user
- It is a precursor to authorization

<div></div>

1. Fill the form with valid values then click `Sign In`:
   <br />You should get an error:

   ``` html
Unknown action

The action 'create' could not be found for SessionsController
```

2. Update the controller:

   ``` ruby
# File: app/controllers/sessions_controller.rb
class SessionsController < ApplicationController
  ...
  def create
    @user = User.find_by(username: params[:username])

    if @user and @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect_to @user, notice: "Welcome back #{@user.username}!"
    else
      flash.now[:alert] = "Invalid username or password"
      render :new
    end
  end
end
```
   **Notes:**

   - The `authenticate` method is provided by `has_secure_password`
   - The `authenticate` method returns the receiver (`self`) if the password is valid
   - It is necessary to make sure that the instance variable is not `nil` before authenticating
   - The `and` is a subjective style preference over using `&&` (which has higher precedence)
   - The `session` method stores a cookie with a unique ID (Rails uses cookies to store sessions)
   - The `flash.now` flashes the text on the same request (instead of after rendering the template)
   - The `alert` option is just an alternative way of implying that the text is not a normal message

<div></div>

**Note about Rails' session cookies:**

- It expires when the browser is closed
- It is limited only to `4kb` (hence, only storing user's ID)
- It is [cryptographically signed](https://en.wikipedia.org/wiki/Digital_signature) (e.g. tamper-proof)
- It is [encrypted](https://en.wikipedia.org/wiki/Encryption) which makes it unreadable to potential [crackers](https://en.wikipedia.org/wiki/Security_hacker#Cracker)
- It is not intended to store sensitive information (e.g. passwords)

**To see the session cookie on Google Chrome:**

1. Right click > Inspect (or press `ctrl+shift+i`)
2. Select `Application` tab
3. Scroll and find `Storage`
4. Expand `Cookies`
5. The select `http://localhost:3000`

-------------------------------------------------------------------------------

Current User
------------

### On Sign In ###

1. Visit the root URL (e.g. <http://localhost:3000>)

2. Update the application-wide view:

   ``` html
<%# File: app/views/layouts/_header.html.erb %>
<header>
    ...
    <ul>
        <% if current_user %>
            <li>
                <%= link_to current_user.username, current_user %>
            </li>
        <% else %>
            <li>
                <%= link_to "Sign In", signin_path %>
            </li>
            <li>
                <%= link_to "Sign Up", signup_path %>
            </li>
        <% end %>
    </ul>
</header>
```
   **Notes:**

   - The `current_user` is a view helper method that returns a `User` object
   - If the `current_user` is an object (non-`nil`), then show the username with a link
   - However, if the `current_user` is `nil`, show both `Sign In` and `Sign Up` links
   - The `signin_path` is the re-mapped route of `new_session_path`
   - The `signup_path` is the re-mapped route of `new_user_path`

3. Reload the browser
   <br />You should get an error:

   ``` html
NameError in Pages#index
...
undefined local variable or method `current_user' for #<#<Class:0x...>:0x...>
```

4. Update the application-wide view helper:

   ``` ruby
# File: app/helpers/application_helper.rb
module ApplicationHelper
  def current_user
    @user_id = session[:user_id]

    if @user_id
      @current_user ||= User.find(@user_id)
    end
  end
end
```
   **Notes:**

   - Assign the value of `session[:user_id]` to an instance variable (`nil` if empty)
   - Only when it's not `nil`, assign the model object corresponding with the `user_id`
   - The `OR Equal` (`||=`) is a conditional assignment operator (also referred as [memoization](https://en.wikipedia.org/wiki/Memoization))
   - ^ It assigns the right value to the left if it's falsy (e.g. `false` or `nil`)
   - ^ But if the left value is truthy (non-`false` or non-`nil`), the assignment is ignored
   - ^ It is useful to avoid hitting the database multiple times just to check with session cookie

5. Reload the browser then:

   1. Click `Sign In` link
   2. Fill the form with valid credentials
   3. Click `Sign In` button

You should see the texts:

   ``` html
* <username>

Welcome back <username>!
```

### On Sign Up ###

1. Update the controller:

   ``` ruby
# File: app/controllers/users_controller.rb
class UsersController < ApplicationController
  ...
  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id
      redirect_to @user, notice: "Registration successful!"
    else
      render :new
    end
  end
  ...
end
```
   **Note:** We set the user's ID on the session after successfully creating the user account.

2. Reload the browser then:

   1. Click `Sign Up` link
   2. Fill the form with valid credentials
   3. Click `Create User` button

You should see the texts:

   ``` html
* <username>

Welcome back <username>!
```

-------------------------------------------------------------------------------

Sign Out
--------

### Sign Out link ###

1. Visit the root URL (e.g. <http://localhost:3000>)

   ``` ruby
# File: config/routes.rb
Rails.application.routes.draw do
  ...
  resources :users
  ...
  delete "signout" => "sessions#destroy"
end
```

2. Update the application-wide view:

   ``` html
<%# File: app/views/layouts/_header.html.erb %>
<header>
    ...
        <% if current_user %>
            ...
            <li>
                <%= link_to "Sign Out", signout_path,
                                        method: :delete %>
            </li>
            ...
        <% end %>
    ...
</header>
```
   **Note:** The `signout_path` is the re-mapped route of `session_path` (`delete`).

3. Click the `Sign Out` link
   <br />You should get an error:

   ``` html
Routing Error

No route matches [DELETE] "/signout"
```


4. Update the controller

   ``` ruby
# File: app/controllers/sessions_controller.rb
class SessionsController < ApplicationController
  ...
  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "You've been successfully signed out!"
  end
  ...
end
```
   **Note:** Assigning `nil` to the session makes it invalid (unusable).

5. Reload the browser
   <br />You should see the text:

   ``` html
You've been successfully signed out!
```

### Delete link ###

1. While signed in, click the `Delete` link and confirm submission
   <br />You should get an error:

   ``` html
ActiveRecord::RecordNotFound in Users#index

Couldn't find User with 'id'=1
```

2. Update the controller:

   ``` ruby
# File: app/controllers/users_controller.rb
class UsersController < ApplicationController
...
  def destroy
    ...
    session[:user_id] = nil
    ...
  end
...
end
```
   **Note:** Assigning `nil` to the session prevents the `current_user` to query a non-existent user ID.

3. Reload the browser and confirm form re-submission
   <br />You should see the text followed by a form:

   ``` html
User successfully deleted!
```

-------------------------------------------------------------------------------

Authorization
-------------

**Notes:**

- Authorization specifies the access rights or privileges of a user or service
- It is granting a specific permission to an authenticated user
- It is done after a successful authentication
- Example is betwen normal vs. admin users


### Layer 1 ###

1. Update the controller:
   <br />**Note:** The first restriction is against non-signed in users.

   ``` ruby
# File: app/controllers/users_controller.rb
class UsersController < ApplicationController
  before_action :require_signin, except: [:create, :new]
  ...
  def require_signin
    unless current_user
      redirect_to signin_path, alert: "You need to sign in first!"
    end
  end
end
```
  **Note:** The `except` method excludes the specified actions (`create` and `new`) from the `before_action` method call.

2. Update the application-wide controller:

   ``` ruby
# File: app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  ...
  private

  def current_user
    @user_id = session[:user_id]

    if @user_id
      @current_user ||= User.find(@user_id)
    end
  end

  helper_method :current_user
end
```

  - All the controller classes in the Rails app inherits from the `ApplicationController` class
  - All the methods defined in the `ApplicationController` class will be available on all the controller classes
  - The `private` method restricts the methods below it to be only accessible by the controller classes that inherit its class
  - The `current_user` method is moved to `ApplicationController` class since view helper methods are inaccessible in controllers
  - The `helper_method` makes the specified method available to views since controller methods are inaccessible on views
  - The `unless` condition is a subjective style preference over using `if !` or `if not` (esp. for falsy conditions with no `else`)

3. Visiting user routes that is not related with `create` and `new` actions will cause a redirect to [/signin](http://localhost:3000/signin)

### Layer 2 ###

1. Update the controller:

   ``` ruby
# app/controllers/users_controller.rb
class UsersController < ApplicationController
  ...
  before_action :require_correct_user, only: [:edit, :update, :destroy]
  ...
  def require_correct_user
    @user = set_user
    unless @user === current_user
      redirect_to root_path
    end
  end
end
```
   **Notes:**

   - The order of `before_action` is important since the lines are executed in sequence
   - The `only` method only performs the `before_action` on the specified actions (`edit`, `update` and `destroy`)
   - The `require_correct_user` method restrict users to only touch their own user accounts (redirect on attempts)
   - The `set_user` is an existing method that is being re-used (which maps a user object using an id)

2. Update the application-wide controller:

   ``` ruby
# File: app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  ...
  def current_user?(user)
    current_user == user
  end

  helper_method :current_user?
end
```
   **Note:** `current_user?` method makes sure that the current signed in user owns the restricted URLs.

3. Update the application-wide view:

   ``` html
<%# File: app/views/users/show.html.erb %>
<% if current_user?(@user) %>
    <%= link_to "Delete", @user,
                          method: :delete,
                          data: { confirm: "Are you sure you want to delete this user account?" } %>
<% end %>
```

4. Visiting user routes related to `edit`, `update`, and `destroy` actions that is not owned by the user will cause a redirect to [homepage](http://localhost:3000/users)

### HTTP referer ###

**Notes:**

- The [HTTP referer](https://en.wikipedia.org/wiki/HTTP_referer) enables the system to know where the request originated
- It enables systems to determine where to redirect back the users before they were intercepted by the sign in page

<div></div>

1. Update the controller (user):

   ``` ruby
# File: app/controllers/users_controller.rb
class UsersController < ApplicationController
  ...
  def require_signin
    unless current_user
      session[:referrer] = request.path
      redirect_to signin_path, alert: "You need to sign in first!"
    end
  end
  ...
end
```
   **Note:** The `request.path` method return the current relative path of the page.

2. Update the controller (session):

   ``` ruby
# File: app/controllers/sessions_controller.rb
class SessionsController < ApplicationController
  ...
  def create
    @user = User.find_by(username: params[:username])

    if @user and @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect_to (session[:referrer] || @user), notice: "Welcome back #{@user.username}!"
    else
      flash.now[:alert] = "Invalid username or password"
      render :new
    end
  end
  ...
end
```
   **Note:** The `redirect_to` will redirect to the referrer if it's not empty, otherwise, to the user's path.

3. Visiting a restricted route will redirect back to that URL after sign in

-------------------------------------------------------------------------------

Admin Users
-----------

**Notes:**

- An admin, a.k.a. [superuser](https://en.wikipedia.org/wiki/Superuser) is a special user account
- A superuser is capable of doing all possible actions in the system (bypassing all restrictions)
- In this example, only the admin can delete a user account

<div></div>

1. Create a new migration:

   ``` shell
$ rails g migration AddAdminToUsers admin:boolean
```

2. Apply the new migration:

   ``` shell
$ rails db:migrate
```

3. Create an admin user:

   ``` shell
$ rails c
 > # Create an admin user:
 > u = User.create(username: "foo", password: "bar", admin: true)
   (0.4ms)  SELECT sqlite_version(*)
   (0.1ms)  begin transaction
  User Exists? (0.2ms)  SELECT 1 AS one FROM "users" ...
  User Create (0.2ms)  INSERT INTO "users" ...
   (12.1ms)  commit transaction
=> #<User id: 1, ...
```

4. Update the controller:

   ``` ruby
# File: app/controllers/users_controller.rb
  ...
  before_action :require_correct_user, only: [:edit, :update]
  before_action :require_admin, only: [:destroy]
  ...
  def destroy
    @user.destroy
    redirect_to users_path, notice: "User successfully deleted!"
  end
  ...
```

5. Update the application-wide controller:

   ``` ruby
# File: app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  ...
  def current_user_admin?
    current_user and current_user.admin?
  end

  helper_method :current_user_admin?
end
```
   **Note:** The `current_user_admin?` checks if the current user is the assigned user and is also an admin.

6. Update the application-wide view:

   ``` html
<header>
    <% if current_user_admin? %>
        <div>
            <strong>Super User</strong>
        </div>
    <% end %>
...
</header>
```
   **Note:** Only the admin should see the **Super User** text.

7. [Sign in](http://localhost:3000/signin) using the admin account
   <br />You should be able to:

   - See the **Super User** text
   - Delete any accounts

8. Alternatively, [sign in](http://localhost:3000/signin) using a non admin account
   <br />You shouldn't be able to:

   - See the **Super User** text
   - Delete any accounts
   - Clicking `Delete` link and confirming submission will cause a redirect to [homepage](localhost:3000) and display:
     <br />`You are not allowed to perform the action!`
     <br />**Note:** The `Delete` link was intentionally displayed to demonstrate the example since it's not possible to trigger it manually.

Let's continue to the last part: [Ruby on Rails 6: Week 5](ruby-on-rails-6-week-5).
