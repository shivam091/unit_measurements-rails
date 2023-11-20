# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class WeatherReport < ActiveRecord::Base
  measured UnitMeasurements::Temperature, :average_temperature

  measured_temperature :day_temperature, :night_temperature
end
