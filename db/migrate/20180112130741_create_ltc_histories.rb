class CreateLtcHistories < ActiveRecord::Migration[5.1]
  def change
    create_table :ltc_histories do |t|
      t.decimal :price

      t.timestamps
    end
  end
end
