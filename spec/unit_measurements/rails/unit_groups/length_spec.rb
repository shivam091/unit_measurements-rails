# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/unit_measurements/rails/unit_groups/length_spec.rb

RSpec.describe UnitMeasurements::Rails::ActiveRecord::Length do
  include_examples "measured method", UnitMeasurements::Length, :measured_length
end
