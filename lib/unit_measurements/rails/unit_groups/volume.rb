# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# The +UnitMeasurements::Rails::ActiveRecord::Volume+ module provides a convenient
# way to define volume-measured attributes in +ActiveRecord+ models.
#
# It acts as a wrapper for the +measured+ method, simplifying the definition of
# volume-measured attributes without directly invoking the +measured+ method.
#
# @author {Harshal V. Ladhe}[https://shivam091.github.io/]
# @since 1.1.0
module UnitMeasurements::Rails::ActiveRecord::Volume
  # @!scope class
  # Defines _volume-measured_ attributes in the +ActiveRecord+ model.
  #
  # This method serves as a wrapper around the +measured+ method and allows easy
  # definition of volume-measured attributes by accepting an array of attribute
  # names along with their options.
  #
  # @param [Array<String|Symbol>] measured_attrs
  #   An array of the names of volume-measured attributes.
  # @param [Hash] options A customizable set of options
  # @option options [String|Symbol] :quantity_attribute_name The name of the quantity attribute.
  # @option options [String|Symbol] :unit_attribute_name The name of the unit attribute.
  #
  # @example Define single volume-measured attribute:
  #   class Container < ActiveRecord::Base
  #     measured_volume :total_volume
  #   end
  #
  # @example Define multiple volume-measured attributes:
  #   class Container < ActiveRecord::Base
  #     measured_volume :internal_volume, :external_volume
  #   end
  #
  # @return [void]
  #
  # @see .measured
  # @author {Harshal V. Ladhe}[https://shivam091.github.io/]
  # @since 1.1.0
  def measured_volume(*measured_attrs, **options)
    measured(UnitMeasurements::Volume, *measured_attrs, **options)
  end
end

# ActiveSupport hook to extend ActiveRecord with the `UnitMeasurements::Rails::ActiveRecord::Volume` module.
ActiveSupport.on_load(:active_record) do
  ::ActiveRecord::Base.send(:extend, UnitMeasurements::Rails::ActiveRecord::Volume)
end
