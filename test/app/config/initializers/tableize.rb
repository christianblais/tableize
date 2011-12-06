Tableize::Configuration.configure do |config|

  # default table options
  config.table_options = lambda do |resource_class|
    {
      :class => "#{resource_class.model_name.tableize}"
    }
  end

  # default th options
  config.th_options = lambda do |*args|
    {
      :class => args.compact.map{ |a| a.to_s.underscore }
    }
  end

  # default tr options
  config.tr_options = lambda do |resource|
    {
      :class => "#{resource.class.model_name.underscore}_#{resource.id}"
    }
  end
  
end

ActionView::Base.send(:include, Tableize)
