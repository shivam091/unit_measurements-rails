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
      # @param [Class or String] unit_group
      #   The unit group class or its name as a string.
      # @param [Symbol] attribute The name of the measurement attribute.
      #
      # @raise [BaseError]
      #   if +unit_group+ is not a subclass of +UnitMeasurements::Measurement+
      #   or instance of +Class+.
      #
      # @see BaseError
      # @author {Harshal V. Ladhe}[https://shivam091.github.io/]
      # @since 1.0.0
      def measured(unit_group, attribute)
        unit_group = unit_group.constantize if unit_group.is_a?(String)

        unless unit_group.is_a?(Class) && unit_group.ancestors.include?(Measurement)
          raise BaseError, "Expecting `#{unit_group}` to be a subclass of UnitMeasurements::Measurement"
        end

        quantity_attribute_name = "#{attribute}_quantity"
        unit_attribute_name = "#{attribute}_unit"

        # Reader to retrieve measurement object.
        define_method(attribute) do
          quantity, unit = public_send(quantity_attribute_name), public_send(unit_attribute_name)

          begin
            unit_group.new(quantity, unit)
          rescue BlankQuantityError, BlankUnitError, ParseError, UnitError => e
            nil
          end
        end

        # Writer to assign measurement object.
        define_method("#{attribute}=") do |measurement|
          if measurement.is_a?(unit_group)
            public_send("#{quantity_attribute_name}=", measurement.quantity)
            public_send("#{unit_attribute_name}=", measurement.unit.name)
          else
            public_send("#{quantity_attribute_name}=", nil)
            public_send("#{unit_attribute_name}=", nil)
          end
        end

        # Writer to override quantity assignment.
        redefine_method("#{quantity_attribute_name}=") do |quantity|
          quantity = BigDecimal(quantity, Float::DIG) if quantity.is_a?(String)
          quantity = if quantity
            db_column_props = self.column_for_attribute(quantity_attribute_name)
            precision, scale = db_column_props.precision, db_column_props.scale

            quantity.round(scale)
          else
            nil
          end

          write_attribute(quantity_attribute_name, quantity)
        end

        # Writer to override unit assignment.
        redefine_method("#{unit_attribute_name}=") do |unit|
          unit_name = unit_group.unit_group.unit_for(unit).try!(:name)

          write_attribute(unit_attribute_name, (unit_name || unit))
        end
      end
    end
  end
end

ActiveSupport.on_load(:active_record) do
  ::ActiveRecord::Base.send :extend, UnitMeasurements::Rails::ActiveRecord
end
