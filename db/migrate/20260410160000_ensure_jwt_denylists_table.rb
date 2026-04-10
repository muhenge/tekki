class EnsureJwtDenylistsTable < ActiveRecord::Migration[8.1]
  def up
    if table_exists?(:jwt_denylist) && !table_exists?(:jwt_denylists)
      rename_table :jwt_denylist, :jwt_denylists
    elsif !table_exists?(:jwt_denylists)
      create_table :jwt_denylists do |t|
        t.string :jti, null: false
        t.datetime :exp, null: false
      end
    end

    add_index :jwt_denylists, :jti unless index_exists?(:jwt_denylists, :jti)
  end

  def down
    drop_table :jwt_denylists if table_exists?(:jwt_denylists)
  end
end
