# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/unit_measurements/rails/unit_groups/area_spec.rb

RSpec.describe UnitMeasurements::Rails::ActiveRecord::Area do
  include_examples "measured method", UnitMeasurements::Area, :measured_area
end
