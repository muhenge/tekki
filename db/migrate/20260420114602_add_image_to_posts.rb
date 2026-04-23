class AddImageToPosts < ActiveRecord::Migration[8.1]
  def change
    add_column :posts, :image, :text unless column_exists?(:posts, :image)
  end
end
