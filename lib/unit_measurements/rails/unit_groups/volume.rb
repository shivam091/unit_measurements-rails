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
  extend ActiveSupport::Concern

  # @!method measured_volume(*measured_attrs)
  # Defines _volume-measured_ attributes in the +ActiveRecord+ model.
  #
  # This method serves as a wrapper around the +measured+ method and allows easy
  # definition of volume-measured attributes by accepting an array of attribute
  # names.
  #
  # @param [Array<String|Symbol>] measured_attrs
  #   An array of the names of volume-measured attributes.
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
  # @see #measured
  # @author {Harshal V. Ladhe}[https://shivam091.github.io/]
  # @since 1.1.0
  class_methods do
    def measured_volume(*measured_attrs)
      measured(UnitMeasurements::Volume, *measured_attrs)
    end
  end
end

# ActiveSupport hook to extend ActiveRecord with the `UnitMeasurements::Rails::ActiveRecord::Volume` module.
ActiveSupport.on_load(:active_record) do
  ::ActiveRecord::Base.send(:include, UnitMeasurements::Rails::ActiveRecord::Volume)
end
