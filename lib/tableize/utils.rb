module Tableize
  def self.convert_to_array(array, *args)
    array = [array].flatten.compact

    args.each do |arg|
      array.push(arg)
    end

    array
  end
end