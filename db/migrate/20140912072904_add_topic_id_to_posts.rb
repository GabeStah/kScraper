class AddTopicIdToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :topic_id, :bigint, unique: true
  end
end
