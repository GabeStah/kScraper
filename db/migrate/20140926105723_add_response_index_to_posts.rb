class AddResponseIndexToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :response_index, :string
  end
end
