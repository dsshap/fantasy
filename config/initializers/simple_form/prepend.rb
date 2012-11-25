module SimpleForm
  module Components
    # Needs to be enabled in order to do automatic lookups
    module Prepend
      # Name of the component method
      def prepend
        @prepend ||= begin
          options[:prepend].to_s.html_safe if options[:prepend].present?
        end
      end
      
      # Used when the number is optional
      def has_prepend?
        prepend.present?
      end
    end
  end
end

SimpleForm::Inputs::Base.send(:include, SimpleForm::Components::Prepend)