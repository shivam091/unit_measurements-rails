# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

module UnitMeasurements
  module Rails
    # The +UnitMeasurements::Rails::ActiveRecord+ module enhances ActiveRecord
    # models by providing a convenient way to handle unit measurements. It allows
    # you to define measurement attributes in your models with support for
    # specific unit groups.
    #
    # @author {Harshal V. Ladhe}[https://shivam091.github.io/]
    # @since 1.0.0
    module ActiveRecord
      # Defines a measurement attribute in the +ActiveRecord+ model.
      #
      # @example Defining measured attributes:
      #   class Thing < ActiveRecord::Base
      #     measured UnitMeasurements::Length, :height
      #   end
      #
      # @param [Class|String] unit_group
      #   The unit group class or its name as a string.
      # @param [String|Symbol] measurement_attr
      #   The name of the measurement attribute.
      # @return [void]
      #
      # @raise [BaseError]
      #   if +unit_group+ is not a subclass of +UnitMeasurements::Measurement+
      #   or instance of +Class+.
      #
      # @see BaseError
      # @author {Harshal V. Ladhe}[https://shivam091.github.io/]
      # @since 1.0.0
      def measured(unit_group, measurement_attr)
        unit_group = unit_group.constantize if unit_group.is_a?(String)

        validate_unit_group!(unit_group)

        quantity_attr = "#{measurement_attr}_quantity"
        unit_attr = "#{measurement_attr}_unit"

        define_measurement_reader(measurement_attr, quantity_attr, unit_attr, unit_group)
        define_measurement_writer(measurement_attr, quantity_attr, unit_attr, unit_group)
        redefine_quantity_writer(quantity_attr)
        redefine_unit_writer(unit_attr, unit_group)
      end

      private

      def validate_unit_group!(unit_group)
        unless unit_group.is_a?(Class) && unit_group.ancestors.include?(Measurement)
          raise BaseError, "Expecting `#{unit_group}` to be a subclass of UnitMeasurements::Measurement"
        end
      end

      def define_measurement_reader(measurement_attr, quantity_attr, unit_attr, unit_group)
        define_method(measurement_attr) do
          quantity, unit = public_send(quantity_attr), public_send(unit_attr)

          begin
            unit_group.new(quantity, unit)
          rescue BlankQuantityError, BlankUnitError, ParseError, UnitError
            nil
          end
        end
      end

      def define_measurement_writer(measurement_attr, quantity_attr, unit_attr, unit_group)
        define_method("#{measurement_attr}=") do |measurement|
          if measurement.is_a?(unit_group)
            public_send("#{quantity_attr}=", measurement.quantity)
            public_send("#{unit_attr}=", measurement.unit.name)
          else
            public_send("#{quantity_attr}=", nil)
            public_send("#{unit_attr}=", nil)
          end
        end
      end

      def redefine_quantity_writer(quantity_attr)
        redefine_method("#{quantity_attr}=") do |quantity|
          quantity = BigDecimal(quantity, Float::DIG) if quantity.is_a?(String)
          quantity = if quantity
            db_column_props = self.column_for_attribute(quantity_attr)
            precision, scale = db_column_props.precision, db_column_props.scale

            quantity.round(scale)
          else
            nil
          end

          write_attribute(quantity_attr, quantity)
        end
      end

      def redefine_unit_writer(unit_attr, unit_group)
        redefine_method("#{unit_attr}=") do |unit|
          unit_name = unit_group.unit_group.unit_for(unit).try!(:name)
          write_attribute(unit_attr, (unit_name || unit))
        end
      end
    end
  end
end

ActiveSupport.on_load(:active_record) do
  ::ActiveRecord::Base.send :extend, UnitMeasurements::Rails::ActiveRecord
end
