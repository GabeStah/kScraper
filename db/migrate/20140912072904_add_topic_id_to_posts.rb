class AddTopicIdToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :topic_id, :bigint
    add_index :posts, :topic_id, unique: true
  end
end
