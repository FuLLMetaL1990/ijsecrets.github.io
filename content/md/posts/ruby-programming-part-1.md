{:title       "Ruby Programming: Part 1"
 :layout      :post
 :summary     "
              Ruby is a dynamically typed, object-oriented and general-purpose programming language which is highly influenced by Lisp, Smalltalk and Perl;
              two of which I have a high regard of (Lisp and Smalltalk).
              And this document will be about
              1) introduction and setup,
              2) running Ruby,
              3) numbers and strings,
              4) variables and objects,
              5) self,
              6) methods
              and 7) classes.
              "
 :excerpt     "This is the summary for page 1 of 4 of The Pragmatic Studio's 23-Day Course Plan of the Ruby Programming course."
 :description "Page 1 of 4 summary of The Pragmatic Studio's 23-Day Course Plan of the Ruby Programming course."
 :date        "2019-08-18"
 :tags        ["research"
               "programming-language"
               "ruby"]}

-------------------------------------------------------------------------------

I started to take the plunge to learn the [Ruby on Rails](https://rubyonrails.org) web-application framework through [The Pragmatic Studio](https://pragmaticstudio.com)'s [Ruby on Rails 6](https://pragmaticstudio.com/courses/rails) course.
The plan is to use it in the future to build web application projects.

However, it was strongly advised to first learn the underlying programming language being used, that is, the [Ruby](https://www.ruby-lang.org) programming language &mdash; hence, I started with that preliminary course instead: the [Ruby Programming](https://pragmaticstudio.com/courses/ruby) course.

This document will be the summary of page 1 from the course outline, [23-Day Course Plan](https://pragmaticstudio.s3.amazonaws.com/courses/ruby/PragStudioRubyPlan.pdf).
And although somewhat outdated, I find that having the [Programming Ruby](https://pragprog.com/book/ruby4/programming-ruby-1-9-2-0) (a.k.a. The Pickaxe Book) to be really handy to get more details and deeper understanding after completion of each lessons.

It's also useful to often sneak on their [summary of the core concepts](https://pragmaticstudio.s3.amazonaws.com/courses/ruby/PragStudioRubySummary.pdf) to re-iterate gained knowledge.

-------------------------------------------------------------------------------

Introduction and Setup
----------------------

### Install RVM ###

**Note:** [RVM](https://rvm.io 'Ruby Version Manager') is a CLI tool to manage multiple Ruby environments.

1. Install [GPG](https://gnupg.org 'GNU Privacy Guard') keys:

   ```shell
$ gpg2 --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 \
                   7D2BAF1CF37B13E2069D6956105BD0E739499BDB
```

2. Install `rvm`:

   ``` shell
$ curl -sSL https://get.rvm.io | bash -s stable
```

3. Source `rvm`:

   ``` shell
$ echo "
source ~/.rvm/scripts/rvm
" >> ~/.bashrc
. ~/.bashrc
```

### Install Ruby ###

1. Install a version (**note:** not specifying a version will install the latest stable version, e.g. `ruby-2.6.3`):

   ``` shell
$ rvm install ruby
```

2. Build documentation:

   ``` shell
$ rvm docs generate-ri
```

3. Switch interpreter:

   ``` shell
$ rvm use ruby
```

### Install Ruby layer  ###

**Note:** The [Ruby layer](http://develop.spacemacs.org/layers/+lang/ruby/README.html) provides support for the Ruby programming language (**optional** for non-[Spacemacs](http://spacemacs.org) users).

Open [emacs](https://www.gnu.org/software/emacs/emacs.html), then do:

1. Open `.spacemacs` file:

   ``` shell
SPC f e d
```

2. Update `dotspacemacs-configuration-layers`:

   ``` emacs-lisp
(ruby :variables
      ruby-version-manager 'rvm
      ruby-test-runner 'rspec)
```

3. Sync `.spacemacs` changes:

   ``` shell
SPC f e R
```

-------------------------------------------------------------------------------

Running Ruby
------------

### irb ###

**Note:** `irb` is Ruby's REPL.

``` shell
$ irb
 > "Ruby is fun!"
=> "Ruby is fun!"
 > exit # to exit irb
```

### Executables ###

1. Write a Ruby source code (e.g. `hello_ruby.rb`):

   ``` shell
$ echo '
puts "Ruby is fun!"
' > hello_ruby.rb
```

2. Execute the file:

   ``` shell
$ ruby hello_ruby.rb
Ruby is fun!
```

### ri ###

**Note:** `ri` (`Ruby Index`) is a CLI tool to access Ruby's API reference on the console

- Show documentation of a class or module:

  ``` shell
$ ri String # or a class from a module: Module::Class
= String < Object
...
```

- Show documentation of a method from a specific class:

  ``` shell
$ ri String.reverse # or Class::method
                    # or Class#method
= String.reverse
...
```

- Show documentation of a method from any class:

  ``` shell
$ ri reverse
= .reverse
...
```

- Show all files of a [gem](https://rubygems.org/):

  ``` shell
$ ri http:
= Pages in gem http-4.1.1
...
```

- Show a specific file from a gem:

  ``` shell
 $ ri http:README
 = Pages in gem http-4.1.1
...
```

-------------------------------------------------------------------------------

Numbers and Strings
-------------------

**Notes:**

- Numbers and strings are some of Ruby's basic data types
- There are no primitive data types in Ruby

### Numbers ###

- `Integer`:

   ``` ruby
 > 1
=> 1
```

- `Float`:

  ``` ruby
 > 1.0
=> 1.0
```

- Numbers are objects:

  ``` ruby
 > 1.class
=> Integer

 > 1.0.class
=> Float
```

- Numbers, being objects, have methods:

  ``` ruby
 > 1.+(1)   # 1 + 1
=> 2

 > 1.0.+(1) # 1.0 + 1
=> 2
```

- Numbers are subclass of the `Numeric` class:

  ``` ruby
 > 1.class.superclass
=> Numeric

 > 1.0.class.superclass
=> Numeric
```

- `Numeric` is a subclass of `Object` (which is the root of all Ruby objects):

  ``` ruby
 > Numeric.superclass
=> Object
```

- `Integer` to `Integer` operation evaluates to an `Integer`:

  ``` ruby
 > 1 + 1
=> 2
```

- `Integer` to `Float` operation (or vise versa) evaluates to `Float`:

  ``` ruby
 > 1 + 1.0
=> 2.0

 > 1.0 + 1
=> 2.0
```

- Use the `to_i` or `to_f` methods to perform type conversion on objects to a number:

  ``` ruby
 > "1".to_i # string to integer
=> 1

 > "1".to_f # string to float
=> 1.0
```

### Strings ###

- A pair of quotes evaluates to strings:

  ``` ruby
 > '' # single quotes
=> ""

 > "" # double quotes
=> ""
```

- Strings are also objects:

  ``` ruby
 > ''.class
=> String

 > "".class
=> String
```

- Like numbers, being objects, strings have methods:

  ``` ruby
 > 'hello'.reverse
 => "olleh"

 > "hello".reverse
=> "olleh"
```

- Strings are direct subclass of the `Object` class:

  ``` ruby
 > ''.class.superclass
=> Object

 > "".class.superclass
=> Object
```

- Use the plus sign operator (`+`) to perform string concatenation:

  ``` ruby
 > 'hello'.+(' world') # 'hello' + ' world'
=> "hello world"

 > "hello".+(" world") # "hello" + " world"
=> "hello world"
```

- Use the `puts` builtin methods to print strings:

  ``` ruby
 > puts 'hello'
=> "hello"

 > puts "hello"
=> "hello"
```

- Use the `to_s` method to perform type conversion on objects to a string:

  ``` ruby
 > 1.to_s
=> "1"
```

- Single quotes evalute values as raw data:

  ``` ruby
 > o = 'world'
=> "world"
 > 'hello\s#{o}'
=> "hello\\s\#{o}"
```

- Double quotes evaluates escape sequence and performs string interpolation:

  ``` ruby
 > o = "world"
=> "world"
 > "hello\s#{o}"
=> "hello world"
```

- Or use `%q` or `%Q` (or `%`) wrapped in pair of delimiters:

  ``` ruby
 > %q(hello\s#{o}) # same as single quotes which
                   # evaluates values as raw data
                   # () are the delimiters
=> "hello\\s\#{o}"

 > %Q(hello\s#{o}) # same as double quotes which
                   # evaluates escape sequence
                   # and performs string interpolation
                   # () are the delimiters
=> "hello world"

 > %(hello\s#{o})  # same as %Q
=> "hello world"   # () are the delimiters
```

- Use a backslash to escape quotes:

  ``` ruby
 > '\''
=> "'"

 > "\""
=> "\""
```

**Notes:**

- Strings are mutable
- Be consistent in using quotes, pick one and stick with it (e.g. double quotes)
- Use parenthesis (`()`) as delimiters on `%q`, `%Q` or `%` literals

-------------------------------------------------------------------------------

Variables and Objects
---------------------

### Variables ###

- Use the equal sign operator (`=`) to perform assignments:

  ``` ruby
 > o = "hello" # point variable o to object "hello"
=> "hello"

 > oo = o      # point variable oo to the same object
=> "hello"
```

- Use the `object_id` method to show the pointer location in memory of the object:

  ``` ruby
 > o.object_id
=> 47188648276680

 > oo.object_id # same pointer location for both objects
=> 47188648276680
```

- Assignment to a variable is just a reference to an object not to that object itself:

  ``` ruby
 > o[0] = "j"     # change the first index of the object
=> "j"

 > o              # variable o is also modified
=> "jello"
 > oo             # so as variable oo
=> "jello"

 > o.object_id    # also true on their pointer location
=> 47259573976800
 > oo.object_id   # still similar as variable o
=> 47259573976800

 > o = "goodbye"  # but completely changing variable o
=> "goodbye"
 > o.object_id
=> 47259574017760

 > oo             # does not update variable oo
=> "jello"
 > oo.object_id   # each now points to different objects
=> 47259573976800
```

**Notes:**

- Names, must begin with lowercase letters or underscores (`snake_case`)
- Use meaningful names because naming is [hard](https://martinfowler.com/bliki/TwoHardThings.html "TwoHardThings")

### Objects ###

- An object is a combination of state and behavior:

  ``` ruby
 > o = "hello" # store a state
=> "hello"

 > o.reverse   # perform a behavior
=> "olleh"
```

- An object performs message passing, not function calls:

  ``` ruby
 > o.reverse         # appears to be invoking the
                     # reverse method on object o
=> "olleh"

 > o.send("reverse") # but not really a function call,
                     # but sending the message "reverse"
                     # to the object o
=> "olleh"
```

- The object is the receiver and the message is the method and its parameters:

  ``` ruby
 > o.reverse        # a message without parameters
                    # (send the message "reverse"
                    #  to the receiver "o")
=> "olleh"

 > o.center(10)     # a message with a single parameter
                    # (send the message "center"
                    #  with a value of "10"
                    #  to the receiver "o")
=> "  hello   "

 > o.ljust(10, "-") # a message with multiple parameters
                    # (send the message "ljust"
                    #  with the values "10" and "-"
                    #  to the receiver "o")
=> "hello-----"
```

-------------------------------------------------------------------------------

Self
----

- `self` is an implicit variable that refers to the object (`main`) currently in context:

  ``` ruby
 > self
=> main
```

- `main` is an object at the top-level context and is an instance of `Object`:

  ``` ruby
 > self.class
=> Object
```

- Methods defined in `main` can send messages without specifying a receiver:

  ``` ruby
 > puts
=> nil
```

- But methods in `main` are private methods that can't have explicit receivers:

  ``` ruby
 > self.puts
NoMethodError (private method `puts' called for main:Object)
```

-------------------------------------------------------------------------------

Methods
-------

- Define a method with the `def` keyword:

  ``` ruby
 > def fn
?> end
=> :fn
```

- Execute the method with its name:

  ``` ruby
 > fn
=> nil
```

- Ruby implicitly returns the last evaluated expression:

  ``` ruby
 > def fn
?>   1 + 1
?>   "hello"
?> end

 > fn
=> "hello"
```

- Include a single parameter to a method after the name:

  ``` ruby
 > def fn(param)
?>   "hello #{param}"
?> end
=> :fn

 > fn("world")
=> "hello world"
```

- Include multiple parameters to a method with a comma (`,`):

  ``` ruby
 > def fn(param_1, param_2)
?>   "#{param_1} #{param_2}"
?> end
=> :fn

 > fn("hello", "world")
=> "hello world"
```

- Specify a default value to a method parameter with the equal sign operator (`=`):

  ``` ruby
 > def fn(param_1, param_2="world")
?>   "#{param_1} #{param_2}"
?> end
=> :fn

 > fn("hello")
=> "hello world"
```

**Notes:**

- Naming is similar to variables
- Omit parenthesis (`()`) on logging (`puts`) and debugging (`p`) methods
- Use parenthesis (`()`) on methods with parameters
- Omit parenthesis (`()`) on methods without a parameter
- Names ending with a question mark (`?`) are predicate methods (returns boolean)
- Names ending with an exclamation mark (`!`) are destructive methods (causes side effects)
- Parameters are bound within their scope
- Use them to reduce duplicate code by applying the DRY  principle (Don't Repeat Yourself)
- Define them to do one thing and do it well (Unix Philosopy)


Classes
-------

- Create a class with the `class` keyword:

  ``` ruby
 > class Cls
?> end
=> :cls
```

- Unlike variables and methods, class names must begin with an uppercase letter:

  ``` ruby
 > class cls
?> end
=> SyntaxError ((irb):15: class/module name must be CONSTANT)
...se _; rescue _.class; class cls

 > class Cls
?> end
=> nil
```

- Use the `new` method to create an instance of a class:

  ``` ruby
 > inst = Cls.new # instantiation
=> #<Cls:0x0000564dda0a9ff0>
```

- Class instances are their own kind of objects:

  ``` ruby
 > inst.class
=> Cls
```

- Use the `is_a?` method to check if an instance belongs to a class:

  ``` ruby
 > inst.is_a? Cls
=> true
```

- Use the `instance_of?` method to check if an object is an instance of a class:

  ``` ruby
 > inst.instance_of? Cls
=> true
```

- Initialize attributes with the `initialize` method (the constructor method):

  ``` ruby
 > class Cls
?>   def initialize(param)
?>   end
?> end
=> :initialize

 > inst = Cls.new("arg") # the new method automatically
                         # invokes the initialize method
                         # when creating an instance
=> #<Cls:0x0000564dda0a9ff0>
```

- Store instance parameters with instance variables:

  ``` ruby
 > class Cls
?>   def initialize(param)
?>     @param = param # param evaporates after the initialize
?>                    # method returns and @param persists
?>                    # throughout the life of the instance
?>                    # to store and track its value
?>   end
?> end
=> :initialize
```

- Access and modify instance variables with instance methods:

  ``` ruby
 > class Cls
?>   def initialize(param)
?>     @param = param
?>   end
?>
?>   def param
?>     @param  # instance method can only access instance
?>             # variables (@param) and not local variables
?>             # (param, which evaporates)
?>   end
=> :get_param

 > inst = Cls.new("arg")
=> #<Cls:0x0000564dda0a9ff0 @param="arg">
 > inst.param
=> "arg"
```

- We can override the `to_s` method of a class to customize logging:

  ``` ruby
 > class Cls
?>   def initialize(param)
?>     @param = param
?>   end
?>
?>   def to_s
?>     "#<class=\"#{self.class.name}\" @param=\"#{@param}\">"
?>   end
?> end
=> :to_s

 > inst = Cls.new("arg")
=> #<Cls:0x0000564dda0a9ff0 @param="arg">
 > inst.to_s
=> "#<class=\"Cls\" @param=\"arg\">"

 > # or use the puts method which invokes the to_s method:
 > puts inst
#<class="Cls" @param="arg">
=> nil
```

- Use the `inspect` method to print an instance with its state for debugging:

  ``` ruby
 > inst.inspect
=> "#<Cls:0x0000564dda0a9ff0 @param=\"arg\">"

 > # or use the p method which invokes the inspect method:
 > p inst
=> #<Cls:0x0000564dda0a9ff0 @param="arg">
```

**Notes:**

- Names must begin with an uppercase letter (`PascalCase`)
- Classes are like factories or blueprints that is used to instantiate objects
- Classes have state (instance variables) and behavior (instance methods)
- State makes the instances unique and behavior makes them similar
- Tell the objects what to do but don't ask them about their state ([tell, don't ask](https://pragprog.com/articles/tell-dont-ask))

-------------------------------------------------------------------------------

Let's continue to the second part: [Ruby Programming: Part 2](ruby-programming-part-2).
