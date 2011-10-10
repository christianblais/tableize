module Tableize
  class TableBuilder

    delegate :content_tag, :to => :@view_context

    DEFAULT_OPTIONS = {
      :default_table_class  => true,
      :default_tr_class     => true
    }

    def initialize(view_context, *args, &block)
      @options        = DEFAULT_OPTIONS.merge(args.extract_options!)
      @table_options  = @options.delete(:html) || {}
      @tr_options     = @table_options.delete(:tr) || {}
      @view_context   = view_context
      @block          = block
      @resource_class = get_resource_class(args)
      @collection     = get_collection(args)
      @columns        = []
      @extras         = []
    end

    def defaults
      (@resource_class.new.attributes.keys - @resource_class.protected_attributes.to_a).each do |attribute|
        column(attribute.to_sym)
      end
    end

    def columns(*args)
      args.each do |arg|
        column(arg)
      end
    end

    def column(*args, &block)
      @columns << Tableize::ColumnBuilder.new(@resource_class, *args, &block)
    end

    def extra(&block)
      @extras << block if block_given?
    end

    def render
      @view_context.capture{ @block.call(self) }

      content_tag(:table, table_options) do
        [thead, tbody].join.html_safe
      end
    end

    protected

    def thead
      content_tag(:thead) do
        content_tag(:tr) do
          @columns.map do |column|
            content_tag(:th, column.th_options) do
              column.title
            end
          end.join.html_safe
        end
      end
    end

    def tbody
      content_tag(:tbody) do
        @collection.map do |resource|
          extras = @extras.map{ |block| block.call(resource) }

          content_tag(:tr, tr_options(resource)) do
            @columns.map do |column|
              content_tag(:td, column.td_options) do
                column.value(resource, extras).to_s.html_safe
              end
            end.join.html_safe
          end
        end.join.html_safe
      end
    end

    def table_options
      options = @table_options.dup

      if @options[:default_table_class] && @resource_class.respond_to?(:model_name)
        options[:class] = Tableize::convert_to_array(options[:class], @resource_class.model_name.tableize)
      end

      options
    end

    def tr_options(resource)
      options = @tr_options.dup

      if @options[:default_tr_class] && @resource_class.respond_to?(:model_name)
        options[:class] = Tableize::convert_to_array(options[:class], "#{@resource_class.model_name.underscore}_#{get_resource_id(resource)}")
      end

      options
    end

    def get_resource_id(resource)
      if resource.respond_to?(:id)
        resource.id
      elsif resource.kind_of?(Hash)
        resource[:id] || resource["id"]
      end
    end

    def get_resource_class(args)
      if resource_class = args.shift
        resource_class
      elsif @options.key?(:resource_class)
        @options[:resource_class]
      elsif @view_context.respond_to?(:resource_class)
        @view_context.resource_class
      end
    end

    def get_collection(args)
      if collection = args.shift
        collection
      elsif @options.key?(:collection)
        @options[:collection]
      elsif @view_context.respond_to?(:collection)
        @view_context.collection
      end
    end

  end
end