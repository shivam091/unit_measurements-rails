# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# The +UnitMeasurements::Rails::ActiveRecord::Area+ module provides a convenient
# way to define area-measured attributes in +ActiveRecord+ models.
#
# It acts as a wrapper for the +measured+ method, simplifying the definition of
# area-measured attributes without directly invoking the +measured+ method.
#
# @author {Harshal V. Ladhe}[https://shivam091.github.io/]
# @since 1.1.0
module UnitMeasurements::Rails::ActiveRecord::Area
  # @!scope class
  # Defines _area-measured_ attributes in the +ActiveRecord+ model.
  #
  # This method serves as a wrapper around the +measured+ method and allows easy
  # definition of area-measured attributes by accepting an array of attribute
  # names.
  #
  # @param [Array<String|Symbol>] measured_attrs
  #   An array of the names of area-measured attributes.
  # @param [Hash] options A customizable set of options
  # @option options [String|Symbol] :quantity_attribute_name The name of the quantity attribute.
  # @option options [String|Symbol] :unit_attribute_name The name of the unit attribute.
  #
  # @example Define single area-measured attribute:
  #   class Land < ActiveRecord::Base
  #     measured_area :total_area
  #   end
  #
  # @example Define multiple area-measured attributes:
  #   class Land < ActiveRecord::Base
  #     measured_area :carpet_area, :buildup_area
  #   end
  #
  # @return [void]
  #
  # @see .measured
  # @author {Harshal V. Ladhe}[https://shivam091.github.io/]
  # @since 1.1.0
  def measured_area(*measured_attrs, **options)
    measured(UnitMeasurements::Area, *measured_attrs, **options)
  end
end

# ActiveSupport hook to extend ActiveRecord with the `UnitMeasurements::Rails::ActiveRecord::Area` module.
ActiveSupport.on_load(:active_record) do
  ::ActiveRecord::Base.send(:extend, UnitMeasurements::Rails::ActiveRecord::Area)
end
