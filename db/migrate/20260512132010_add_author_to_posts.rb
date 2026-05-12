class AddAuthorToPosts < ActiveRecord::Migration[8.1]
  def change
    add_column :posts, :author, :string
  end
end
