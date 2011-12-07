module Tableize
  def self.convert_to_array(element, *args)
    [element].flatten.compact.push(*args)
  end

  def self.merge_values(main, other)
    other.each_with_object(main) do |(k,v), hash|
      current = hash[k]

      hash[k] = if current.nil?
        v
      elsif v.nil?
        current
      elsif [current, v].all?{ |x| x.kind_of?(Hash) }
        merge_values(current, v)
      else
        [current, v].flatten.compact
      end
    end
  end
end
