module Validation
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    def validate(name, validation_type, *validation_options)
      @validations ||= {}
      validations[name] ||= []
      validations[name] << { validation_type: validation_type, validation_option: validation_options.first }
      define_method(:validations) { self.class.instance_variable_get('@validations') }
      define_method(:instance_name) { |field_name| instance_variable_get("@#{field_name}") }
    end

    attr_reader :validations
  end

  module InstanceMethods
    def validate!
      validations.each do |name, parameters|
        parameters.each do |validation|
          validation_type = validation[:validation_type]
          validation_option = validation[:validation_option]
          send("validate_#{validation_type}", name, validation_option)
        end
      end
    end

    def valid?
      validate!
      true
    rescue StandardError
      false
    end

    private

    def validate_presence(name, _parameter)
      raise 'Should be present.' if instance_name(name).is_a?(String) && instance_name(name).empty?
    end

    def validate_format(name, format)
      raise 'Format should be correct.' if instance_name(name) !~ format
    end

    def validate_type(name, type)
      raise 'Type should be correct' unless instance_name(name).is_a?(type)
    end
  end
end
