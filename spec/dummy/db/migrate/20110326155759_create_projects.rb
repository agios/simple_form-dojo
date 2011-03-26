class CreateProjects < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.string :name
      t.string :summary
      t.time :start_time
      t.decimal :pay_rate
      t.integer :importance
      t.string :password
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :projects
  end
end
