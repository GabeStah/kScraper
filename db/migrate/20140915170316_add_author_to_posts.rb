class AddAuthorToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :author_name, :string
    add_column :posts, :author_armory, :string
  end
end
