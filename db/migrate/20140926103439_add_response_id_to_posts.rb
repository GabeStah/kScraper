class AddResponseIdToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :response_id, :bigint
  end
end
