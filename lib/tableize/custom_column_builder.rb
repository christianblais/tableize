module Tableize
  class CustomColumnBuilder

    attr_reader :options

    def initialize(name, *args, &block)
      @name     = name
      @options  = args.extract_options!
      @block    = block
      @fields   = {}
    end

    def generate!
      @block.call(self) if @block
    end

    def get(key)
      @fields[key]
    end

    def th(options={}, &block)
      @fields[:th] = [options, block]
    end

    def td(options={}, &block)
      @fields[:td] = [options, block]
    end
  end
end
