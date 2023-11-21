# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

require "unit_measurements/rails/version"
require "unit_measurements"

require "active_support/all"
require "active_record"
require "active_model"
require "active_model/validations"

module UnitMeasurements
  # The +UnitMeasurements::Rails+ integrates the
  # {unit_measurements}[https://github.com/shivam091/unit_measurements]
  # gem into Ruby on Rails applications.
  #
  # It integrates +unit_measurements+ into Ruby on Rails applications, encompassing
  # modules and classes for ActiveRecord support, Railties, and custom errors.
  #
  # @see ActiveRecord
  # @see Railtie
  # @see BaseError
  # @author {Harshal V. Ladhe}[https://shivam091.github.io/]
  # @since 0.2.0
  module Rails
    # This class serves as the base for custom errors within the +UnitMeasurements::Rails+
    # module.
    #
    # @author {Harshal V. Ladhe}[https://shivam091.github.io/]
    # @since 0.2.0
    class BaseError < StandardError; end
  end
end

require "unit_measurements/rails/active_record"
require "unit_measurements/rails/measured_validator"

require "unit_measurements/rails/railtie" if defined?(Rails)
