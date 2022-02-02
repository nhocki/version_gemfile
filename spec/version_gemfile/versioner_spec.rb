require "spec_helper"

module VersionGemfile
  describe Versioner do
    describe "#build_gem_line" do
      let(:versioner) { Versioner.new }
      before { versioner.stub(lock_contents: test_gemfile_lock) }

      it "adds a pessimistic version to the gem" do
        expect(versioner.build_gem_line("gem 'rails'")).to match(/~>/)
      end

      it "adds the version from the Gemfile.lock file" do
        expect(versioner.build_gem_line("gem 'pg'")).to eql('gem "pg", "~> 0.14.1"')
        expect(versioner.build_gem_line("gem 'pg', :require => 'hello'")).to eql('gem "pg", "~> 0.14.1", :require => \'hello\'')
        expect(versioner.build_gem_line("gem 'pg', require: 'hello'")).to eql('gem "pg", "~> 0.14.1", require: \'hello\'')
      end
    end

    describe "#add_versions" do
      let(:options) {
        {
          gemfile: File.join(support_dir_path, "Gemfile.initial.test")
        }
      }

      let(:versioner) { Versioner.new(options) }

      before do
        @original_gemfile = File.read(options[:gemfile])
        versioner.stub(lock_contents: test_gemfile_lock)
        versioner.stub(gemfile_content: original_gemfile_lines)
      end

      after do
        File.write(options[:gemfile], @original_gemfile)
      end

      it "adds versions to the gemfile" do
        versioner.add_versions
        expect(File.read(options[:gemfile])).to eql(final_gemfile)
      end

      it "Versioner.add_versions! also adds versions to the gemfile" do
        Versioner.add_versions!(options)
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
          expect(matcher.match_gem(gem_name)).to be_truthy
        end
      end

      it "doesn't match with a gem without a version" do
        gems = <<-GEMS
        gem '   rails   '
        gem "rails", :require => "something/else"
        gem "pg", require: "something/else"
        GEMS

        gems.split("\n").each do |gem_name|
          expect(matcher.match_gem(gem_name)).to be_falsey
        end
      end
    end
  end
end
