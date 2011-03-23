module Dora
  class FormBuilder < SimpleForm::FormBuilder
    include Dora::Inputs
    map_type :string, :email, :search, :tel, :url, :to => Dora::Inputs::StringInput
    map_type :time,                                :to => Dora::Inputs::TimeInput
  end
end
