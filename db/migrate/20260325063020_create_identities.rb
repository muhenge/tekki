class CreateIdentities < ActiveRecord::Migration[8.0]
  def change
    create_table :identities do |t|
      t.references :user, null: false, foreign_key: true
      t.string :provider, null: false
      t.string :uid, null: false
      t.string :name
      t.string :email
      t.string :avatar
      t.text :tokens

      t.timestamps

      t.index [:provider, :uid], unique: true
      t.index :provider
    end
  end
end
