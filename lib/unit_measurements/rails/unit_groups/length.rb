# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# The +UnitMeasurements::Rails::ActiveRecord::Length+ module provides a convenient
# way to define length measured attributes in +ActiveRecord+ models.
#
# @author {Harshal V. Ladhe}[https://shivam091.github.io/]
# @since 1.1.0
module UnitMeasurements::Rails::ActiveRecord::Length
  # Defines a length measured attributes in the +ActiveRecord+ model.
  #
  # This method is a convenient wrapper for the +measured+ method, allowing you
  # to easily define length measured attributes without invoking it directly.
  #
  # @param [Array<String|Symbol>] measurement_attrs
  #   An array of the names of length measurement attributes.
  #
  # @example Define single length measured attribute:
  #   class Thing < ActiveRecord::Base
  #     measured_length :height
  #   end
  #
  # @example Define multiple length measured attributes:
  #   class Thing < ActiveRecord::Base
  #     measured_length :length, :width
  #   end
  #
  # @return [void]
  #
  # @see #measured
  # @author {Harshal V. Ladhe}[https://shivam091.github.io/]
  # @since 1.1.0
  def measured_length(*measurement_attrs)
    measured(UnitMeasurements::Length, *measurement_attrs)
  end
end

# ActiveSupport hook to extend ActiveRecord with the `UnitMeasurements::Rails::ActiveRecord::Length` module.
ActiveSupport.on_load(:active_record) do
  ::ActiveRecord::Base.send :extend, UnitMeasurements::Rails::ActiveRecord::Length
end
