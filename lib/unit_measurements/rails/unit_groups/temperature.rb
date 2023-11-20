# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# The +UnitMeasurements::Rails::ActiveRecord::Temperature+ module provides a convenient
# way to define temperature-measured attributes in +ActiveRecord+ models.
#
# It acts as a wrapper for the +measured+ method, simplifying the definition of
# temperature-measured attributes without directly invoking the +measured+ method.
#
# @author {Harshal V. Ladhe}[https://shivam091.github.io/]
# @since 1.3.0
module UnitMeasurements::Rails::ActiveRecord::Temperature
  # @!scope class
  # Defines _temperature-measured_ attributes in the +ActiveRecord+ model.
  #
  # This method serves as a wrapper around the +measured+ method and allows easy
  # definition of temperature-measured attributes by accepting an array of attribute
  # names along with their options.
  #
  # @param [Array<String|Symbol>] measured_attrs
  #   An array of the names of temperature-measured attributes.
  # @param [Hash] options A customizable set of options
  # @option options [String|Symbol] :quantity_attribute_name The name of the quantity attribute.
  # @option options [String|Symbol] :unit_attribute_name The name of the unit attribute.
  #
  # @example Define single temperature-measured attribute:
  #   class WeatherReport < ActiveRecord::Base
  #     measured_temperature :average_temperature
  #   end
  #
  # @example Define multiple temperature-measured attributes:
  #   class WeatherReport < ActiveRecord::Base
  #     measured_temperature :day_temperature, :night_temperature
  #   end
  #
  # @return [void]
  #
  # @see .measured
  # @author {Harshal V. Ladhe}[https://shivam091.github.io/]
  # @since 1.3.0
  def measured_temperature(*measured_attrs, **options)
    measured(UnitMeasurements::Temperature, *measured_attrs, **options)
  end
end

# ActiveSupport hook to extend ActiveRecord with the `UnitMeasurements::Rails::ActiveRecord::Temperature` module.
ActiveSupport.on_load(:active_record) do
  ::ActiveRecord::Base.send(:extend, UnitMeasurements::Rails::ActiveRecord::Temperature)
end
