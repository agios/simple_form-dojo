class AddEmailToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :email, :string
    add_column :projects, :phone, :string
  end

  def self.down
    remove_column :projects, :phone
    remove_column :projects, :email
  end
end
