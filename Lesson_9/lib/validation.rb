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
    end

    attr_reader :validations
  end

  module InstanceMethods
    def validate!
      return false unless validations
      validations.each do |name, parameters|
        parameters.each do |validation|
          validation_type = validation[:validation_type]
          validation_option = validation[:validation_option]
          send("validate_#{validation_type}", instance_variable_get("@#{name}"), validation_option)
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

    def validate_presence(value, _parameter)
      raise 'Should be present.' if value.is_a?(String) && value.empty?
    end

    def validate_format(value, format)
      raise 'Format should be correct.' if value !~ format
    end

    def validate_type(value, type)
      raise 'Type should be correct' unless value.is_a?(type)
    end
  end
end
