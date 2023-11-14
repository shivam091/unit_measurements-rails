# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Thing < ActiveRecord::Base
  measured UnitMeasurements::Length, :height
end
