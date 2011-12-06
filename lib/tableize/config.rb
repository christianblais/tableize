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
        @configuration.call(self) if @configuration
      end

      def custom_columns
        @custom_columns ||= {}
      end

      def custom_column(name, *args, &block)
        custom_columns[name] = CustomColumnBuilder.new(name, *args, &block)
      end

      protected

      def init!
        @defaults = {
          :@table_options => nil,
          :@th_options => nil,
          :@tr_options => nil
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
