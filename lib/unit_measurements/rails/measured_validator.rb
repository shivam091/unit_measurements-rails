class MeasuredValidator < ActiveModel::EachValidator
  CHECKS = {
    greater_than: :>,
    greater_than_or_equal_to: :>=,
    equal_to: :==,
    less_than: :<,
    less_than_or_equal_to: :<=,
  }.freeze

  def validate_each(record, attribute, measurable)
    return unless measurable_present?(record, attribute)

    measured_config = record.class.measured_fields[attribute]
    unit_group = measured_config[:unit_group]
    quantity_attribute_name = measured_config[:quantity_attribute_name]
    unit_attribute_name = measured_config[:unit_attribute_name]

    validate_unit(record, attribute, unit_group, unit_attribute_name)
    validate_valid_units(record, attribute, unit_group, unit_attribute_name)

    return unless validate_unit_and_value_present?(record, measurable, quantity_attribute_name, measurable_unit)

    validate_check_options(record, attribute, measurable, options.slice(*CHECKS.keys), unit_group, measurable_unit)
  end

  private

  def measurable_present?(record, attribute)
    measurement_quantity = record.public_send("#{attribute}_value")
    measurement_unit = record.public_send("#{attribute}_unit")
    measurement_quantity.present? || measurement_unit.present?
  end

  def validate_unit(record, attribute, unit_group, unit_attribute_name)
    measurement_unit_name = record.public_send(unit_attribute_name)
    measurement_unit = unit_group.unit_for(measurement_unit_name)
    record.errors.add(attribute, message(record, 'is not a valid unit')) unless measurement_unit
  end

  def validate_valid_units(record, attribute, unit_group, unit_attribute_name)
    return unless options[:units]

    valid_units = Array(options[:units]).map { |unit| unit_group.unit_for(unit) }
    record.errors.add(attribute, message(record, 'is not a valid unit')) unless valid_units.include?(measurable_unit)
  end

  def validate_unit_and_value_present?(record, measurable, quantity_attribute_name, measurable_unit)
    measurable.present? && measurable_unit && measurable_value.present?
  end

  def validate_check_options(record, attribute, measurable, check_options, unit_group, measurable_unit)
    quantity_attribute_name = "#{attribute}_value"

    check_options.each do |option, value|
      comparable_value = value_for(value, record)
      comparable_value = unit_group.new(comparable_value, measurable_unit) unless comparable_value.is_a?(Measured::Measurable)

      unless measurable.public_send(CHECKS[option], comparable_value)
        record.errors.add(attribute, message(record, "#{measurable.to_s} must be #{CHECKS[option]} #{comparable_value}"))
      end
    end
  end

  def message(record, default_message)
    options[:message].respond_to?(:call) ? options[:message].call(record) : options[:message] || default_message
  end

  def value_for(key, record)
    value = case key
            when Proc then key.call(record)
            when Symbol then record.send(key)
            else key
            end

    raise ArgumentError, ":#{value} must be a number or a Measurable object" unless value.is_a?(Numeric) || value.is_a?(Measured::Measurable)
    value
  end
end
