{:title       "Ruby Programming: Part 4"
 :layout      :post
 :summary     "
              This document is the continuation of Ruby Programming: Part 3 and will be about
              1) custom iterators,
              2) input and output,
              3) inheritance,
              4) mixins
              and 5) distribution.
              "
 :excerpt     "This is the summary for page 4 of 4 of The Pragmatic Studio's 23-Day Course Plan of the Ruby Programming course."
 :description "Page 4 of 4 summary of The Pragmatic Studio's 23-Day Course Plan of the Ruby Programming course."
 :date        "2019-09-08"
 :tags        ["research"
               "programming-language"
               "ruby"]}

-------------------------------------------------------------------------------

**Note:** This is the continuation of [Ruby Programming: Part 3](ruby-programming-part-3).

This document will be the summary of page 4, the last page, from the course outline, [23-Day Course Plan](https://pragmaticstudio.s3.amazonaws.com/courses/ruby/PragStudioRubyPlan.pdf) of [The Pragmatic Studio](https://pragmaticstudio.com)'s [Ruby Programming](https://pragmaticstudio.com/courses/ruby) course.

-------------------------------------------------------------------------------

Custom Iterators
----------------

- Use the keyword `yield` to call a block:

  ``` ruby
 > def fn
?>   yield
?> end
=> :fn

 > fn { "hello world" }
=> "hello world"
```

- `yield` requires a given block:

  ``` ruby
 > fn
LocalJumpError (no block given (yield))
```

- Use the `block_given?` method to check if a block is given:

  ``` ruby
 > def fn
?>   if block_given?
?>     yield
?>   else
?>     "no block given"
?>  end
?> end
=> :fn

 > fn { "hello world" }
=> "hello world"

 > fn
=> "no block given"
```

- `yield` can have zero or more parameters:

  ``` ruby
 > def fn(param_1, param_2)
?>   yield(param_1, param_2)
?> end
=> :fn

 > fn("hello", "world") { |param_1, param_2| "#{param_1} #{param_2}" }
=> "hello world"
```

-------------------------------------------------------------------------------

Input / Output
--------------

### I/O in shell ###

- Use the `gets` method to return the next line from the standard input:

  ``` ruby
 > gets
1
=> "1\n"
```

- Use the `chomp` method to remove trailing new lines:

  ``` ruby
 > gets.chomp
1
=> "1"
```

- Assign the returned line from the `gets` method for re-use:

  ``` ruby
 > x = gets.chomp
1
=> "1"

 > puts "x is #{x}"
x is 1
=> nil
```

- Use the `ARGV` Array to read arguments passed from the shell:

  1. Create the program file:

  ``` shell
$ echo '
puts "I have #{ARGV.size} arguments."
' > program.rb
```

  2. Run the program file with arguments:

  ``` shell
$ ruby program.rb foo bar baz
I have 3 arguments.
```

### I/O in file ###

**Create a dummy file:**

``` shell
$ echo '
hello,
world
' > file.ext
```

- Use the `File` class with the `open` method to open a file:

  ``` ruby
 > File.open("file.ext")
=> #<File:file.ext>
```

- Use the `close` method to close an opened file that was assigned to a variable:

  ``` ruby
 > f = File.open("file.ext")
=> #<File:file.ext>

 > f.close
=> nil

 > f
=> #<File:file.ext (closed)>
```

- Use a block to omit assignment and manually closing a file:

  ``` ruby
 > File.open("file.ext") do |file|
?> end
=> nil
```

- Use the `each_line` method to iterate a file object:

  ``` ruby
 > File.open("file.ext") do |file|
?>   f.each_line do |line|
?>     puts line
?>   end
?> end

hello,
world

=> #<File:file.ext (closed)>
```

- Use the `readlines` and `each` methods to directly iterate a file object:

  ``` ruby
 > File.readlines("file.ext").each do |line|
?>   puts line
?> end

hello,
world

=> ["\n", "hello,\n", "world\n", "\n"]
```

- Use the `puts` method of the file object with `"w"` mode to write to a file:

  ``` ruby
 > File.open("file.ext", "w") do |file|
?>   file.puts("foo bar baz")
?> end
=> nil
```

- Use the `"w+"` mode to read an opened file object in write-mode:

  ``` ruby
 > # Using just "w" as mode prohibits reading:
 > f = File.open("file.ext", "w")
=> #<File:file.ext>
 > f.readlines
IOError (not opened for reading)

 > # Using "w+" as mode allows reading:
 > f = File.open("file.ext", "w+")
=> #<File:file.ext>
 > f.readlines
=> []
```

-------------------------------------------------------------------------------

Inheritance
-----------

- Use the `<` notation to subclass (the child class) from a parent class:

  ``` ruby
 > class Cls1
?> end
=> nil

 > class Cls2 < Cls1
?> end
=> nil
```

- The child class inherits all the methods and attributes of the parent class:

  ``` ruby
 > class Cls1
?>   attr_accessor :param
?>
?>   def initialize(param)
?>     @param = param
?>   end
?>
?>   def to_s
?>     "#<class=\"#{self.class.name}\" @param=\"#{@param}\">"
?>   end
?> end
=> :to_s

 > class Cls2 < Cls1
?> end
=> nil

 > inst = Cls2.new("arg")
=> #<Cls2:0x000055eed169a670 @param="arg">
 > inst.param
=> "arg"
 > inst.to_s
=> "#<class=\"Cls2\" @param=\"arg\">"
```

- The child class can override the methods of the parent class:

  ``` ruby
 > class Cls1
?>   def fn
?>     "foo"
?>   end
=> :fn

 > class Cls2 < Cls1
?>   def fn
?>     "bar"
?>   end
=> :fn

 > inst = Cls2.new
=> #<Cls2:0x000055eed169a670>
 > inst.fn
=> "bar"
```

- Use the `super` method to initialize the parent class' attributes:

  ``` ruby
 > Class Cls1
?>   attr_accessor :p_param
?>
?>   def initialize(p_param)
?>     @p_param = p_param
?>   end
?> end
=> :initialize

 > Class Cls2 < Cls1
?>   attr_accessor :p_param
?>
?>   def initialize(p_param, c_param)
?>     super(p_param)
?>     @c_param = c_param
?>   end
?> end
=> :initialize

 > inst = Cls2.new("foo", "bar")
=> #<Cls2:0x000055eed169a670 @p_param="foo", @c_param="bar">
 > inst.p_param
=> "foo"
 > inst.c_param
=> "bar"
```

- Use the `super` method to call the method of the parent class:

  ``` ruby
 > class Cls1
?>   def fn
?>     "hello"
?>   end
?> end
=> :fn

 > class Cls2 < Cls1
?>   def fn
?>     super
?>   end
?> end
=> :fn

 > inst = Cls1.new
=> #<Cls2:0x000055eed169a670>
 > inst.fn
=> "hello"
```

- An example of polymorphism thru inheritance:
  <br />
  **Note:** In this example, `Man` and `Woman` are many (poly) forms (morph) of `Human`.

  ``` ruby
 > class Human
?>   def mortal?
?>     true
?>  end
=> :mortal?

 > class Man < Human
?>   def fn
?>     "A man leads, provides and protects"
?>   end
?> end
=> :fn

 > class Woman < Human
?>   def fn
?>     "A woman supports, manages and nurtures"
?>   end
?> end
=> :fn
```

- Use the `superclass` method to get the parent of a class

  ``` ruby
 > Man.superclass
=> Human

 > Woman.superclass
=> Human
```

- Use the `ancestors` method to get the class hierarchy of a class

  ``` ruby
 > Man.ancestors
=> [Man, Human, Object, Kernel, BasicObject]

 > Woman.ancestors
=> [Woman, Human, Object, Kernel, BasicObject]
```

- Use the `is_a?` or `kind_of?` to check if an object belongs to a class:
  <br />
  **Note:** `is_a?` and `kind_of?` methods point the the same `C` function ([`rb_obj_is_kind_of`](https://github.com/ruby/ruby/blob/trunk/object.c#L471https://github.com/ruby/ruby/blob/trunk/object.c#L4601)).

  ``` ruby
 > class Cls1
?> end
=> nil

 > class Cls2 < Cls1
?> end
=> nil

 > o = Cls2.new
=> #<Cls2:0x000055eed169a670>
 > o.is_a? Cls2   # direct class (o.class)
=> true
 > o.is_a? Cls1   # parent class (o.class.superclass)
=> true
 > o.is_a? Object # grand parent class (o.class.superclass.superclass)
=> true
```

**Notes:**

- Inheritance is the basic form of polymorphism (different classes sharing a superclass)
- Polymorphism is sending the same message to different objects to get different results

-------------------------------------------------------------------------------

Mixins
------

- Use the `include` method to mixin a module:

  ``` ruby
 > module Mdl
?>   def fn
?>     "mixin"
?>   end
?> end
=> :fn

 > class Cls
?>   include Mdl
?> end
=> Cls

 > inst = Cls.new
=> #<Cls:0x0000564dda0a9ff0>
 > inst.fn
=> "mixin"
```

- A mixin sits between the class it is mixed in and the class' superclass:

  ``` ruby
 > module Mdl
?> end
=> nil

 > class Cls
?>   include Mdl
?> end
=> Cls

 > Cls.ancestors  # Mdl is between Cls and Object
=> [Cls, Mdl, Object, Kernel, BasicObject]

 > Cls.superclass # but it is not Cls' superclass
=> Object
```

- A module can access a class' attributes where it is mixed in:

  ``` ruby
 > module Mdl
?>   def fn
?>     "hello #{@param}"
?>   end
?> end
=> :fn

 > class Cls
?>   attr_accessor :param
?>
?>   def initialize(param)
?>     @param = param
?>   end
?> end
=> :initialize

 > inst = Cls.new("world")
=> #<Cls:0x0000564dda0a9ff0 @param="world">
 > inst.fn
=> "hello world"
```

- Although it's a much better practice to use attributes and methods directly in modules:

  ``` ruby
 > module Mdl
?>   def fn
?>     "hello #{self.param}"
?>   end
?> end
=> :fn

 > class Cls
?>   attr_accessor :param
?>
?>   def initialize(param)
?>     @param = param
?>   end
?> end
=> :initialize

 > inst = Cls.new("world")
=> #<Cls:0x0000564dda0a9ff0 @param="world">
 > inst.fn
=> "hello world"
```

**Notes:**

- Mixins are used to share code that is not related to any class hierarchy
- Ruby don't support multiple inheritance but uses mixins as controlled multiple-inheritance-like
- While inheritance is for modeling class relationships, think of mixins for sharing class behaviors

-------------------------------------------------------------------------------

Distribution
------------

### RubyGems' bundler ###

1. Install `bundler`:

   ``` shell
$ gem install bundler
```

2. Create RubyGems structure:

   ``` shell
$ bundle gem <project>
```

3. Then modify `<project>/<project>.gemspec` file

### RubyGems structure ###

``` shell
<project>/
├── README.md         # usage instructions
├── LICENSE.txt       # terms of use
├── <project>.gemspec # project details
├── Gemfile           # gem dependencies
├── Rakefile          # Ruby's Makefile (run via rake)
├── bin/              # shell executables
│   ├── console
│   └── setup
├── lib/              # project source files
│   ├── <project>/
│   │   └── version.rb
│   └── <project>.rb
├── spec/             # project test files
│   ├── <project>_spec.rb
│   └── spec_helper.rb
├── .rspec            # RSpec configuration file
└── .travis.yml       # Travis CI configuration file
```

### Publishing a gem ###

1. [Sign up](https://rubygems.org/sign_up) on [RubyGems.org](https://rubygems.org)

2. You will receive an e-mail confirmation (click `VERIFY` to confirm to be logged in)

3. Build the project to make a gem:

   ``` shell
$ gem build <project>.gemspec
  Successfully built RubyGem
  Name: <project>
  Version: <version>
  File: <project>-<version>.gem
```

4. Publish the gem:

   ``` shell
$ gem push <project>-<version>.gem
Pushing gem to https://rubygems.org...
Successfully registered gem: <project> (<version>)
```

### Reviewing a gem ###

1. Search the gem:

   ``` shell
$ gem search -r <project>

*** REMOTE GEMS ***

<project> (<version>)
```
   **Note:** `-r` restricts operation to the REMOTE domain

2. Install the gem:

   ``` shell
$ gem install <project>
Successfully installed <project>-<version>
Parsing documentation for <project>-<version>
Installing ri documentation for <project>-<version>
Done installing documentation for <project> after 0 seconds
1 gem installed
```

3. Check if gem is installed:

   ``` shell
$ gem list <project> -d

*** LOCAL GEMS ***

<project> (<version>)
    Author: <author>
    Homepage: <homepage>
    License: <license>
    Installed at: <path>

    <summary>
```
   **Note:** `-d` displays the detailed information of the gem

4. Uninstall the gem:

   ``` shell
$ gem uninstall <project>
Successfully uninstalled <project>-<version>
```

**Congratulations!** We've finally finished the course and learned enough `Ruby` :)
