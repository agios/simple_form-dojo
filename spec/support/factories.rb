FactoryGirl.define do
  sequence :name do |n|
    "Project #{n}"
  end

  sequence :task_name do |n|
    "Task #{n}"
  end

  sequence :dept_name do |n|
    "Department #{n}"
  end

  sequence :email do |n|
    "email#{n}@example.com"
  end

  factory :project do
    name       { generate(:name) } 
    summary    "Lorem ipsum..."
    association  :department
    email      { generate(:email) } 
    phone      '555.555.5555'
    start_time Time.now
    pay_rate   7.50
    importance 5
    password   "password"
    description "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
  end

  factory :task do
    name       { generate(:task_name) }
    priority   3
    complete   false
  end

  factory :department do
    name { generate(:dept_name) }
  end

  factory :project_with_task, :parent => :project do
    tasks { |tasks| [tasks.association(:task), tasks.association(:task)] }
  end
end
