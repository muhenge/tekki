class AddConfirmableToUsers < ActiveRecord::Migration[8.0]
  def up
    # Add confirmable columns first
    add_column :users, :confirmation_token, :string
    add_column :users, :confirmed_at, :datetime
    add_column :users, :confirmation_sent_at, :datetime
    add_column :users, :unconfirmed_email, :string

    add_index :users, :confirmation_token, unique: true

    # Confirm all existing users
    User.update_all(confirmed_at: Time.current)
  end

  def down
    remove_index :users, :confirmation_token
    remove_column :users, :confirmation_token, :string
    remove_column :users, :confirmed_at, :datetime
    remove_column :users, :confirmation_sent_at, :datetime
    remove_column :users, :unconfirmed_email, :string
  end
end
