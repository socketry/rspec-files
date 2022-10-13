# RSpec::Files

Detect leaked file descriptors and provides convenient file buffers.

[![Development Status](https://github.com/socketry/rspec-files/workflows/Test/badge.svg)](https://github.com/socketry/rspec-files/actions?workflow=Test)

## Installation

Add this line to your application's Gemfile:

``` ruby
gem 'rspec-files'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rspec-files

Finally, add this require statement to the top of `spec/spec_helper.rb`

``` ruby
require 'rspec/files'
```

## Usage

### Leaks

Leaking sockets and other kinds of IOs are a problem for long running services. `RSpec::Files::Leaks` tracks all open sockets both before and after the spec. If any are left open, a `RuntimeError` is raised and the spec fails.

``` ruby
RSpec.describe "leaky ios" do
	include_context RSpec::Files::Leaks
	
	# The following fails:
	it "leaks io" do
		@input, @output = IO.pipe
	end
end
```

In some cases, the Ruby garbage collector will close IOs. In the above case, it's possible that just writing `IO.pipe` will not leak as Ruby will garbage collect the resulting IOs immediately. It's still incorrect to not close IOs, so don't depend on this behaviour.

### Buffers

File buffers are useful for specs which implement I/O operations. This context automatically manages a disk-based file which can be used for buffering.

``` ruby
RSpec.describe "buffer" do
	include_context RSpec::Files::Buffer
	
	it "can read and write data" do
		buffer.write("Hello World")
		buffer.seek(0)
		
		expect(buffer.read).to be == "Hello World"
	end
end
```

## Contributing

1.  Fork it
2.  Create your feature branch (`git checkout -b my-new-feature`)
3.  Commit your changes (`git commit -am 'Add some feature'`)
4.  Push to the branch (`git push origin my-new-feature`)
5.  Create new Pull Request
