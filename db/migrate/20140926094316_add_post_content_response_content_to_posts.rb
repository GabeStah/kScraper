class AddPostContentResponseContentToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :post_content, :text
    add_column :posts, :response_content, :text
  end
end
