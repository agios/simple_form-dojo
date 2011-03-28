class AddDepartmentIdToProject < ActiveRecord::Migration
  def self.up
    add_column :projects, :department_id, :integer
  end

  def self.down
    remove_column :projects, :department_id
  end
end
