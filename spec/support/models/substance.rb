# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Substance < ActiveRecord::Base
  measured UnitMeasurements::Density, :total_density

  measured_density :internal_density, :external_density
end
