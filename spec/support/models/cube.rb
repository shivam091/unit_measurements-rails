# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Cube < ActiveRecord::Base
  measured UnitMeasurements::Length, :length, :width

  measured_length :height
end
