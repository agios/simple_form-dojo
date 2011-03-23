# TablelessModel idea found at https://github.com/ryanb/nested_form
class TablelessModel < ActiveRecord::Base
  def self.columns() @columns ||= []; end

  def self.column(name, sql_type = nil, default = nil, null = true)
    columns << ActiveRecord::ConnectionAdapters::Column.new(name.to_s, default, sql_type.to_s, null)
  end
  
  def self.quoted_table_name
    name.pluralize.underscore
  end
  
  def quoted_id
    "0"
  end
end

class Project < TablelessModel
  column :name, :string
  column :summary, :string
  column :start_time, :time
  column :pay_rate, :decimal

  has_many :tasks

  accepts_nested_attributes_for :tasks

  # validations 
  validates :name, :presence => true
end

class Task < TablelessModel
  column :project_id, :integer
  column :name, :string
  belongs_to :project
end

