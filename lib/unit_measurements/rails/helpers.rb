# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

module UnitMeasurements
  module Rails
    # The +UnitMeasurements::Rails::Helpers+ module provides helper methods for
    # handling +ActiveRecord+ models in the context of unit measurements.
    #
    # @author {Harshal V. Ladhe}[https://shivam091.github.io/]
    # @since 1.5.0
    module Helpers
      # Checks the existence of a +column_name+ within the database table
      # associated with the +ActiveRecord+ model.
      #
      # @param [String] column_name The name of the column to check for existence.
      #
      # @raise [ArgumentError]
      #   If the specified column does not exist in the database table.
      #
      # @example Check if the +height_quantity+ column exists in the database table:
      #   column_exists?("height_quantity")
      #
      # @return [void]
      #
      # @author {Harshal V. Ladhe}[https://shivam091.github.io/]
      # @since 1.5.0
      def column_exists?(column_name)
        unless self.class.column_names.include?(column_name)
          raise ArgumentError, "Column '#{column_name}' does not exist in the database for table '#{self.class.table_name}'."
        end
      end
    end
  end
end

# ActiveSupport hook to include ActiveRecord with the `UnitMeasurements::Rails::Helpers`
# module.
ActiveSupport.on_load(:active_record) do
  ::ActiveRecord::Base.send(:include, UnitMeasurements::Rails::Helpers)
end
