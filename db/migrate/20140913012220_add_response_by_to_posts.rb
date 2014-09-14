class AddResponseByToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :response_by, :string
  end
end
