class AddTopicIdToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :topic_id, :integer, unique: true
  end
end
