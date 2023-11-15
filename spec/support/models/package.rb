# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Package < ActiveRecord::Base
  measured UnitMeasurements::Weight, :total_weight

  measured_weight :item_weight, :package_weight
end
