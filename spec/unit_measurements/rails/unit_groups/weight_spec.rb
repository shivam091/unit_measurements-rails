# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/unit_measurements/rails/unit_groups/weight_spec.rb

RSpec.describe UnitMeasurements::Rails::ActiveRecord::Weight do
  include_examples "measured method", UnitMeasurements::Weight, :measured_weight
end
