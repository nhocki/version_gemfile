require 'bundler'
require 'version_gemfile'

Bundler.require(:default, :test, :development)

module SpecHelpers
  def support_dir_path
    File.join(File.dirname(__FILE__), "support")
  end

  def read_support_file(filename)
    File.read(File.join(support_dir_path, filename))
  end

  def test_gemfile_lock
    read_support_file "Gemfile.lock.test"
  end
end
  

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
  config.include SpecHelpers
end
