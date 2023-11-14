# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

module UnitMeasurements
  module Rails
    # The +Railtie+ class for integrating +unit_measurements+ with the +Rails+
    # framework.
    #
    # This Railtie is designed to be automatically loaded by Rails when the
    # application starts. It can be used to configure and customize the behavior
    # of UnitMeasurements in a Rails application.
    #
    # @author {Harshal V. Ladhe}[https://shivam091.github.io/]
    # @since 0.1.0
    class Railtie < ::Rails::Railtie
      # (optional: add custom configuration, initialization, or other hooks)
    end
  end
end
