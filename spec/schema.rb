ActiveRecord::Schema.define(:version => 0) do
  create_table :donuts do |t|
    t.string :flavor, :name, :maker
    t.integer :quantity, :default => 0, :null => false
  end
end
