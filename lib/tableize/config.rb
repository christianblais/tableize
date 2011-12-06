module Tableize
  module Configuration
    class << self
      attr_accessor :table_options,
                    :th_options,
                    :tr_options

      def configure(&block)
        @configuration = block
      end

      def configure!
        @configuration.call(self) if @configuration
      end

      protected

      def init!
        @defaults = {
          
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
