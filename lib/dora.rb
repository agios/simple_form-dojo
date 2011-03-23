require 'action_view'
require 'simple_form'
require_relative 'dora/version'
require_relative 'dora/helpers/tabs_helper'
require_relative 'dora/helpers/form_helper'

module Dora
  autoload :FormBuilder,      'dora/form_builder'
  autoload :Inputs,          'dora/inputs'
  autoload :Common,          'dora/common'
end

