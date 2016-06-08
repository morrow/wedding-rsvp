class CleanUpGuestModel < ActiveRecord::Migration
  def change
    remove_column :guests, :accessed
    remove_column :guests, :email
    remove_column :guests, :encrypted_password
    remove_column :guests, :reset_password_token
    remove_column :guests, :reset_password_sent_at
    remove_column :guests, :remember_created_at
    remove_column :guests, :current_sign_in_at
    remove_column :guests, :current_sign_in_ip
    remove_column :guests, :last_sign_in_ip
    remove_column :guests, :authentication_token
  end
end
