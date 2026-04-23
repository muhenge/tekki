class AddUserIdToPostsAgain < ActiveRecord::Migration[8.0]
  def change
    if column_exists?(:posts, :user_id)
      add_index :posts, :user_id unless index_exists?(:posts, :user_id)
    else
      add_reference :posts, :user, foreign_key: true
    end
  end
end