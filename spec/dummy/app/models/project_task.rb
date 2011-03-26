class ProjectTask < ActiveRecord::Base
  attr_accessible :project_id, :task_id

  belongs_to :project
  belongs_to :task 

end
