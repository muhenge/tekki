class CreatePostCareers < ActiveRecord::Migration[8.0]
  def change
    create_table :post_careers do |t|
      t.references :post, null: false, foreign_key: true
      t.references :career, null: false, foreign_key: true

      t.timestamps
    end
  end
end
