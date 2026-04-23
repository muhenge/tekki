class RemoveImageColumnFromPosts < ActiveRecord::Migration[8.1]
  def change
    remove_column :posts, :image, :text, if_exists: true
  end
end
