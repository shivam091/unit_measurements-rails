# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# The +UnitMeasurements+ module provides functionality for handling unit
# measurements. It includes various classes and modules for persisting and
# retrieving measurements with their units.
#
# The module also offers support for integrating with Rails ActiveRecord models
# for handling unit measurements conveniently.
#
# @author {Harshal V. Ladhe}[https://shivam091.github.io/]
# @since 1.0.0
module UnitMeasurements
  module Rails
    # The +UnitMeasurements::Rails::ActiveRecord+ module enhances ActiveRecord
    # models by providing a convenient way to handle unit measurements. It
    # facilitates defining measurable attributes in models with specific unit
    # group support.
    #
    # @author {Harshal V. Ladhe}[https://shivam091.github.io/]
    # @since 1.0.0
    module ActiveRecord
      # @!scope class
      # Defines a _reader_ and _writer_ methods for the measured attributes in
      # the +ActiveRecord+ model.
      #
      # @example Defining single measured attribute:
      #   class Cube < ActiveRecord::Base
      #     measured UnitMeasurements::Length, :height
      #   end
      #
      # @example Defining multiple measured attributes:
      #   class Package < ActiveRecord::Base
      #     measured UnitMeasurements::Weight, :item_weight, :total_weight
      #   end
      #
      # @param [Class|String] unit_group
      #   The unit group class or its name as a string.
      # @param [Array<String|Symbol>] measured_attrs
      #   An array of the names of measured attributes.
      # @param [Hash] options A customizable set of options
      # @option options [String|Symbol] :quantity_attribute_name The name of the quantity attribute.
      # @option options [String|Symbol] :unit_attribute_name The name of the unit attribute.
      #
      # @return [void]
      #
      # @raise [BaseError]
      #   If +unit_group+ is not a subclass of +UnitMeasurements::Measurement+.
      #
      # @see BaseError
      # @author {Harshal V. Ladhe}[https://shivam091.github.io/]
      # @since 1.0.0
      def measured(unit_group, *measured_attrs, **options)
        validate_unit_group!(unit_group)

        options = options.reverse_merge(quantity_attribute_name: nil, unit_attribute_name: nil)
        unit_group = unit_group.constantize if unit_group.is_a?(String)

        options[:unit_group] = unit_group

        measured_attrs.map(&:to_s).each do |measured_attr|
          raise BaseError, "The field '#{measured_attr}' has already been measured." if measured_attributes.key?(measured_attr)

          quantity_attr = options[:quantity_attribute_name]&.to_s || "#{measured_attr}_quantity"
          unit_attr = options[:unit_attribute_name]&.to_s || "#{measured_attr}_unit"

          measured_attributes[measured_attr] = options.merge(quantity_attribute_name: quantity_attr, unit_attribute_name: unit_attr)

          define_reader_for_measured_attr(measured_attr, quantity_attr, unit_attr, unit_group)
          define_writer_for_measured_attr(measured_attr, quantity_attr, unit_attr, unit_group)
          redefine_quantity_writer(quantity_attr)
          redefine_unit_writer(unit_attr, unit_group)
        end
      end

      # @!scope class
      # Returns a hash containing information about the measured attributes and
      # their options.
      #
      # @return [Hash{String => Hash{Symbol => String|Class}}]
      #   A hash where keys represent the names of the measured attributes, and
      #   values are hashes containing the options for each measured attribute.
      #
      # @example
      #   {
      #     "height" => {
      #       unit_group: UnitMeasurements::Length,
      #       quantity_attribute_name: "height_quantity",
      #       unit_attribute_name: "height_unit"
      #     },
      #     "weight" => {
      #       unit_group: UnitMeasurements::Length,
      #       quantity_attribute_name: "weight_quantity",
      #       unit_attribute_name: "weight_unit"
      #     }
      #   }
      #
      # @author {Harshal V. Ladhe}[https://shivam091.github.io/]
      # @since 1.2.0
      def measured_attributes
        @measured_attributes ||= {}
      end

      private

      # @!scope class
      # @private
      # Validates whether +unit_group+ is a subclass of +UnitMeasurements::Measurement+.
      #
      # @param [Class] unit_group The unit group class to be validated.
      #
      # @raise [BaseError]
      #   if +unit_group+ is not a subclass of +UnitMeasurements::Measurement+.
      #
      # @return [void]
      #
      # @author {Harshal V. Ladhe}[https://shivam091.github.io/]
      # @since 1.0.0
      def validate_unit_group!(unit_group)
        unless unit_group.is_a?(Class) && unit_group.ancestors.include?(Measurement)
          raise BaseError, "Expecting `#{unit_group}` to be a subclass of UnitMeasurements::Measurement"
        end
      end

      # @!scope class
      # @private
      # Defines the method to read the measured attribute.
      #
      # @param [String] measured_attr The name of the measured attribute.
      # @param [String] quantity_attr The name of the quantity attribute.
      # @param [String] unit_attr The name of the unit attribute.
      # @param [Class] unit_group The unit group class for the measurement.
      #
      # @return [void]
      #
      # @author {Harshal V. Ladhe}[https://shivam091.github.io/]
      # @since 1.0.0
      def define_reader_for_measured_attr(measured_attr, quantity_attr, unit_attr, unit_group)
        define_method(measured_attr) do
          quantity, unit = public_send(quantity_attr), public_send(unit_attr)

          begin
            unit_group.new(quantity, unit)
          rescue BlankQuantityError, BlankUnitError, ParseError, UnitError
            nil
          end
        end
      end

      # @!scope class
      # @private
      # Defines the method to write the measured attribute.
      #
      # @param [String] measured_attr The name of the measured attribute.
      # @param [String] quantity_attr The name of the quantity attribute.
      # @param [String] unit_attr The name of the unit attribute.
      # @param [Class] unit_group The unit group class for the measurement.
      #
      # @return [void]
      #
      # @author {Harshal V. Ladhe}[https://shivam091.github.io/]
      # @since 1.0.0
      def define_writer_for_measured_attr(measured_attr, quantity_attr, unit_attr, unit_group)
        define_method("#{measured_attr}=") do |measurement|
          if measurement.is_a?(unit_group)
            public_send("#{quantity_attr}=", measurement.quantity)
            public_send("#{unit_attr}=", measurement.unit.name)
          else
            public_send("#{quantity_attr}=", nil)
            public_send("#{unit_attr}=", nil)
          end
        end
      end

      # @!scope class
      # @private
      # Redefines the writer method to set the quantity attribute.
      #
      # @param quantity_attr [String] The name of the quantity attribute.
      #
      # @return [void]
      #
      # @author {Harshal V. Ladhe}[https://shivam091.github.io/]
      # @since 1.0.0
      def redefine_quantity_writer(quantity_attr)
        redefine_method("#{quantity_attr}=") do |quantity|
          quantity = BigDecimal(quantity, Float::DIG) if quantity.is_a?(String)
          if quantity
            db_column_props = self.column_for_attribute(quantity_attr)
            precision, scale = db_column_props.precision, db_column_props.scale

            quantity.round(scale)
          else
            nil
          end.tap { |value| write_attribute(quantity_attr, value) }
        end
      end

      # @!scope class
      # @private
      # Redefines the writer method to set the unit attribute.
      #
      # @param unit_attr [String] The name of the unit attribute.
      # @param unit_group [Class] The unit group class for the measurement.
      #
      # @return [void]
      #
      # @author {Harshal V. Ladhe}[https://shivam091.github.io/]
      # @since 1.0.0
      def redefine_unit_writer(unit_attr, unit_group)
        redefine_method("#{unit_attr}=") do |unit|
          unit_name = unit_group.unit_for(unit).try!(:name)
          write_attribute(unit_attr, (unit_name || unit))
        end
      end
    end
  end
end

# ActiveSupport hook to extend ActiveRecord with the `UnitMeasurements::Rails::ActiveRecord`
# module.
ActiveSupport.on_load(:active_record) do
  ::ActiveRecord::Base.send(:extend, UnitMeasurements::Rails::ActiveRecord)
end
