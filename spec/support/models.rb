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
  column :importance, :integer
  column :password, :string 
  column :description, :text

  has_many :tasks

  accepts_nested_attributes_for :tasks

  # validations 
  validates :name, :presence => true
  # validates :importance, :numericality => true, :length => { :within => 1..5 } 
  validates_numericality_of :importance, :only_integer => true, :greater_than_or_equal_to => 1, :less_than_or_equal_to => 5

end

class Task < TablelessModel
  column :project_id, :integer
  column :name, :string
  belongs_to :project
end

