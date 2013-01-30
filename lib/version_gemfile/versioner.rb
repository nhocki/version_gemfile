require 'tempfile'

module VersionGemfile
  class Versioner
    attr_reader :lock_contents, :gemfile_content, :options, :lockfile_path,
                :gemfile_path

    IS_GEM_LINE = /^\s* gem \s+ ['|"] /ix
    HAS_VERSION  = /^\s*gem \s+ ['|"] \s* [\w|-]+ \s* ['|"]\s*,\s*['|"]/ix
    GET_GEM_NAME = /^\s*gem \s+ ['|"] \s* ([\w|-]+) \s* ['|"]/ix
    GET_VERSION_NUMBER = /^\s+[\w|-]+ \s \( ([\w|\.]+) \)/ix

    def self.add_versions!(options = {})
      new(options).add_versions
    end

    def initialize(options = {})
      @options = normalize_hash(options.clone)
      @gemfile_path = @options.fetch('gemfile'){ 'Gemfile' }
      @lockfile_path = "#{@gemfile_path}.lock"

      @lock_contents   = File.read(lockfile_path)
      @gemfile_content = File.readlines(gemfile_path)
      @orig_gemfile = File.read(gemfile_path)
    end

    #TODO: Clean this up!
    def add_versions
      new_gemfile = Tempfile.new("Gemfile.versioned")
      begin
        gemfile_content.each do |gem_line|
          if is_gem_line?(gem_line)
            new_gemfile.puts(build_gem_line(gem_line))
          else
            new_gemfile.puts(gem_line)
          end
        end
        File.truncate(gemfile_path, 0)
        new_gemfile.rewind
        File.open(gemfile_path, "w") {|f| f.write(new_gemfile.read)}
      rescue Exception => e
        puts "ERROR: #{e}"
        puts "Restoring Gemfile at #{gemfile_path}"
        File.open(gemfile_path, "w") {|f| f.write(@orig_gemfile)}
      ensure
        new_gemfile.close
        new_gemfile.unlink
      end
    end

    def match_gem(gem_line)
      gem_line.match(HAS_VERSION)
    end

    def build_gem_line(gem_line)
      return gem_line if gem_line.match(HAS_VERSION)

      name    = gem_name(gem_line)
      version = get_version(name)
      options = gem_line.gsub(GET_GEM_NAME, '').strip
      "#{spaces(gem_line)}gem '#{name}', '~> #{version}'#{options}"
    end

    private

    def is_gem_line?(gem_line)
      gem_line =~ IS_GEM_LINE
    end

    def gem_name(gem_line)
      gem_line.match(GET_GEM_NAME) { $1 }
    end

    def spaces(gem_line)
      gem_line.match(/^(\s+)/){ $1 }
    end

    def get_version(gem_name)
      regexp = /^\s+#{gem_name}\s\(([\w|\.]+)\)/ix
      regexp.match(lock_contents) { $1 }
    end

    def normalize_hash(hash)
      hash.keys.each do |k|
        unless k.is_a?(String)
          hash[k.to_s] = hash.delete(k)
        end
      end
      hash
    end
  end
end