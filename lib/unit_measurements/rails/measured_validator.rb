# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class MeasuredValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, measurement)
    measured_config = record.class.measured_attributes[attribute.to_s]
    unit_group = measured_config[:unit_group]
    quantity_attribute_name = measured_config[:quantity_attribute_name]
    unit_attribute_name = measured_config[:unit_attribute_name]

    measurement_quantity = record.public_send(quantity_attribute_name)
    measurement_unit = unit_group.unit_for(record.public_send(unit_attribute_name))

    validate_presence_of_unit(record, attribute, measurement_unit)
  end

  private

  # @private
  # Validates the presence of +measurement_unit+.
  #
  # @param [ActiveRecord::Base] record The record being validated.
  # @param [Symbol] attribute The measurement attribute being validated.
  # @param [UnitMeasurements::Unit] measurement_unit The unit of measurement.
  #
  # @author {Harshal V. Ladhe}[https://shivam091.github.io/]
  # @since 2.0.0
  def validate_presence_of_unit(record, attribute, measurement_unit)
    return if measurement_unit

    record.errors.add(attribute, message(record, "does not have valid unit"))
  end

  # @private
  # Generates a validation message for the record.
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
end
