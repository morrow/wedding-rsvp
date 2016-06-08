class AddFutureLockAndGlobalLockToAdmins < ActiveRecord::Migration
  def change
    add_column :admins, :global_future_full_lock, :boolean
    add_column :admins, :global_future_lock, :boolean
  end
end
