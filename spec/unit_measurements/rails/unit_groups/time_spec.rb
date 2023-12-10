# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/unit_measurements/rails/unit_groups/time_spec.rb

RSpec.describe UnitMeasurements::Rails::ActiveRecord::Time do
  include_examples "measured method", UnitMeasurements::Time, :measured_time
end
