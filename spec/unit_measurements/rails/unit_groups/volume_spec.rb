# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/unit_measurements/rails/unit_groups/volume_spec.rb

RSpec.describe UnitMeasurements::Rails::ActiveRecord::Volume do
  include_examples "measured method", UnitMeasurements::Volume, :measured_volume
end
