module SimpleForm
  module Components
    # Needs to be enabled in order to do automatic lookups
    module Append
      # Name of the component method
      def append
        @append ||= begin
          options[:append].to_s.html_safe if options[:append].present?
        end
      end
      
      # Used when the number is optional
      def has_append?
        append.present?
      end
    end
  end
end

SimpleForm::Inputs::Base.send(:include, SimpleForm::Components::Append)