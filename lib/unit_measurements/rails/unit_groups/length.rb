# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# The +UnitMeasurements::Rails::ActiveRecord::Length+ module provides a convenient
# way to define length-measured attributes in +ActiveRecord+ models.
#
# It acts as a wrapper for the +measured+ method, simplifying the definition of
# length-measured attributes without directly invoking the +measured+ method.
#
# @author {Harshal V. Ladhe}[https://shivam091.github.io/]
# @since 1.1.0
module UnitMeasurements::Rails::ActiveRecord::Length
  # @!scope class
  # Defines _length-measured_ attributes in the +ActiveRecord+ model.
  #
  # This method serves as a wrapper around the +measured+ method and allows easy
  # definition of length-measured attributes by accepting an array of attribute
  # names along with their options.
  #
  # @param [Array<String|Symbol>] measured_attrs
  #   An array of the names of length-measured attributes.
  # @param [Hash] options A customizable set of options
  # @option options [String|Symbol] :quantity_attribute_name The name of the quantity attribute.
  # @option options [String|Symbol] :unit_attribute_name The name of the unit attribute.
  #
  # @example Define single length-measured attribute:
  #   class Cube < ActiveRecord::Base
  #     measured_length :length
  #   end
  #
  # @example Define multiple length-measured attributes:
  #   class Cube < ActiveRecord::Base
  #     measured_length :height, :width
  #   end
  #
  # @return [void]
  #
  # @see .measured
  # @author {Harshal V. Ladhe}[https://shivam091.github.io/]
  # @since 1.1.0
  def measured_length(*measured_attrs, **options)
    measured(UnitMeasurements::Length, *measured_attrs, **options)
  end
end

# ActiveSupport hook to extend ActiveRecord with the `UnitMeasurements::Rails::ActiveRecord::Length` module.
ActiveSupport.on_load(:active_record) do
  ::ActiveRecord::Base.send(:extend, UnitMeasurements::Rails::ActiveRecord::Length)
end
