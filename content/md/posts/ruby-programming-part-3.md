{:title       "Ruby Programming: Part 3"
 :layout      :post
 :summary     "
              This document is the continuation of Ruby Programming: Part 2 and will be about
              1) modules,
              2) blocks,
              3) symbols and structs
              and 4) hashes.
              "
 :excerpt     "This is the summary for page 3 of 4 of The Pragmatic Studio's 23-Day Course Plan of the Ruby Programming course."
 :description "Page 3 of 4 summary of The Pragmatic Studio's 23-Day Course Plan of the Ruby Programming course."
 :date        "2019-09-01"
 :tags        ["research"
               "programming-language"
               "ruby"]}

-------------------------------------------------------------------------------

**Note:** This is the continuation of [Ruby Programming: Part 2](ruby-programming-part-2).

This document will be the summary of page 3 from the course outline, [23-Day Course Plan](https://pragmaticstudio.s3.amazonaws.com/courses/ruby/PragStudioRubyPlan.pdf) of [The Pragmatic Studio](https://pragmaticstudio.com)'s [Ruby Programming](https://pragmaticstudio.com/courses/ruby) course.

-------------------------------------------------------------------------------

Modules
-------

- Use the `module` keyword to create a module:

  ``` ruby
 > module Mdl
?> end
=> nil
```

- Modules, like classes, can hold methods and constants:

  ``` ruby
 > module Mdl
?>   CONST = 1
?>
?>   def show_const
?>     CONST
?>   end
?> end
=> :show_const
```

- Use the scope operator (`::`) to access its constants:

  ``` ruby
 > Mdl::CONST
=> 1
```

- Modules cannot be instantiated and does not have the `new` method:

  ``` ruby
 > Mdl.new
NoMethodError (undefined method `new' for Mdl:Module)
```

- Module methods are also by default, private:

  ``` ruby
 > Mdl.show_const
NoMethodError (undefined method `show_const' for Mdl:Module)
```

- Prefix methods with `self` to make them accessible:

  ``` ruby
 > module Mdl
?>   CONST = 1
?>
?>   def self.show_const
?>     CONST
?>   end
?> end
=> :show_const_with_self

 > Mdl.show_const
=> 1
```

-------------------------------------------------------------------------------

Blocks
------

### Single and Multi-line ###

- Blocks are codes between braces (`{}`) or `do-end`:

  ``` ruby
{ puts "foo" } # single-line block

do             # multi-line block
  puts "foo"
end
```

- Blocks cannot be executed by themselves:

  ``` ruby
 > # single-line:
 > { puts "foo" }
(irb):9: syntax error, unexpected '}', expecting end
... rescue _.class; { puts "foo" }
...                              ^

 > # multi-line:
 > do
?>   puts "foo"
?> end
(irb):14: syntax error, unexpected end, expecting end-of-input
; end
  ^~~
```

- Blocks must be associated with a method:

  ```
 > # single-line:
 > 1.times { puts "foo" }
foo
=> 1

 > # multi-line:
 > 1.times do
?>   puts "foo"
?> end
```

- Use the `yield` keyword to call the blocks explicitly:

  ``` ruby
 > def fn
?>   puts "foo"
?>   yield
?>   puts "bar"
?> end
=> :fn

 > # single-line:
 > fn { puts "block" }
foo
block
bar
=> nil

 > # multi-line:
 > fn do
?>   puts "block"
?> end
foo
block
bar
=> nil
```

- Use vertical bars (`|`) to include parameters within blocks:

  ``` ruby
 > def fn param
?>   yield(param)
?> end
=> :fn

 > # for single-line:
 > fn("arg") { |param| puts "block with #{param}" }
block with arg
=> nil

 > # or multi-line:
 > fn("arg") do |param|
?>   puts "block with #{param}"
?> end
block with arg
=> nil
```

### Iterators ###

- Blocks are commonly used with iterators:

  ``` ruby
 > # for single-line:
 > 3.times { puts "foo" }
foo
foo
foo
=> 3

 > # or multi-line:
 > 3.times do
?>   puts "foo"
?> end
foo
foo
foo
=> 3
```

- Variables inside a block are local to that block:

  ``` ruby
 > 3.times { |n| puts n }
0
1
2
=> 3
> n
NameError (undefined local variable or method `n' for main:Object)
```

- Use the `times` method to loop a block `n` number of times:
  <br />**Note:** `times` starts at index `0`.
  ``` ruby
> 3.times { |n| puts "index #{n}" }
index 0
index 1
index 2
=> 3
```

- Use the `upto` method to loop a block from a minimum to a maximum range:

  ``` ruby
 > 1.upto(3) { |n| puts "index #{n}" }
index 1
index 2
index 3
=> 1
```

- Use the `each` method to loop iterable objects:

  ``` ruby
 > [1, 3, 5, 7, 9].each { |n| puts "#{n}" }
1
3
5
7
9
=> [1, 3, 5, 7, 9]
```

- Use the `each_char` method to loop strings objects:

  ``` ruby
 > "foo".each_char { |s| puts "#{s}" }
f
o
o
=> "foo"
```

- Use the `map` method to return a modified copy of an array:

  ``` ruby
 > [1, 2, 3].map { |n| n + 1 }
=> [2, 3, 4]
```

- Use the `select` method to return a new array with only the matched condition:
  <br />**Note:** `select` is akin to `filter` on other programming languages, e.g. `Lisp`.
  ``` ruby
 > [1, 2, 3].select { |n| n > 1 }
=> [2, 3]
```

- Use the `reject` method to return a new array without the matched condition:

  ``` ruby
 > [1, 2, 3].reject { |n| n > 1 }
=> [1]
```

- Use the `odd?` or `even?` methods to return odd or even numbers respectively:

  ``` ruby
 > [1, 2, 3].select { |n| n.odd? }  # return a new array of odd numbers
=> [1, 3]
 > [1, 2, 3].select { |n| n.even? } # return a new array of even numbers
=> [2]

 > [1, 2, 3].reject { |n| n.even? } # return a new array of odd numbers
=> [1, 3]
 > [1, 2, 3].reject { |n| n.odd? }  # return a new array of even numbers
=> [2]
```

- Use the `any?` method to check if a specific item matches the condition in an array:

  ``` ruby
 > [1, 2, 3].any? { |n| n > 2 }
=> true
```

- Use the `reduce` method to combine all array items using the specified method:

  ``` ruby
 # operation within a block:
 > [1, 2, 3].reduce { |acc, n| acc + n }
=> 6

 # operation with operator's name:
 > [1, 2, 3].reduce(:+)
=> 6

 # operation with operator's name
 # and a starting accumulator value:
 > [1, 2, 3].reduce(10, :+)
=> 16
```

- Use the `partition` method to destructure the results of an array operation:

  ``` ruby
 > odds, evens = [1, 2, 3].partition { |n| n.odd? }
=> [[1, 3], [2]]

 > odds
=> [1, 3]

 > evens
=> [2]
```

- Use the `detect` method to return the first matched item in an array:

  ``` ruby
 > [1, 2, 3].detect { |n| n > 1 }
=> 2
```

### Sorting ###

- Use the `sort` method to sort items in an array (ascending order):

  ``` ruby
 >
=> [1, 2, 3]
```

- Use the `sort.reverse` methods to reverse sorting items in an array (descending order):

  ``` ruby
 > [1, 3, 2].sort.reverse
=> [3, 2, 1]
```

- Use the `sort_by` method to perform a custom sorting:

  ``` ruby
 > # ascending:
 > ["foo", "foobarbaz", "foobar"].sort_by { |s| s.length }
=> ["foo", "foobar", "foobarbaz"]

 > # descending:
 > ["foo", "foobarbaz", "foobar"].sort_by { |s| s.length }.reverse
=> ["foobarbaz", "foobar", "foo"]
```

- Use the spaceship operator (`<=>`) to compare and get a corresponding integer value:
  <br />**Note:** The spaceship operator is also called the general comparison operator.

  ``` ruby
 > 10 <=> 9  # return 1 if left-hand side is greater than right-hand side
=> 1

 > 9 <=> 10  # return -1 if left-hand side is lesser than right-hand side
 => -1

 > 10 <=> 10 # return 0 if left-hand side is equal to right-hand side
=> 0
```

- Override the spaceship operator of a class to override its `sort` method:

  ``` ruby
 > class Cls
?>   attr_accessor :param
?>
?>   def initialize(param)
?>     @param = param
?>   end
?>
?>   def <=>(obj)
?>     obj.count <=> count
?>   end
?>
?>   def count
?>     @param.length
?>   end
?> end
=> :count

 > [
?>   Cls.new("arg").count,
?>   Cls.new("argument").count,
?>   Cls.new("param").count,
?>   Cls.new("parameter").count
?> ].sort
=> [3, 5, 8, 9]
```

-------------------------------------------------------------------------------

Symbols and Structs
-------------------

### Symbol ###

- Prefix characters with a colon (`:`) to make a symbol:

  ``` ruby
 > :foo
=> :foo
```

- Symbols belongs to the `Symbol` class:

  ``` ruby
 > :foo.class
=> Symbol
```

- Symbols are just names that refers to the same object:

  ``` ruby
 > :foo.object_id == :foo.object_id
=> true

 > # Unlike strings that are newly created each time:
 > "foo".object_id == "foo".object_id
=> false
```

- Symbols are names but are not strings:

  ``` ruby
 > :foo == "foo"
=> false
```

- Symbols are immutable:

  ``` ruby
 > :foo[0] = "b"
NoMethodError (undefined method `[]=' for :foo:Symbol)

 > # Unlike strings that are mutable:
 > "foo"[0] = "b"
=> "b"
```

- Use the `to_sym` method to convert an object to a symbol:

  ``` ruby
 > "foo".to_sym
=> :foo
```

### Struct ###

- A struct is a convenient way to create a class with read and write attributes:

  ``` ruby
 > Cls = Struct.new(:param)
=> Cls

 # is equivalent to:
 > class Cls
?>   attr_accessor :param
?>
?>   def initialize(param)
?>     @param = param
?>   end
?> end
=> :initialize
```

- Use `do-end` block to include methods:

  ``` ruby
 > Cls = Struct.new(:param) do
?>   def method
?>     "#{param}"
?>   end
?> end
=> Cls
```

-------------------------------------------------------------------------------

Hashes
------

- Use braces (`{}`) to create hashes:
  <br />**Note:** A hash is called associative array, map, or dictionary in other programming languages.

  ``` ruby
 > {}
=> {}
```

- Hashes contain a key and a value between `=>` operator:

  ``` ruby
 > { :key => "value" }
=> {:key=>"value"}
```

- For symbols as keys, suffix characters with a colon (`:`) to omit the `=>` operator:
  ``` ruby
 > { key: "value" }
=> {:key=>"value"}
```

- Put the key within brackets (`[]`) to access its value:

  ``` ruby
 > { foo: "bar" }[:foo]
=> "bar"
```

- Non-existing keys returns `nil` as its value:

  ``` ruby
 > { foo: "bar" }[:bar]
=> nil
```

- Use the `Hash` class and the `new` method to specify a default value:

  ``` ruby
 > Hash.new(0)[:bar]
=> 0
```

- Use the `keys` method to get all the keys of a hash:

  ``` ruby
 > { foo: "bar" }.keys
=> [:foo]
```

- Use the `values` method to get all the keys of a hash:

  ``` ruby
 > { foo: "bar" }.values
=> ["bar"]
```

- Use two parameters when looping a hash:

  ``` ruby
 > { foo: "bar" }.each { |k, v| puts "#{k} => #{v}" }
foo => bar
=> {:foo=>"bar"}
```

Let's continue to the last part: [Ruby Programming: Part 4](ruby-programming-part-4).
