class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.string :author
      t.timestamp :time

      t.timestamps
    end
  end
end
