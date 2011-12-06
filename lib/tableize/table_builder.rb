module Tableize
  class TableBuilder

    delegate :content_tag, :to => :@view_context

    def initialize(view_context, *args, &block)
      @view_context   = view_context
      @options        = args.extract_options!
      @table_options  = @options.delete(:html) || {}
      @tr_options     = @table_options.delete(:tr) || {}
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
      @view_context.capture(self, &@block)

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
      Tableize::Configuration.table_options.call(@resource_class).merge(@table_options)
    end

    def tr_options(resource)
      Tableize::Configuration.tr_options.call(resource).merge(@tr_options)
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
