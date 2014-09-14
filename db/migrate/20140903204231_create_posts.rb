class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.boolean :responded
      t.boolean :ignored

      t.timestamps
    end
  end
end
