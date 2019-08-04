{:title       "Ruby on Rails: Test-driven development"
 :layout      :post
 :summary     "
              This document is a simplified summary of the Ruby on Rails Tutorial's chapter 3.3: Getting started with testing.
              The goal is to focus solely on building the project from the ground up using the test-driven development (a.k.a. TDD) software development process."
 :excerpt     "This document is a simplified summary of the Ruby on Rails Tutorial's chapter 3.3: Getting started with testing."
 :description "A simplified summary of the Ruby on Rails Tutorial's chapter 3.3: Getting started with testing."
 :date        "2019-10-25"
 :tags        ["development"
               "web-application-framework"
               "ruby-on-rails"
               "ruby"]}

-------------------------------------------------------------------------------

This great book, [Ruby on Rails Tutorial](https://www.railstutorial.org), was finally updated to the 6th edition to cover [Ruby on Rails](https://rubyonrails.org) 6.
Unlike before, though, all chapters of the book isn't available online for free as it used to, however, in my opinion,
people who learned a somewhat complete sense of Rails will still benefit from its first 3 free chapters;
one being the third chapter, on section three: [Getting started with testing](https://www.railstutorial.org/book/static_pages#sec-getting_started_with_testing) &mdash; which this document is about.

-------------------------------------------------------------------------------

Prerequisites
-------------

Before proceeding, make sure that the following are installed:

- [RVM](https://rvm.io)
- [Yarn](https://yarnpkg.com)

-------------------------------------------------------------------------------

**Note:** In this guide, we'll use the name `rails-tdd` (replace it with whatever name you want).

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
rails new rails-tdd
cd rails-tdd/
```

3. Apply migration:

   ``` shell
$ rails db:migrate
```

4. Check if the test setup is working:

   ``` shell
$ rails test:system test
...
# Running:

Finished in 0.069522s, 0.0000 runs/s, 0.0000 assertions/s.
0 runs, 0 assertions, 0 failures, 0 errors, 0 skips
```
   **Note:** `test:system` is used to also run system tests.

-------------------------------------------------------------------------------

Feature
-------

Before writing the test, a clear understanding of the following is necessary:

- [Specification](https://en.wikipedia.org/wiki/Specification_\f(technical_standard\)) (technical description)
- [Requirements](https://en.wikipedia.org/wiki/Requirement) (user expectations)
- [Feature](https://en.wikipedia.org/wiki/Software_feature) as the produced artifact

**Example:**

``` html
Feature: Hello World! on homepage
  Scenario: User visits homepage to see Hello World!
    Given a web browser
    When I visit http://localhost:3000
    Then I should see the text: Hello World!
```

-------------------------------------------------------------------------------

Red / Green / Refactor
----------------------

### [1] Red: Write a failing test ###

**Note:** Before we can write any test, we need to generate the boilerplate which includes the test file:

``` shell
$ rails g controller Pages
```

**Note:** The `controller` generator generates the smallest boilerplate with test files.

1. Write the test:

   ``` ruby
# File: test/controllers/pages_controller_test.rb
require 'test_helper'

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "should get homepage" do
    get "/"
    assert_select "body", "Hello World!"
  end
end
```

2. Run the test (which should fail):

   ``` shell
$ rails test:system test test/controllers/pages_controller_test.rb
Running via Spring preloader in process 52281
Run options: --seed 22224

# Running:

E

Error:
PagesControllerTest#test_should_get_homepage:
ActionController::RoutingError: No route matches [GET] "/"
    test/controllers/pages_controller_test.rb:5:in `block in <class:PagesControllerTest>'

rails test test/controllers/pages_controller_test.rb:4

Finished in 0.086679s, 11.5368 runs/s, 0.0000 assertions/s.
1 runs, 0 assertions, 0 failures, 1 errors, 0 skips
```
   **Note:** Limiting the test only to the test file prevents expensive execution of all the tests.

### [2] Green: Make the test pass ###

**Notes:**

- Write only enough and the necessary code to make the test pass
- Avoid writing code beyond what the test requires
- **Do not refactor during this step**

<div></div>

1. Update the routes:

   ``` ruby
# File: config/routes.rb
Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get "/" => "pages#index"
end
```

2. Re-run the test:

   ``` shell
$ rails test:system test test/controllers/pages_controller_test.rb
Running via Spring preloader in process 53025
Run options: --seed 52727

# Running:

E

Error:
PagesControllerTest#test_should_get_homepage:
AbstractController::ActionNotFound: The action 'index' could not be found for PagesController
    test/controllers/pages_controller_test.rb:5:in `block in <class:PagesControllerTest>'

rails test test/controllers/pages_controller_test.rb:4

Finished in 0.136708s, 7.3148 runs/s, 0.0000 assertions/s.
1 runs, 0 assertions, 0 failures, 1 errors, 0 skips
```

3. Update the controller:

   ``` ruby
# File: app/controllers/pages_controller.rb
class PagesController < ApplicationController
  def index
  end
end
```

4. Re-run the test:

   ``` shell
$ rails test:system test test/controllers/pages_controller_test.rb
Running via Spring preloader in process 53669
Run options: --seed 17464

# Running:

E

Error:
PagesControllerTest#test_should_get_homepage:
ActionController::MissingExactTemplate: PagesController#index is missing a template for request formats: text/html
    test/controllers/pages_controller_test.rb:5:in `block in <class:PagesControllerTest>'

rails test test/controllers/pages_controller_test.rb:4

Finished in 0.088892s, 11.2497 runs/s, 0.0000 assertions/s.
1 runs, 0 assertions, 0 failures, 1 errors, 0 skips
```

5. Create the view:

   ``` shell
$ echo 'Hello World!' > app/views/pages/index.html.erb
```

6. Re-run the test:

   ``` shell
$ rails test:system test test/controllers/pages_controller_test.rb
Running via Spring preloader in process 45601
Run options: --seed 21618

# Running:

.

Finished in 5.312918s, 0.1882 runs/s, 0.1882 assertions/s.
1 runs, 1 assertions, 0 failures, 0 errors, 0 skips
```
    **Note:** Visiting <http://localhost:3000> in a web browser should display `Hello World!`.

### [3] Refactor: Refactor the code ###

1. Run all the tests:
   <br />**Notes:**
   - This ensures that all previously working code are still functioning properly along with the newly tested feature
   - This aspect is called [Regression testing](https://en.wikipedia.org/wiki/Regression_testing) which is done *before* and *after* refactoring

``` shell
$ rails test:system test
Running via Spring preloader in process 54306
Run options: --seed 3605

# Running:
.

Finished in 1.300774s, 0.7688 runs/s, 0.7688 assertions/s.
1 runs, 1 assertions, 0 failures, 0 errors, 0 skips
```

2. Update the test:

   ``` ruby
# File: test/controllers/pages_controller_test.rb
require 'test_helper'

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "should get homepage" do
    get root_path
    assert_select "body", "Hello World!"
  end
end
```
   **Note:** It turns out, Rails has a method specifying the homepage (`root_path`)

3. Re-run the test:

   ``` shell
$ rails test:system test test/controllers/pages_controller_test.rb
Running via Spring preloader in process 61390
Run options: --seed 28144

# Running:

E

Error:
PagesControllerTest#test_should_get_homepage:
NameError: undefined local variable or method `root_path' for #<PagesControllerTest:0x00007f58b839c228>
    test/controllers/pages_controller_test.rb:5:in `block in <class:PagesControllerTest>'

rails test test/controllers/pages_controller_test.rb:4

Finished in 0.134513s, 7.4342 runs/s, 0.0000 assertions/s.
1 runs, 0 assertions, 0 failures, 1 errors, 0 skips
```

4. Refactor the routes:

   ``` ruby
# File: config/routes.rb
Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root "pages#index"

  resources :pages
end
```
   **Note:** The `resources` provides all the essential routes and `root` points the specific `Controller#Action` to the homepage.

5. Re-run the test:

   ``` shell
$ rails test:system test test/controllers/pages_controller_test.rb
Running via Spring preloader in process 61531
Run options: --seed 23743

# Running:

.

Finished in 1.397421s, 0.7156 runs/s, 1.4312 assertions/s.
1 runs, 2 assertions, 0 failures, 0 errors, 0 skips
```

6. Refactor the controller:

   ``` ruby
# File: app/controllers/pages_controller.rb
class PagesController < ApplicationController
  def index
    @title = "Hello World!"
  end
end
```
   **Note:** Instead of hard coding the data to the views, the controller should be the one to decide what data to display in the views.

7. Re-run the test:

   ``` shell
$ rails test:system test test/controllers/pages_controller_test.rb
Running via Spring preloader in process 61645
Run options: --seed 8337

# Running:

.

Finished in 1.285618s, 0.7778 runs/s, 1.5557 assertions/s.
1 runs, 2 assertions, 0 failures, 0 errors, 0 skips
```

8. Refactor the view:

   ``` ruby
<%# File: app/views/pages/index.html.erb %>
<%= @title %>
```

9. Re-run the test:

   ``` shell
$ rails test:system test test/controllers/pages_controller_test.rb
Running via Spring preloader in process 61804
Run options: --seed 12510

# Running:

.

Finished in 1.266433s, 0.7896 runs/s, 1.5792 assertions/s.
1 runs, 2 assertions, 0 failures, 0 errors, 0 skips
```

10. Run all the tests:

   ``` shell
$ rails test:system test
Running via Spring preloader in process 61892
Run options: --seed 6429

# Running:

.

Finished in 1.361797s, 0.7343 runs/s, 1.4686 assertions/s.
1 runs, 2 assertions, 0 failures, 0 errors, 0 skips
```
    **Note:** Visiting <http://localhost:3000> in a web browser should still display `Hello World!`.

### Repeat ###

Repeat the same process on new test cases until the specification is met and requirements are achieved.

**Note:** For a more detailed guideline about testing (e.g. terminologies, kinds of tests and other approaches), see [Testing Rails Applications](https://guides.rubyonrails.org/testing.html).

**Congratulations!** We've finally learned test-driven development (a.k.a. TDD) in Rails :)

-------------------------------------------------------------------------------

Bonus
-----

### Documentation ###

Use the `rdoc` gem to generate documentation:

``` shell
$ rdoc -m README.md   \
       -t 'rails-tdd' \
       -o docs/       \
       README.md      \
       LICENSE        \
       app/**/*.rb
```

**Notes:**

- `-m` is the initial page displayed
- `-t` is the browser title
- `-o` is the directory path
- The homepage of generated html is then at `docs/index.html`

### Better reporting ###

Use the `minitest-reporters` extension of `minitest` gem to display a more pleasant test output.

1. Update the `Gemfile`:

   ``` ruby
# File: Gemfile
...
group :test do
  ...
  gem 'minitest'
  gem 'minitest-reporters'
end
...
```

2. Install the gems:

   ``` shell
$ bundle
```

3. Update test helper:

   ``` ruby
# File: test/test_helper.rb
...
require 'minitest/reporters'

Minitest::Reporters.use!

class ActiveSupport::TestCase
  ...
end
...
```

4. Run all the tests:

   ``` shell
$ rails test:system test
Running via Spring preloader in process 16887
Started with run options --seed 5427

  1/1: [==================================================] 100% Time: 00:00:00, Time: 00:00:00

Finished in 0.82411s
1 tests, 1 assertions, 0 failures, 0 errors, 0 skips
```

### Automated testing ###

Use the `guard-minitest` extension of `guard` gem to automate running of tests when files are changed.

1. Update the `Gemfile`:

   ``` ruby
# File: Gemfile
...
group :test do
  ...
  gem 'guard'
  gem 'guard-minitest'
end
...
```

2. Install the gems:

   ``` shell
$ bundle
```

3. Generate a `Guardfile`:

   ``` shell
$ guard init
```

4. Uncomment `Rails 4`'s `watch` lines:

   ``` ruby
guard :minitest do
  ...
  # Rails 4
  watch(%r{^app/(.+)\.rb$})                               { |m| "test/#{m[1]}_test.rb" }
  watch(%r{^app/controllers/application_controller\.rb$}) { 'test/controllers' }
  watch(%r{^app/controllers/(.+)_controller\.rb$})        { |m| "test/integration/#{m[1]}_test.rb" }
  watch(%r{^app/views/(.+)_mailer/.+})                    { |m| "test/mailers/#{m[1]}_mailer_test.rb" }
  watch(%r{^lib/(.+)\.rb$})                               { |m| "test/lib/#{m[1]}_test.rb" }
  watch(%r{^test/.+_test\.rb$})
  watch(%r{^test/test_helper\.rb$}) { 'test' }
  ...
end
```

4. Run `guard` to automate running tests:

   ``` shell
$ guard
Started with run options --guard --seed 46650

  1/1: [==================================================] 100% Time: 00:00:00, Time: 00:00:00

Finished in 0.83682s
1 tests, 1 assertions, 0 failures, 0 errors, 0 skips

[1] guard(main)>
```
    You should see a `Minitest results` notification.

### Linter ###

Use the `rubocop-rails` extension of `rubocop` gem as linter that enforces Rails best practice and code conventions.

1. Update the `Gemfile`:

   ``` ruby
# File: Gemfile
group :test do
  ...
  gem 'rubocop'
  gem 'rubocop-rails_config'
end
```

2. Install the gems:

   ``` shell
$ bundle
```

3. Run linter:

   ``` shell
$ rubocop -l
```
   **Note:** `-l` replaces Ruby's `-w` linter.

### Security ###

Use the `brakeman` gem to check possible security vulnerabilities.

1. Update the `Gemfile`:

   ``` ruby
# File: brakeman
group :development do
  ...
  gem 'brakeman'
end
```

2. Check security:

   ``` shell
$ \
brakeman -q
brakeman -q -o security/index.html
```
   **Notes:**

   - `-q` supresses warnings and just output the report
   - `-o` writes the result in the specified file path
   - `brakeman` returns a `non-zero exit` status when vulnerabilities are found
   - The generated html is then at `security/index.html`

### Code coverage ###

- Use the `simplecov` gem to measure the coverage of code that were executed during tests
- Use the `simplecov-console` gem for a better console output (not just a percentage)

1. Update the `Gemfile`:

   ``` ruby
# File: Gemfile
...
group :test do
  ...
  gem 'simplecov'
  gem 'simplecov-console'
end
...
```

2. Install the gems:

   ``` shell
$ bundle
```

3. Update test helper file:

   ``` ruby
# File: test/test_helper.rb
ENV['RAILS_ENV'] ||= 'test'

require 'simplecov'
SimpleCov.start 'rails'
SimpleCov.minimum_coverage 100
SimpleCov.formatter = SimpleCov::Formatter::Console
...
```
   **Notes:**

   - Put `simplecov` before any other `require`s
   - `'rails'` is a profile containing predefined blocks of configuration
   - `minimum_coverage` is the desired coverage percentage (e.g. `100`%)
   - ^ It returns a `non-zero exit` status if the percentage was less than specified
   - `formatter` is the custom format when displaying the coverage results

4. Run the test:

   ``` shell
$ rails test:system test
Running via Spring preloader in process 43616
Started with run options --seed 22410

  1/1: [==================================================] 100% Time: 00:00:00, Time: 00:00:00

Finished in 0.96810s
1 tests, 1 assertions, 0 failures, 0 errors, 0 skips

COVERAGE:   7.41% -- 2/27 lines in 9 files

+----------|----------------------------------------------|-------|--------|---------+
| coverage | file                                         | lines | missed | missing |
+----------|----------------------------------------------|-------|--------|---------+
|   0.00%  | app/channels/application_cable/channel.rb    | 4     | 4      | 1-4     |
|   0.00%  | app/channels/application_cable/connection.rb | 4     | 4      | 1-4     |
|   0.00%  | app/controllers/application_controller.rb    | 2     | 2      | 1-2     |
|   0.00%  | app/controllers/pages_controller.rb          | 5     | 5      | 1-5     |
|   0.00%  | app/helpers/application_helper.rb            | 2     | 2      | 1-2     |
|   0.00%  | app/helpers/pages_helper.rb                  | 2     | 2      | 1-2     |
|   0.00%  | app/jobs/application_job.rb                  | 2     | 2      | 1, 7    |
|   0.00%  | app/mailers/application_mailer.rb            | 4     | 4      | 1-4     |
+----------|----------------------------------------------|-------|--------|---------+
1 file(s) with 100% coverage not shown
Coverage (7.41%) is below the expected minimum coverage (100.00%).
SimpleCov failed with exit 2
```
    **Note:** A generated `html` version is then at `coverage/index.html`.

### Metrics, monitoring, and alerting ###

For metrics, monitoring, and alerting, see [AppSignal](https://appsignal.com).
