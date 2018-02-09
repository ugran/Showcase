class CreateBtcHistories < ActiveRecord::Migration[5.1]
  def change
    create_table :btc_histories do |t|
      t.decimal :price

      t.timestamps
    end
  end
end
