# RSpec::Files

Detect leaked file descriptors and provides convenient file buffers.

[![Development Status](https://github.com/socketry/rspec-files/workflows/Development/badge.svg)](https://github.com/socketry/rspec-files/actions?workflow=Development)

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

## License

Released under the MIT license.

Copyright, 2017, by [Samuel G. D. Williams](http://www.codeotaku.com/samuel-williams).

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
