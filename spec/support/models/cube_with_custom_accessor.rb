# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class CubeWithCustomAccessor < ActiveRecord::Base
  measured_length :length, unit_attribute_name: :length_uom
  measured_length :width, quantity_attribute_name: :width_value

  measured UnitMeasurements::Length, :height, quantity_attribute_name: :height_value, unit_attribute_name: :height_uom
end
