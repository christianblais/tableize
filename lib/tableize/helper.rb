module Tableize
  def table_for(*args, &block)
    Tableize::TableBuilder.new(self, *args, &block).render
  end
  alias_method :table, :table_for
end

ActionView::Base.send :include, Tableize