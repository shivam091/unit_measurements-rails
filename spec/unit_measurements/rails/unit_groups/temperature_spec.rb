# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/unit_measurements/rails/unit_groups/temperature_spec.rb

RSpec.describe UnitMeasurements::Rails::ActiveRecord::Temperature do
  include_examples "measured method", UnitMeasurements::Temperature, :measured_temperature
end
