Factory.sequence :name do |n|
  "Project #{n}"
end

Factory.sequence :task_name do |n|
  "Task #{n}"
end

Factory.define :project do |proj|
  proj.name       { Factory.next(:name) } 
  proj.summary    "Lorem ipsum..."
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

