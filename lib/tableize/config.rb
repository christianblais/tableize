module Tableize
  module Configuration
    class << self
      attr_accessor :custom_columns,
                    :table_options,
                    :th_options,
                    :tr_options

      def configure(&block)
        @configuration = block
      end

      def configure!
        if @configuration
          @configuration.call(self)

          define_custom_columns!
        end
      end

      def custom_columns
        @custom_columns ||= {}
      end

      def custom_column(name, *args, &block)
        custom_columns[name] = CustomColumnBuilder.new(name, *args, &block)
      end

      protected

      def define_custom_columns!
        custom_columns.each do |name, custom_column|
          custom_column.generate!

          th_options, title = custom_column.get(:th)
          td_options, block = custom_column.get(:td)

          Tableize::TableBuilder.class_eval do
            define_method name do
              # add the column to the list
              @columns << Tableize::ColumnBuilder.new(@resource_class, title.try(:call, @resource_class), :th => th_options, :td => td_options, &block)
              # merge options with table options
              @options = Tableize.merge_values(@options, custom_column.options)
            end
          end
        end
      end

      def init!
        @defaults = {
          :@table_options => nil,
          :@th_options    => nil,
          :@tr_options    => nil
        }
      end

      def reset!
        @defaults.each do |k,v|
          instance_variable_set(k,v)
        end
      end
    end
    
    init!
    reset!
  end
end
