module Dora
  class FormBuilder < SimpleForm::FormBuilder
    include Dora::Inputs
    map_type :string, :email, :search, :tel, :url, :to => Dora::Inputs::StringInput
  end
end
