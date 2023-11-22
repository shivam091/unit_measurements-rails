# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

require "byebug"

class MeasuredValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, measurement)
    measured_config = record.class.measured_attributes[attribute.to_s]
    unit_group = measured_config[:unit_group]
    quantity_attribute_name = measured_config[:quantity_attribute_name]
    unit_attribute_name = measured_config[:unit_attribute_name]

    measurement_quantity = record.public_send(quantity_attribute_name)
    measurement_unit = unit_group.unit_for(record.public_send(unit_attribute_name))

    return unless measurement_quantity.present? || measurement_unit.present?

    validate_unit(record, attribute, measurement_unit)
    validate_valid_units(record, attribute, unit_group, measurement_unit)

    validate_check_options(record, attribute, measurement, options.slice(*OPERATORS.keys), unit_group, measurement_unit)
  end

  private

  OPERATORS = {
    greater_than: :>,
    greater_than_or_equal_to: :>=,
    equal_to: :==,
    less_than: :<,
    less_than_or_equal_to: :<=,
  }.freeze

  def validate_unit(record, attribute, measurement_unit)
    record.errors.add(attribute, message(record, "is not a valid unit")) unless measurement_unit
  end

  def validate_valid_units(record, attribute, unit_group, measurement_unit)
    return unless options[:units]

    valid_units = Array(options[:units]).map { |unit| unit_group.unit_for(unit) }
    record.errors.add(attribute, message(record, 'is not a valid unit')) unless valid_units.include?(measurement_unit)
  end

  def quantity_and_unit_present?(record, quantity_attribute_name, unit_attribute_name)
    record.public_send(quantity_attribute_name).present?
  end

  def validate_check_options(record, attribute, measurement, check_options, unit_group, measurement_unit)
    check_options.each do |option, value|
      comparable_value = value_for(value, record)
      comparable_value = unit_group.new(comparable_value, measurement_unit) unless comparable_value.is_a?(UnitMeasurements::Measurement)

      unless measurement.public_send(OPERATORS[option], comparable_value)
        record.errors.add(attribute, message(record, "#{measurement.to_s} must be #{OPERATORS[option]} #{comparable_value}"))
      end
    end
  end

  def message(record, default_message)
    if options[:message].respond_to?(:call)
      options[:message].call(record)
    else
      options[:message] || default_message
    end
  end

  def value_for(key, record)
    value = case key
            when Proc   then key.call(record)
            when Symbol then record.send(key)
            else             key
            end

    raise ArgumentError, ":#{value} must be a number or a Measurement object" unless value.is_a?(Numeric) || value.is_a?(UnitMeasurements::Measurement)
    value
  end
end
