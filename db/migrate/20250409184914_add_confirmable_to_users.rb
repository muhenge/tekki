class AddConfirmableToUsers < ActiveRecord::Migration[8.0]
  def up
    # Just confirm all existing users, since the columns already exist
    User.update_all(confirmed_at: Time.current)
  end

  def down
    # Optional: You can blank confirmed_at
    User.update_all(confirmed_at: nil)
  end
end
