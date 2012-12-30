FactoryGirl.define do
  sequence(:proj_name) { |n| "Project #{n}" }
  sequence(:task_name) { |n| "Task #{n}" }
  sequence(:dept_name) { |n| "Department #{n}" }
  sequence(:email) { |n| "email#{n}@example.com" }
  sequence(:id_1000) { |n| n + 1000 }
  sequence(:id_10000) { |n| n + 10000 }

  factory :project do
    name        { generate(:proj_name) }
    summary     "Lorem ipsum..."
    association :department
    email       { generate(:email) }
    phone       '555.555.5555'
    start_time  Time.now
    pay_rate    7.50
    importance  5
    password    "password"
    description "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
  end

  factory :task do
    id          { generate(:id_1000) }
    name        { generate(:task_name) }
    priority    3
    complete    false
  end

  factory :department do
    id          { generate(:id_10000) }
    name        { generate(:dept_name) }
  end

  factory :project_with_task, :parent => :project do
    tasks { |tasks| [tasks.association(:task), tasks.association(:task)] }
  end
end
