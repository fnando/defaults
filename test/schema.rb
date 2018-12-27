ActiveRecord::Schema.define(version: 0) do
  create_table :donuts do |t|
    t.string :flavor, :name, :maker
    t.integer :quantity, null: false
    t.float :price, default: 0.00, null: false
    t.boolean :available, default: true, null: false
    t.string :slug, null: false
  end
end
