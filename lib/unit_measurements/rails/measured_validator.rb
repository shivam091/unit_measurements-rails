# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# +MeasuredValidator+ validates measured attributes associated with a model.
#
# This validator checks measured attributes using configured +options+ and
# ensures that the they adhere to certain criteria, such as units, quantities,
# and comparisons against specified values.
#
# @example
#   class CubeWithValidation < ActiveRecord::Base
#     measured_length :length
#     validates :length, measured: true
#
#     # ... configuration and validations of other measured attributes  ...
#   end
#
# @note
#   To use this validator, you must set up measurement attributes in your model
#   and apply the necessary validations.
#
# @author {Harshal V. Ladhe}[https://shivam091.github.io/]
# @since 2.0.0
class MeasuredValidator < ActiveModel::EachValidator
  # Validates each measured +attribute+ of the +record+.
  #
  # @example
  #   cube = CubeWithValidation.new
  #   cube.length = 10
  #   cube.valid? # => true
  #
  # @param [ActiveRecord::Base] record The record to be validated.
  # @param [Symbol] attribute The name of the measured attribute being validated.
  # @param [UnitMeasurements::Measurement] measurement
  #   The measurement value to be validated.
  #
  # @note This method performs validation based on the configured
  #   attributes and options for the measurement attribute.
  #
  # @raise [ArgumentError] If the value is neither a +Numeric+ nor a +Measurement+.
  #
  # @author {Harshal V. Ladhe}[https://shivam091.github.io/]
  # @since 2.0.0
  def validate_each(record, attribute, measurement)
    measured_config = record.class.measured_attributes[attribute.to_s]
    unit_group = measured_config[:unit_group]
    quantity_attribute_name = measured_config[:quantity_attribute_name]
    unit_attribute_name = measured_config[:unit_attribute_name]

    measurement_quantity = record.public_send(quantity_attribute_name)
    measurement_unit = unit_group.unit_for(record.public_send(unit_attribute_name))

    return unless quantity_or_unit_present?(measurement_quantity, measurement_unit)

    validate_unit(record, attribute, measurement_unit)
    validate_units(record, attribute, unit_group, measurement_unit)

    return unless measurement_unit && measurement_quantity.present?

    validate_check_options(record, attribute, measurement)
  end

  private

  # Define the set of comparison operators used for measurement checks.
  #
  # @author {Harshal V. Ladhe}[https://shivam091.github.io/]
  # @since 2.0.0
  OPERATORS = {
    greater_than: :>,
    less_than: :<,
    equal_to: :==,
    greater_than_or_equal_to: :>=,
    less_than_or_equal_to: :<=,
  }.freeze

  # Check if either +measurement_quantity+ or +measurement_unit+ is present.
  #
  # @param [Numeric] measurement_quantity The quantity of the measurement.
  # @param [UnitMeasurements::Unit] measurement_unit The unit of measurement.
  # @return [TrueClass|FalseClass]
  #   Returns +true+ if quantity or unit is present, otherwise +false+.
  #
  # @author {Harshal V. Ladhe}[https://shivam091.github.io/]
  # @since 2.0.0
  def quantity_or_unit_present?(measurement_quantity, measurement_unit)
    return true if measurement_quantity.present? || measurement_unit.present?
    false
  end

  # Validate the presence of +measurement_unit+.
  #
  # @param [ActiveRecord::Base] record The record being validated.
  # @param [Symbol] attribute The attribute being validated.
  # @param [UnitMeasurements::Unit] measurement_unit The unit of measurement.
  #
  # @author {Harshal V. Ladhe}[https://shivam091.github.io/]
  # @since 2.0.0
  def validate_unit(record, attribute, measurement_unit)
    return if measurement_unit

    record.errors.add(attribute, message(record, "is not a valid unit"))
  end

  # Validate the presence and validity of specified measurement units.
  #
  # @param [ActiveRecord::Base] record The record being validated.
  # @param [Symbol] attribute The attribute being validated.
  # @param [UnitMeasurements::UnitGroup] unit_group
  #   The unit group for the measured attribute.
  # @param [UnitMeasurements::Unit] measurement_unit The unit of the measurement.
  #
  # @author {Harshal V. Ladhe}[https://shivam091.github.io/]
  # @since 2.0.0
  def validate_units(record, attribute, unit_group, measurement_unit)
    return unless options[:units].present?

    valid_units = Array(options[:units]).map { |unit| unit_group.unit_for(unit) }.compact

    return if valid_units.include?(measurement_unit)

    record.errors.add(attribute, message(record, "is not a valid unit"))
  end

  # Validate measured +attribute+ based on specified check +options+.
  #
  # @param [ActiveRecord::Base] record The record being validated.
  # @param [Symbol] attribute The attribute being validated.
  # @param [UnitMeasurements::Measurement] measurement The measurement value.
  #
  # @author {Harshal V. Ladhe}[https://shivam091.github.io/]
  # @since 2.0.0
  def validate_check_options(record, attribute, measurement)
    options.slice(*OPERATORS.keys).each do |option, value|
      comparable_value = value_for(record, value)
      next if measurement.public_send(OPERATORS[option], comparable_value)

      record.errors.add(attribute, message(record, "#{measurement.to_s} must be #{option.to_s.humanize.downcase} #{comparable_value}"))
    end
  end

  # Generate a validation message for the record.
  #
  # @param [ActiveRecord::Base] record The record being validated.
  # @param [String] default_message The default error message.
  # @return [String] The validation error message.
  #
  # @author {Harshal V. Ladhe}[https://shivam091.github.io/]
  # @since 2.0.0
  def message(record, default_message)
    options[:message].respond_to?(:call) ? options[:message].call(record) : (options[:message] || default_message)
  end

  # Obtain a value for measurement comparison.
  #
  # @param [ActiveRecord::Base] record The record being validated.
  # @param [Object] key The key to retrieve the value for comparison.
  # @return [Object] The value used for comparison.
  #
  # @raise [ArgumentError] If the value is neither a +Numeric+ nor a +Measurement+.
  #
  # @author {Harshal V. Ladhe}[https://shivam091.github.io/]
  # @since 2.0.0
  def value_for(record, key)
    case key
    when Proc   then key.call(record)
    when Symbol then record.send(key)
    else             key
    end.tap do |value|
      raise ArgumentError, ":#{value} must be a number or a Measurement object" unless value.is_a?(Numeric) || value.is_a?(UnitMeasurements::Measurement)
    end
  end
end
