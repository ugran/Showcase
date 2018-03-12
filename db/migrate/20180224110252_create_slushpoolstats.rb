class CreateSlushpoolstats < ActiveRecord::Migration[5.2]
  def change
    create_table :slushpoolstats do |t|
      t.integer :user_id
      t.integer :group_id
      t.decimal :total_hashrate, :null => false, :default => 0
      t.decimal :confirmed_reward, :null => false, :default => 0
      t.decimal :unconfirmed_reward, :null => false, :default => 0
      t.decimal :estimated_reward, :null => false, :default => 0
      t.json :hashrate_distribution

      t.timestamps
    end
    add_index :slushpoolstats, :user_id
    add_index :slushpoolstats, :group_id
  end
end
