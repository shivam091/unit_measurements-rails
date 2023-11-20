# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# The +UnitMeasurements::Rails::ActiveRecord::Time+ module provides a convenient
# way to define time-measured attributes in +ActiveRecord+ models.
#
# It acts as a wrapper for the +measured+ method, simplifying the definition of
# time-measured attributes without directly invoking the +measured+ method.
#
# @author {Harshal V. Ladhe}[https://shivam091.github.io/]
# @since 1.3.0
module UnitMeasurements::Rails::ActiveRecord::Time
  # @!scope class
  # Defines _time-measured_ attributes in the +ActiveRecord+ model.
  #
  # This method serves as a wrapper around the +measured+ method and allows easy
  # definition of time-measured attributes by accepting an array of attribute
  # names along with their options.
  #
  # @param [Array<String|Symbol>] measured_attrs
  #   An array of the names of time-measured attributes.
  # @param [Hash] options A customizable set of options
  # @option options [String|Symbol] :quantity_attribute_name The name of the quantity attribute.
  # @option options [String|Symbol] :unit_attribute_name The name of the unit attribute.
  #
  # @example Define single time-measured attribute:
  #   class ProjectTimeline < ActiveRecord::Base
  #     measured_time :duration
  #   end
  #
  # @example Define multiple time-measured attributes:
  #   class ProjectTimeline < ActiveRecord::Base
  #     measured_time :setup_time, :processing_time
  #   end
  #
  # @return [void]
  #
  # @see .measured
  # @author {Harshal V. Ladhe}[https://shivam091.github.io/]
  # @since 1.3.0
  def measured_time(*measured_attrs, **options)
    measured(UnitMeasurements::Time, *measured_attrs, **options)
  end
end

# ActiveSupport hook to extend ActiveRecord with the `UnitMeasurements::Rails::ActiveRecord::Time` module.
ActiveSupport.on_load(:active_record) do
  ::ActiveRecord::Base.send(:extend, UnitMeasurements::Rails::ActiveRecord::Time)
end
