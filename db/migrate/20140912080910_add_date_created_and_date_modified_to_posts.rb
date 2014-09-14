class AddDateCreatedAndDateModifiedToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :date_created, :datetime
    add_column :posts, :date_modified, :datetime
  end
end
