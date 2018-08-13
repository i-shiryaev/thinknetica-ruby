module Accessors
  def attr_accessor_with_history(*names)
    names.each do |name|
      @history = []
      history_variable = "@#{name}_history"
      variable_name = "@#{name}"
      define_method(name) { instance_variable_get(variable_name) }
      define_method("#{name}=") do |value|
        instance_variable_set(variable_name, value)
        history = instance_variable_get(history_variable) || []
        instance_variable_set(history_variable, history << value)
      end
      define_method("#{name}_history") { instance_variable_get(history_variable) }
    end
  end
end
