module Tableize
  def self.convert_to_array(element, *args)
    [element].flatten.compact.push(*args)
  end
end