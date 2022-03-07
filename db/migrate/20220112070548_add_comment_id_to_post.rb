class AddCommentIdToPost < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :comment_id, :integer
  end
end
