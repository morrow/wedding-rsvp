class ChangeLockDateToDatetime < ActiveRecord::Migration
  def self.up
    change_table :admins do |t|
      t.change :global_lock_date, :datetime
    end
  end

  def self.down
    change_table :admins do |t|
      t.change :count, :integer
    end
  end

end
