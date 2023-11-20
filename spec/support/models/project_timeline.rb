# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class ProjectTimeline < ActiveRecord::Base
  measured UnitMeasurements::Time, :duration

  measured_time :setup_time, :processing_time
end
