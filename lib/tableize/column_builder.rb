module Tableize
  class ColumnBuilder

    attr_reader :title, :method

    def initialize(resource_class, *args, &block)
      @options        = args.extract_options!
      @resource_class = resource_class
      @html_options   = @options.delete(:html) || {}
      @block          = block
      @title          = get_title(args)
      @method         = get_method(args)
    end

    def value(resource, extras)
      if @block
        @method ? @block.call(resource.send(@method), *extras) : @block.call(resource, *extras)
      else
        if @method
          if resource.respond_to?(@method)
            resource.send(@method)
          elsif resource.kind_of?(Hash)
            resource[@method]
          end
        end
      end
    end

    def td_options
      get_options(:td)
    end

    def th_options
      options = get_options(:th)

      if @method
        options[:class] = Tableize::convert_to_array(options[:class], @method.to_s.underscore, value_type)
      end

      options
    end

    protected

    def get_options(key)
      @html_options[key] || {}
    end

    def get_title(args)
      if title = args.first
        if title.kind_of?(String)
          args.shift
        elsif @options.key?(:title)
          @options[:title]
        elsif title.kind_of?(Symbol) && @resource_class.respond_to?(:human_attribute_name)
          @resource_class.send(:human_attribute_name, title)
        else
          title.to_s
        end
      end
    end

    def get_method(args)
      if method = args.last
        method
      end
    end

    def value_type
      if @method && @resource_class.respond_to?(:columns)
        if column = @resource_class.columns.detect{ |column| column.name.to_sym == @method }
          column.type
        end
      end
    end
  end
end