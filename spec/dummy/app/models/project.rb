class Project < ActiveRecord::Base
  has_many :project_tasks
  has_many :tasks, :through => :project_tasks
  belongs_to :department

  validates :name, :presence => true
  validates_numericality_of :importance, 
      :only_integer => true, 
      :greater_than_or_equal_to => 1, 
      :less_than_or_equal_to => 5
end
