# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class ValidatedCube < ActiveRecord::Base
  measured_length :length
  validates :length, measured: true

  measured_length :length_true
  validates :length_true, measured: true

  measured_length :length_presence
  validates :length_presence, measured: true, presence: true
end
