require 'vips'

require 'tempfile'
require 'pathname'

Vips.set_debug true

module Spec
  module Path
    def root
      @root ||= Pathname.new(File.expand_path('..', __FILE__))
    end

    def sample(*path)
      root.join 'samples', *path
    end

    def tmp(*path)
      root.join 'tmp', 'working', *path
    end

    extend self
  end

  module Helpers
    def reset_working!
      FileUtils.rm Dir[tmp.join('*.*')], :force => true
      FileUtils.mkdir_p(tmp)
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
  config.include Spec::Helpers

  config.before :each do
    GLib::logger.debug { 'before each' }

    reset_working!
  end

  config.after :each do
    GLib::logger.debug { 'after each' }
    reset_working!
  end
end
