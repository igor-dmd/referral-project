class CreateReferrals < ActiveRecord::Migration[6.1]
  def change
    create_table :referrals do |t|
      t.belongs_to :customer, foreign_key: true
      t.string :key, indexed: true
      t.integer :referred_count
      t.timestamps
    end
  end
end
