class CreateMiners < ActiveRecord::Migration[5.1]
  def change
    create_table :miners do |t|
      t.integer :user_id
      t.string :worker_name
      t.string :hashrate
      t.string :avg_hashrate
      t.string :temperature
      t.string :algorithm
      t.string :coin
      t.string :accepted
      t.string :rejected
      t.string :hw_errors
      t.string :status
      t.string :mining_time
      t.string :miner_id

      t.timestamps
    end
    add_index :miners, :user_id
  end
end
