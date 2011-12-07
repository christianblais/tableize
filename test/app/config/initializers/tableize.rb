Tableize::Configuration.configure do |config|

  # default table options
  config.table_options = lambda do |resource_class|
    {
      :class => "#{resource_class.model_name.tableize}"
    }
  end

  # default th options
  config.th_options = lambda do |field, type|
    {
      :class => [field, type].compact.map{ |a| a.to_s.underscore }
    }
  end

  # default tr options
  config.tr_options = lambda do |resource|
    {
      :class => "#{resource.class.model_name.underscore}_#{resource.id}"
    }
  end

  # custom column builder
  config.custom_column :title, :html => {:class => "titleized"} do |column|
    column.th :class => "title_th" do |resource_class|
      resource_class.human_attribute_name(:title)
    end

    column.td :class => "title_td" do |resource|
      resource.title
    end
  end

end

ActionView::Base.send(:include, Tableize)
