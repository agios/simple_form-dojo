Factory.sequence :name do |n|
  "Project #{n}"
end

Factory.sequence :task_name do |n|
  "Task #{n}"
end

Factory.sequence :dept_name do |n|
  "Department #{n}"
end

Factory.sequence :email do |n|
  "email#{n}@example.com"
end

Factory.define :project do |proj|
  proj.name       { Factory.next(:name) } 
  proj.summary    "Lorem ipsum..."
  proj.association  :department
  proj.email      { Factory.next(:email) } 
  proj.phone      '555.555.5555'
  proj.start_time Time.now
  proj.pay_rate   7.50
  proj.importance 5
  proj.password   "password"
  proj.description "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
end

Factory.define :task do |task|
  task.name       { Factory.next(:task_name) }
  task.priority   3
  task.complete   false
end

Factory.define :department do |dept|
  dept.name { Factory.next(:dept_name) }
end

Factory.define :project_with_task, :parent => :project do |proj|
  proj.tasks { |tasks| [tasks.association(:task), tasks.association(:task)] }
end
