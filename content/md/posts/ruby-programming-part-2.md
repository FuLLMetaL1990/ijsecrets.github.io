{:title       "Ruby Programming: Part 2"
 :layout      :post
 :summary     "
              This document is the continuation of Ruby Programming: Part 1 and will be about
              1) attributes,
              2) arrays,
              3) objects interacting,
              4) separate source files,
              5) unit testing
              and 6) conditionals & TDD.
              "
 :excerpt     "This is the summary for page 2 of 4 of The Pragmatic Studio's 23-Day Course Plan of the Ruby Programming course."
 :description "Page 2 of 4 summary of The Pragmatic Studio's 23-Day Course Plan of the Ruby Programming course."
 :date        "2019-08-25"
 :tags        ["research"
               "programming-language"
               "ruby"]}

-------------------------------------------------------------------------------

**Note:** This is the continuation of [Ruby Programming: Part 1](ruby-programming-part-1).

This document will be the summary of page 2 from the course outline, [23-Day Course Plan](https://pragmaticstudio.s3.amazonaws.com/courses/ruby/PragStudioRubyPlan.pdf) of [The Pragmatic Studio](https://pragmaticstudio.com)'s [Ruby Programming](https://pragmaticstudio.com/courses/ruby) course.

-------------------------------------------------------------------------------

Attributes
----------

- Attributes are private:

  ``` ruby
 > class Cls
?>   def initialize(param)
?>     @param = param
?>   end
=> :initialize

 > inst = Cls.new("arg")
=> #<Cls:0x0000564dda0a9ff0 @param="arg">
 > inst.param
 NoMethodError (undefined method `param' for #<Cls:0x0000564dda0a9ff0 @param="arg">)
```

- Define a getter method (the accessor method) to read attributes:

  ``` ruby
 > class Cls
?>   def initialize(param)
?>     @param = param
?>   end
?>
?>   def param
?>     @param
?>   end
=> :param

 > inst = Cls.new("arg")
=> #<Cls:0x0000564dda0a9ff0 @param="arg">
 > inst.param
=> "arg"
```

- Or use the `attr_reader` macro to auto-generate a getter method:

  ``` ruby
 > class Cls
?>   attr_reader :param # :param is a symbol that references
?>                      # the instance variable @param
?>
?>   def initialize(param)
?>     @param = param
?>   end
=> :initialize

 > inst = Cls.new("arg")
=> #<Cls:0x0000564dda0a9ff0 @param="arg">
 > inst.param
=> "arg"
```

- Attributes cannot be directly modified:

  ``` ruby
?> inst.param = "new arg"
NoMethodError (undefined method `param=' for #<Cls:0x0000564dda0a9ff0 @param="arg">)
```

- Define a setter method (the mutator method) to change the value of instance variables:

  ``` ruby
 > class Cls
?>   def initialize(param)
?>     @param = param
?>   end
?>
?>   def param=(new_param)
?>     @param = new_param
?>   end
=> :param=

 > inst = Cls.new("arg")
=> #<Cls:0x0000564dda0a9ff0 @param="arg">
 > inst.param = "new arg"
=> "new arg"
```

- Or use the `attr_writer` macro to auto-generate a setter method:

  ``` ruby
 > class Cls
?>   attr_writer :param # :param is a symbol that references
?>                      # then instance variable @param
?>
?>   def initialize(param)
?>     @param = param
?>   end
=> :initialize

 > inst = Cls.new("arg")
=> #<Cls:0x0000564dda0a9ff0 @param="arg">
 > inst.param = "new arg"
=> "new arg"
```

- Or use the `attr_accessor` macro to auto-generate both getter and setter methods:

  ``` ruby
 > class Cls
?>   attr_accessor :param # :param is a symbol that references
?>                        # the instance variable name @param
?>
?>   def initialize(param)
?>     @param = param
?>   end
=> :initialize

 > inst = Cls.new("arg")
=> #<Cls:0x0000564dda0a9ff0 @param="arg">
 > inst.param
=> "arg"
 > inst.param = "new arg"
=> "new arg"
```

- Use virtual attributes to avoid unnecessary instance variables:

  ``` ruby
 > class Cls
?>   def va_param                # virtual attribute (getter)
?>     @va_param
?>   end
?>
?>   def va_param=(new_va_param) # virtual attribute (setter)
?>     @va_param = new_va_param
?>   end
?>
?>   def to_s
?>     "#<class=\"#{self.class.name} @va_param=\"#{@va_param}\">"
?>   end
?> end
=> :to_s

 > inst = Cls.new
=> #<Cls:0x0000564dda0a9ff0>
 > inst.va_param
=> nil
 > inst.va_param = "varg"
=> "varg"
 > inst.va_param
=> "varg"
```

**Note:** Virtual attributes hide the differences between instance variables and calculated values (UAP).

-------------------------------------------------------------------------------

Arrays
------

- Create an array instance with the `Array` class:

  ``` ruby
 > Array.new
=> []
```

- Or create an array object with the array literal:

  ``` ruby
 > []
=> []
```

- Or use `%w` or `%W` wrapped in pair of delimiters:

  ``` ruby
 > %w[hello\sworld #{1+1.0}] # create an unevaluated array of strings
                             # [] are the delimiters
=> ["hello\\sworld", "\#{1+1.0}"]

 > %W[hello\sworld #{1+1.0}] # create an evaluated array of strings
                             # [] are the delimiters
=> ["hello world", "2.0"]
```

- Contains an ordered collection of object references:

  ``` ruby
 > ["foo", 0, false]
=> ["foo", 0, false]
```

- Each item in an array holds an index that specifies the item position:

  ``` ruby
 > o = ["foo", 0, false]
=> ["foo", 0, false]

 > o[1] # access the item at 2nd index position
=> 0
```

- The array index count begins at 0 when doing left-to-right access:

  ``` ruby
 > o[0]
=> "foo"
```

- The last array index count ends at -1 when doing right-to-left access:

  ``` ruby
 > o[-1]
=> false
```

- Items in an array are also accessible thru ranges:

   ``` ruby
 > o = ["foo", "bar", "baz"]
=> ["foo", "bar", "baz"]

 > # with [start,count]
 > # (excludes the last specified index position):
 > o[0,1] # access the items
          # from the first index position
          # to but excluding the 2nd index position
=> ["foo"]

 > # with [start...count]
 > # (three dots does same effect as above):
 > o[0...1] # access the items
            # from the first index position
            # to but excluding the 2nd index position
=> ["foo"]

 > # with [start..count]:
 > # (two dots includes the last specified index position):
 > o[0..1] # access the items
           # from the first index position
           # to the 2nd index position
=> ["foo", "bar", "baz"]
```

- Items in an array can be overwritten thru index:

  ``` ruby
 > o[0] = "oof" # replace the item
                # on the first index position
                # ("foo" to "oof")
=> "oof"
 > o
=> ["oof", "bar", "baz"]
```

- Items in an array can also be overwritten thru ranges:

  ``` ruby
 > o[1,0] = "blah" # insert before the item
                   # on the 2nd index position
                   # ("oof", "bar" to "oof", "blah", "bar")
=> "blah"
 > o
=> ["oof", "blah", "bar", "baz"]

 > o[1,2] = "halbrab" # insert before the item
                      # on the 2nd index position
                      # then replace the next 2
                      # items after that
                      # ("blah", "bar" to "halbrab")
=> "halbrab"
 > o
=> ["oof", "halbrab", "baz"]

 > o[1,2] = ["foo", "bar"] # insert before the item
                           # on the 2nd index position
                           # then replace the next 2
                           # items after that with a
                           # flattened array items
                           # ("halbrab", "baz" to
                           # "foo", "bar")
=> ["foo", "bar"]
 > o
=> ["oof", "foo", "bar"]

 > o[0...1] = [] # remove the items
                 # from the first index position
                 # to but excluding the 2nd index position
                 # ("oof", "foo" to "foo")
=> []
 > o
=> ["foo", "bar"]

 > o[0..1] = [] # remove the items
                # from the first index position
                # to the 2nd index position
                # ("foo", "bar" to [])
=> []
 > o
=> []
```

- Gaps in arrays are automatically filled with `nil` object:

  ``` ruby
 > o = []
=> []
 > o[1] = "bar"
=> "bar"
 > o
=> [nil, "bar"]
```

- Use the `push` and `pop` methods to implement LIFO (Last In, First Out):

  ``` ruby
 > o = ["foo", "bar"]
=> ["foo", "bar"]

 > o.push("baz") # add item after the last index position
                 # (append)
=> ["foo", "bar", "baz"]

 > o.pop         # remove the item in the last index position
=> "baz"
 > o
=> ["foo", "bar"]
```

- Or use the `<<` method (the left shift bitwise operator) to append or concatenate:

  ```
 > o << "baz"
=> ["foo", "bar", "baz"]

 > # strings also have this method:
 > "hello" << " world"
=> "hello world"
```

- Use the `shift` and `unshift` methods to implement FIFO (First In, First Out):

  ``` ruby
 > o = ["bar", "baz"]
=> ["bar", "baz"]

 > o.unshift("foo") # add item before the first index position
                    # (prepend)
=> ["foo", "bar", "baz"]
```

- Use the `first` and `last` methods to access the first and last indices:

  ``` ruby
 > o = ["foo", "bar", "baz"]
=> ["foo", "bar", "baz"]

 > o.first # access the first index position
=> "foo"

 > o.last  # access the last index position
=> "baz"
```

- Use the `size` method to get the length of an array:

  ``` ruby
 > o.size
=> 3
```

- Use the `each` method to loop items in an array:

  ```
 > o.each do |item| # item is local to do-end block's scope
?>   puts item
?> end
foo
bar
baz
=> ["foo", "bar", "baz"]

 > o.each { |item| puts item } # or with braces ({})
foo
bar
baz
=> ["foo", "bar", "baz"]

 > item                        # variable item do not exist
                               # outside loop
NameError (undefined local variable or method `item' for main:Object)
```

- Use `(n..n)` to create an array with a range of numbers:

  ``` ruby
 > (1..3).to_a
=> [1, 2, 3]
```

- Use the `sample` method to pick an item randomly in an array:

  ``` ruby
 > [1, 2, 3].sample
=> 2
```

**Notes:**

- Use brackets (`[]`) during assignments
- Use brackets (`[]`) as delimiters on `%i`, `%I`, `%w` and `%W` literals
- Use the `do-end` block to loop multi-lined blocks
- Use braces (`{}`) to loop single-lined blocks

-------------------------------------------------------------------------------

Objects Interacting
-------------------

- Instances can interact with other instances:

  ``` ruby
 > class Cls1
?>   attr_accessor :param
?>
?>   def initialize(param)
?>     @param = param
?>   end
?> end
=> :initialize

 > class Cls2
?>   def initialize
?>     @params = []
?>   end
?>
?>   def add_param(new_param)
?>     @params << new_param
?>   end
?>
?>   def params
?>     @params.each { |param| puts param }
?>   end
?> end
=> :params

 > inst_1 = Cls1.new("arg")
=> #<Cls1:0x000055eed1ae40f0 @param="arg">

 > inst_2 = Cls2.new
=> #<Cls2:0x000055eed169a670 @params=[]>

 > inst_2.add_param(inst_1)
=> [#<Cls1:0x000055eed1ae40f0 @param="arg">]

 > inst_2.params
#<Cls1:0x000055eed1ae40f0>
=> [#<Cls1:0x000055eed1ae40f0 @param="arg">]
```

- Interacting objects do not create new objects but refers to original references:

  ``` ruby
 > inst_1.param = "new arg"
=> "new arg"

 > inst_2.params
#<Cls1:0x000055eed1ae40f0>
=> [#<Cls1:0x000055eed1ae40f0 @param="new arg">]
```

**Note:** This lesson demonstrated encapsulation.

-------------------------------------------------------------------------------

Separate Source Files
---------------------

- Separate classes with its own file:

  ``` shell
$ echo '
class Cls1
end
' > cls_1.rb

$ echo '
class Cls2
end
' > cls_2.rb
```

- Use the `require` or `require_relative` methods to import other Ruby programs:

  ``` ruby
require "http"           # import an external package

require_relative "cls_1" # import a relative file
```

- Use the `__FILE__ == $0` condition to prevent evaluation of code when file is imported:

  ``` shell
$ echo '
if __FILE__ == $0 # or $PROGRAM_NAME
  puts "#{__FILE__} was executed directly from shell."
end
' > cls_1.rb

$ echo '
require_relative "cls_1"
puts "I am just importing cls_1."
' > cls_2.rb

$ ruby cls_1.rb
cls_1.rb was executed directly from shell.

$ ruby cls_2.rb

I am just importing cls_1.
```

**Notes:**

- Naming is similar to variables followed by `.rb` extension
- This lesson demonstrated a program structure

-------------------------------------------------------------------------------

Unit Testing
------------

### RSpec ###

- Install [RSpec](https://rspec.info):

  ``` shell
$ gem install rspec
```

### Source and test files ###

- Create the source file:

  ``` shell
$ echo '
class Cls
end
' > cls.rb
```

- Create the test file:

  ``` shell
$ echo '
' > cls_spec.rb
```

**Note:** Test file name is similar to source file with `_spec` suffix (e.g. `cls_spec.rb`).

### BDD  ###

BDD is higher level than TDD that tests behavior, focusing on the business value:

- Import the source file in the test file:

  ``` ruby
# cls_spec.rb:
require_relative "cls"
```

- Use the `describe` block to define an example group (a collection of tests):

  ``` ruby
# cls_spec.rb:
require_relative "cls"

describe Cls do
end
```

- Use the `context` block to separate tests from different contexts of same state:

  ``` ruby
# cls_spec.rb:
require_relative "cls"

describe Cls do
  context "with default values" do
  end

  context "with specified values" do
  end
end
```

- Use the `it` block to define an example (a test case):

  ``` ruby
# cls_spec.rb:
require_relative "cls"

describe Cls do
  context "with the default value" do
    it "is an empty string"              # a pending test
  end

  context "with a specified value" do
    it "is with the value of \"arg\"" do # an empty test
    end
  end
end
```

- Use the `expect` method to verify a condition is met:

  ``` ruby
# cls_spec.rb:
require_relative "cls"

describe Cls do
  context "with the default value" do
    it "is an empty string"
  end

  context "with a specified value" do
    it "is with the value of \"arg\"" do
      expect(Cls.new("arg").param).to eq("arg")
    end
  end
end
```

- Use the `rspec` command to run the test with the test file as argument:
  <br />**Note:** The first test must be failing test (red).

  ``` shell
$ rspec cls_spec.rb

*F

Pending: (Failures listed here are expected and do not affect your suite's status)

  1) Cls with the default value is an empty string
     # Not yet implemented
     # ./cls_spec.rb:5
...
```

- Use the `-f d` argument to format the output with group and example names:

  ``` shell
$ rspec cls_spec.rb -f d

Cls
  with the default value
    is an empty string (PENDING: Not yet implemented)
  with a specified value
    is with the value of "arg" (FAILED - 1)

Pending: (Failures listed here are expected and do not affect your suite's status)

  1) Cls with the default value is an empty string
     # Not yet implemented
     # ./cls_spec.rb:5
...
```

- Update the source file to make the failing test pass:

  ``` ruby
# cls.rb:
class Cls
  def initialize(param)
    @param = param
  end

  def param
    @param
  end
end
```

- Run the test again:
  <br />**Note:** The next tests must aim to pass the test (green).

  ``` shell
$ rspec cls_spec.rb -f d

Cls
  with the default value
    is an empty string (PENDING: Not yet implemented)
  with a specified value
    is with the value of "arg"

Pending: (Failures listed here are expected and do not affect your suite's status)

  1) Cls with the default value is an empty string
     # Not yet implemented
     # ./cls_spec.rb:5

...
```

- Update the test file and the source file:
  <br />**Note:** The source and test files must be updated after the test passed (refactor).

  - Update the source file:

    ``` ruby
# cls.rb:
class Cls
  attr_reader :param

  def initialize(param)
    @param = param
  end
end
```
  - Update the test file:

    ``` ruby
# cls_spec.rb:
require_relative "cls"

describe Cls do
  context "with the default value" do
    it "is an empty string"
  end

  context "with a specified value" do
    it "is with the value of \"arg\"" do
      param = "arg"
      instance = Cls.new(param)
      expect(instance.param).to eq(param)
    end
  end
end
```

- Run the test again to make sure nothing broke after refactoring:

  ``` shell
$ rspec cls_spec.rb -f d

Cls
  with the default value
    is an empty string (PENDING: Not yet implemented)
  with a specified value
    is with the value of "arg"

Pending: (Failures listed here are expected and do not affect your suite's status)

  1) Cls with the default value is an empty string
     # Not yet implemented
     # ./cls_spec.rb:5
...
```

- Do the same thing for the pending test:

  1. Test file (`cls_spec.rb`):

     ``` ruby
...
    context "with the default value" do
        it "is an empty string" do
          param = ""
          instance = Cls.new
          expect(instance.param).to eq(param)
        end
    end
```

  2. Source file (`cls.rb`):

     ``` ruby
...
  def initialize(param="")
```

  3. Run test:

     ``` shell
$ spec cls_spec.rb -f d

Cls
  with the default value
    is an empty string
  with a specified value
    is with the value of "arg"

Finished in 0.00155 seconds (files took 0.0818 seconds to load)
2 examples, 0 failures
```

- Use the `before` hook block to setup reusable code:
  <br />**Note:** `before` uses `:each` by default (e.g. `before(:each)`).

  ``` ruby
# cls_spec.rb:
require_relative "cls"

describe Cls do
  before do
    @instance = Cls.new
  end

  context "with the default value" do
    before do
      @param = ""
    end

    it "is an empty string" do
      expect(@instance.param).to eq(@param)
    end
  end

  context "with a specified value" do
    before do
      @param = "arg"
      @instance = Cls.new(@param)
    end

    it "is with the value of \"arg\"" do # an empty test
      expect(@instance.param).to eq(@param)
    end
  end
end
```

**Note:** Test and source files must only refactor the relevant codes it used for testing.

-------------------------------------------------------------------------------

Conditionals and TDD
--------------------

### Conditionals ###

- Use the `if` conditional expression to execute code if the condition is truthy:

  ``` ruby
 > x = 1

 > if x == 1
?>   "#{x} == 1"
?> elsif x < 1
?>   "#{x} < 1"
?> else
?>   "#{x} is unknown"
?> end
=> "1 == 1"

 > # Or in one-line for single condition:
 > "#{x} == 1" if x == 1
=> "1 == 1"
```

- Use the `unless` conditional expression to execute code if the condition is falsy:

  ``` ruby
 > x = 0

 > unless x == 1
?>   "#{x} is unknown"
?> else
?>   "#{x} == 1"
?> end
=> "0 is unknown"

 > # Or in one-line for single condition:
 > "#{x} is unknown" unless x == 1
=> "0 is unknown"
```

- Use the ternary operation (`? :`) for one-line `if-else` condition:

  ``` ruby
 > x = 1

 > x == 1 ? "#{x} == 1" : "#{x} is unknown"
=> "1 == 1"
```

- Use the `case` conditional expression for multiple conditions:

  ``` ruby
 > x = 1

# case without expression:
 > case
 > when x == 1
?>   "#{x} == 1"
?> when x < 1
?>   "#{x} < 1"
?> else
?>   "#{x} is unknown"
?> end
=> "1 == 1"

# case with expression:
 > case x
 > when 1
?>   "#{x} == 1"
?> when -1, 0
?>   "#{x} < 1"
?> when 2..10
?>   "#{x}..10"
?> else
?>   "#{x} is unknown"
?> end
=> "1 == 1"
```

**Notes:**

- The `then` keyword is optional
- `false` and `nil` are the only falsy values, the rest are truthy
- This lesson demonstrated branching

### TDD ###

1. Create a test that fails (red):

   - Create the test:

     ``` ruby
# cls_spec.rb:
require_relative "cls"

describe Cls do
  context "with default #param" do
    it "is an empty string" do
      expect(Cls.new.param).to eq("")
    end
  end
end
```
  - Run the test:
  <br />**Note:** The dot (`.`) will recursively execute all the test files.

  ``` shell
$ rspec . -f d

Cls
  with default #param
    is an empty string (FAILED - 1)

Failures:

  1) Cls with default #param is an empty string
     Failure/Error: expect(Cls.new.param).to eq("")

       expected: ""
            got: nil

       (compared using ==)
     # ./cls_spec.rb:7:in `block (3 levels) in <top (required)>'

Finished in 0.01628 seconds (files took 0.0589 seconds to load)
1 example, 1 failure

Failed examples:

rspec ./cls_spec.rb:6 # Cls with default #param is an empty string
```

2. Make the test pass (green):

   - Create the source:

     ``` ruby
# cls.rb:
class Cls
  def initialize(param="")
    @param = param
  end

  def param
    @param
  end
end
```

   - Run the test:

     ``` shell
$ rspec . -f d

Cls
  with default #param
    is an empty string

Finished in 0.00112 seconds (files took 0.07088 seconds to load)
1 example, 0 failures
```

3. Refactor the files (refactor):

   - Refactor the test file:

     ``` ruby
# cls_spec.rb:
require_relative "cls"

describe Cls do
  before do
    @param = ""
    @instance = Cls.new
  end

  context "with default #param" do
    it "is an empty string" do
      expect(@instance.param).to eq(@param)
    end
  end
end
```
   - Refactor the source file:

     ``` ruby
# cls.rb:
class Cls
  attr_accessor :param

  def initialize(param="")
    @param = param
  end
end
```
   - Run the test to make sure the test still works as expected:

     ``` shell
$ rspec . -f d

Cls
  with default #param
    is an empty string

Finished in 0.00105 seconds (files took 0.06669 seconds to load)
1 example, 0 failures
```

### Stubbing ###

- Use the `stub` method to return a pre-defined value of a yet-to-be-developed code:

  - The test file:

    ``` ruby
# cls_spec.rb:
require_relative "cls"

describe Cls do
  context "with default #param" do
    it "is an empty string" do
      allow_any_instance_of(Cls).to receive(:param).and_return("")
      expect(Cls.new.param).to eq("")
    end
  end
end
```

  - The source file:

    ``` ruby
# cls.rb:
class Cls
  def param
  end
end
```

  - Run the test:

    ``` shell
$ rspec . -f d

Cls
  with default #param
    is an empty string

Finished in 0.00711 seconds (files took 0.08121 seconds to load)
1 example, 0 failures
```

Let's continue to the third part: [Ruby Programming: Part 3](ruby-programming-part-3).
