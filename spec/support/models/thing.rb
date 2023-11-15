# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Thing < ActiveRecord::Base
  measured UnitMeasurements::Length, :height
  measured UnitMeasurements::Weight, :total_weight, :extra_weight

  measured_length :length, :width
  measured_weight :item_weight, :package_weight
end
