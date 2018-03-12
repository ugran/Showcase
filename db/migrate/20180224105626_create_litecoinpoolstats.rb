class CreateLitecoinpoolstats < ActiveRecord::Migration[5.2]
  def change
    create_table :litecoinpoolstats do |t|
      t.integer :user_id
      t.integer :group_id
      t.decimal :total_hashrate, :null => false, :default => 0
      t.decimal :total_rewards, :null => false, :default => 0
      t.decimal :paid_rewards, :null => false, :default => 0
      t.decimal :unpaid_rewards, :null => false, :default => 0
      t.decimal :expected_rewards, :null => false, :default => 0
      t.decimal :past_24_rewards, :null => false, :default => 0
      t.json :hashrate_distribution

      t.timestamps
    end
    add_index :litecoinpoolstats, :user_id
    add_index :litecoinpoolstats, :group_id
  end
end
