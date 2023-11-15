# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Container < ActiveRecord::Base
  measured UnitMeasurements::Volume, :total_volume

  measured_volume :internal_volume, :external_volume
end
