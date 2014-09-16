class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts, options: "DEFAULT CHARSET=utf8 COLLATE=utf8_bin ENGINE=InnoDB" do |t|
      t.string :title
      t.boolean :responded
      t.boolean :ignored

      t.timestamps
    end
  end
end
