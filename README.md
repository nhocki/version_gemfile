# Version Gemfile

[![Build Status](https://travis-ci.org/nhocki/version_gemfile.png)](http://travis-ci.org/nhocki/version_gemfile)


Version Gemfile is a simple gem to add version numbers to your Gemfile gems.

The [problem](http://tenderlovemaking.com/2012/12/18/rails-4-and-your-gemfile.html)
is that most people don't add that simple `'~> x.x.x'` part at the end and
that makes it horrible to run `bundle update`. Well, at least, you can't trust that!

## How does it work?

*Version Gemfile* will go through your *Gemfile* looking for unversioned
gems, then will query your *Gemfile.lock* to get the current version of each
gem you're using and update your *Gemfile*.

## Installation

Add this line to your application's Gemfile:

    gem 'version_gemfile'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install version_gemfile

## Usage

Simply type `$ version_gemfile` and you're done.

Also, you should consider the [Add Gem](https://github.com/abuiles/add_gem) gem to add gems to your Gemfile.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
