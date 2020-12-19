require 'vips'

require 'tempfile'
require 'pathname'

Vips.set_debug ENV['DEBUG']
# Vips.leak_set true

module Spec
  module Path
    def set_root(path)
      @root = Pathname.new(path).expand_path
    end

    def sample(*path)
      root.join 'samples', *path
    end

    def tmp(*path)
      root.join 'tmp', 'working', *path
    end

    extend self

    private

    def root
      @root ||= set_root(File.expand_path('..', __FILE__))
    end
  end
end

def simg(name)
  Spec::Path::sample(name).to_s
end

def timg(name)
  Spec::Path::tmp(name).to_s
end

RSpec.configure do |config|
  config.include Spec::Path

  config.around do |example|
    Dir.mktmpdir do |dir|
      set_root(dir)
      FileUtils.mkdir_p(Spec::Path.sample)
      FileUtils.mkdir_p(Spec::Path.tmp)
      example.run
    end
  end

  config.before(jpeg: true) do
    skip 'need jpegload for this spec' unless has_jpeg?
  end
end
