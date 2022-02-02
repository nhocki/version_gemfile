require "bundler"
require "version_gemfile"

Bundler.require(:default, :test, :development)

module SpecHelpers
  def support_dir_path
    File.join(File.dirname(__FILE__), "support")
  end

  def read_support_file(filename)
    File.read(File.join(support_dir_path, filename))
  end

  def support_file_lines(filename)
    File.readlines(File.join(support_dir_path, filename))
  end

  def test_gemfile_lock
    read_support_file "Gemfile.initial.test.lock"
  end

  def final_gemfile
    read_support_file "Gemfile.final.test"
  end

  def original_gemfile_lines
    support_file_lines "Gemfile.initial.test"
  end
end

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
  config.include SpecHelpers
end
