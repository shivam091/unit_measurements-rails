# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class CubeWithValidation < ActiveRecord::Base
  measured_length :length
  validates :length, measured: true
end
