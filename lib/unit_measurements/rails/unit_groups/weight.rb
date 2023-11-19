# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# The +UnitMeasurements::Rails::ActiveRecord::Weight+ module provides a convenient
# way to define weight-measured attributes in +ActiveRecord+ models.
#
# It acts as a wrapper for the +measured+ method, simplifying the definition of
# weight-measured attributes without directly invoking the +measured+ method.
#
# @author {Harshal V. Ladhe}[https://shivam091.github.io/]
# @since 1.1.0
module UnitMeasurements::Rails::ActiveRecord::Weight
  # @!scope class
  # Defines _weight-measured_ attributes in the +ActiveRecord+ model.
  #
  # This method serves as a wrapper around the +measured+ method and allows easy
  # definition of weight-measured attributes by accepting an array of attribute
  # names.
  #
  # @param [Array<String|Symbol>] measured_attrs
  #   An array of the names of weight-measured attributes.
  #
  # @example Define single weight-measured attribute:
  #   class Package < ActiveRecord::Base
  #     measured_weight :total_weight
  #   end
  #
  # @example Define multiple weight-measured attributes:
  #   class Package < ActiveRecord::Base
  #     measured_weight :item_weight, :package_weight
  #   end
  #
  # @return [void]
  #
  # @see .measured
  # @author {Harshal V. Ladhe}[https://shivam091.github.io/]
  # @since 1.1.0
  def measured_weight(*measured_attrs)
    measured(UnitMeasurements::Weight, *measured_attrs)
  end
end

# ActiveSupport hook to extend ActiveRecord with the `UnitMeasurements::Rails::ActiveRecord::Weight` module.
ActiveSupport.on_load(:active_record) do
  ::ActiveRecord::Base.send(:extend, UnitMeasurements::Rails::ActiveRecord::Weight)
end
