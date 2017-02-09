TypeScript compiler as a Ruby gem.

## Installation

Add this line to your application's Gemfile:

    gem 'tsc-ruby'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tsc-ruby

## Usage

```ruby
require 'tsc-ruby'

# compiles a TypeScript source file and returns TypeScript::Ruby::CompileResult
result = TypeScript::Ruby.compile_file(file, '--target', 'ES5')
result.success? # => true if succeeded
result.js # => output JavaScript source code
result.stdout # => what tsc(1) shows to stdout
result.stderr # => what tsc(1) shows to stderr

# compiles a TypeScript source code string and returns String
js_source = TypeScript::Ruby.compile_file(ts_source, '--target', 'ES5')
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
