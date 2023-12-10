# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/unit_measurements/rails/unit_groups/density_spec.rb

RSpec.describe UnitMeasurements::Rails::ActiveRecord::Density do
  include_examples "measured method", UnitMeasurements::Density, :measured_density
end
