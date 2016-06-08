class AddLockToAdmin < ActiveRecord::Migration
  def change
    add_column :admins, :global_lock, :boolean
    add_column :admins, :global_lock_date, :boolean
    add_column :admins, :global_full_lock, :boolean
  end
end
