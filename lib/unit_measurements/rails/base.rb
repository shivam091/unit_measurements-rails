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
  module Rails
    class BaseError < StandardError; end
  end
end

if defined?(Rails)
  require "unit_measurements/rails/railtie"
end
