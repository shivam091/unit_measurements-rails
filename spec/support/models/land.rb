# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Land < ActiveRecord::Base
  measured UnitMeasurements::Area, :total_area

  measured_area :carpet_area, :buildup_area
end
