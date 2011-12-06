%w( config helper utils table_builder column_builder ).each do |file|
  require File.dirname(__FILE__) + "/tableize/" + file
end
