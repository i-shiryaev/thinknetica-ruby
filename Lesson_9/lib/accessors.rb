module Accessors
  def attr_accessor_with_history(*names)
    names.each do |name|
      history_variable = "@#{name}_history"
      variable_name = "@#{name}"
      define_method(name) { instance_variable_get(variable_name) }
      define_method("#{name}=") do |value|
        history = instance_variable_get(history_variable) || []
        previous_value = instance_variable_get(variable_name)
        if previous_value
          instance_variable_set(history_variable, history << previous_value)
        end
        instance_variable_set(variable_name, value)
      end
      define_method("#{name}_history") { instance_variable_get(history_variable) }
    end
  end

  def strong_attr_accessor(attribute, klass)
    variable_name = "@#{attribute}"
    define_method(attribute) { instance_variable_get(variable_name) }
    define_method("#{attribute}=") do |value|
      raise "#{value} should be a #{klass}" unless value.is_a?(klass)
      instance_variable_set(variable_name, value)
    end
  end
end
