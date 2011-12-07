module Tableize
  class ColumnBuilder

    attr_reader :title, :method, :td_options

    def initialize(resource_class, *args, &block)
      @options        = args.extract_options!
      @resource_class = resource_class
      @th_options     = @options.delete(:th) || {}
      @td_options     = @options.delete(:td) || {}
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

    def th_options
      Tableize.merge_values(Tableize::Configuration.th_options.try(:call, (@method || @title).try(:to_s), value_type), @th_options)
    end

    protected

    def get_title(args)
      if @options.key?(:title)
        @options[:title].to_s
      elsif title = args.first
        if title.kind_of?(String)
          args.shift
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
      @value_type ||= begin
        if @method && @resource_class.respond_to?(:columns)
          if column = @resource_class.columns.detect{ |column| column.name.to_sym == @method }
            column.type
          end
        end
      end
    end
  end
end
