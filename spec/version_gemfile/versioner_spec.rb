require 'spec_helper'

module VersionGemfile
  describe Versioner do

    describe "#build_gem_line" do
      let(:versioner) { Versioner.new }

      it "adds a pessimistic version to the gem" do
        expect(versioner.build_gem_line("gem 'rails'", "45.3.2")).to eql("gem 'rails', '~> 45.3.2'")
        expect(versioner.build_gem_line('gem "rails"', "45.3.2")).to eql("gem 'rails', '~> 45.3.2'")
        expect(versioner.build_gem_line('gem "rack-cache"', "5.3.2")).to eql("gem 'rack-cache', '~> 5.3.2'")
      end

      it "adds the version from the Gemfile.lock file" do
        versioner.stub(lock_contents: test_gemfile_lock)
        expect(versioner.build_gem_line "gem 'pg'" ).to eql("gem 'pg', '~> 0.14.1'")
      end
    end

    describe "#add_versions" do
      let(:options) {{
        gemfile: File.join(support_dir_path, "Gemfile.initial.test"),
        lockfile: File.join(support_dir_path, "Gemfile.lock.test"),
      }}

      let(:versioner) { Versioner.new(options) }

      before do
        @original_gemfile = File.read(options[:gemfile])
        versioner.stub(lock_contents: test_gemfile_lock)
        versioner.stub(gemfile_content: original_gemfile_lines)
      end

      after do
        File.open(options[:gemfile], "w"){|f| f.write(@original_gemfile)}
      end

      it "adds versions to the gemfile" do
        versioner.add_versions
        expect(File.read(options[:gemfile])).to eql(final_gemfile)
      end
    end

    describe "#match_gem" do
      let(:matcher) { Versioner.new }
      it "matches with a line with a version" do
        gems = <<-GEMS
        gem '   rails   ', '3.2.8'
        gem "rails", '~> 2.3.4' :require => "something/else"
        gem "pg", '>= 2.3.4' require: "something/else"
        GEMS

        gems.split("\n").each do |gem_name|
          expect(matcher.match_gem(gem_name)).to be_true
        end
      end

      it "doesn't match with a gem without a version" do
        gems = <<-GEMS
        gem '   rails   '
        gem "rails", :require => "something/else"
        gem "pg", require: "something/else"
        GEMS

        gems.split("\n").each do |gem_name|
          expect(matcher.match_gem(gem_name)).to be_false
        end
      end
    end
  end
end