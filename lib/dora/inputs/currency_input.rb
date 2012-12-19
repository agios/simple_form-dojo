module Dora
  module Inputs
    class CurrencyInput < NumericInput
      def dojo_type
        'dijit/form/CurrencyTextBox'
      end
    end
  end
end
