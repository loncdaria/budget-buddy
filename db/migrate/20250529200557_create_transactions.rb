class CreateTransactions < ActiveRecord::Migration[8.0]
  def change
    create_table :transactions do |t|
      t.decimal :amount
      t.string :transactionType
      t.string :category
      t.text :description
      t.date :date
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
