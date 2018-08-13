module Validation
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods

    def validate(name, validation_type, *validation_options)
      @validations ||= {}
      validations[name] = { validation_type: validation_type, validation_option: validation_options.first }
      define_method(:validations) { self.class.instance_variable_get("@validations") }
      define_method(:instance_name) { |name| instance_variable_get("@#{name}") }
    end

    attr_reader :validations
  end

  module InstanceMethods
    def validate!
      validations.each do |name, parameters|
        validation_type = parameters[:validation_type]
        validation_option = parameters[:validation_option]
        invalid = send("validate_#{validation_type}", name, validation_option)
        raise ERROR_TYPE[validation_type] if invalid
      end
    end

    def valid?
      validate!
      true
    rescue StandardError
      false
    end

    private

    ERROR_TYPE = {
      presence: "Should be present.",
      format: "Format should be correct.",
      type: "Type should be correct"
    }

    def validate_presence(name, parameter = nil)
      puts instance_name(name)
      instance_name(name).empty?
    end

    def validate_format(name, format)
      instance_name(name) !~ format
    end

    def validate_type(name, type)
      !instance_name(name).is_a?(type)
    end
  end
end
