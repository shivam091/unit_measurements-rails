# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/unit_measurements/rails/measured_validator_spec.rb

RSpec.describe MeasuredValidator do
  let(:cube) do
    CubeWithValidation.new(
      length: UnitMeasurements::Length.new(1, "m")
    )
  end

  let(:length_units) { ["m", "meter", "cm", "mm", "millimeter", "in", "ft", "feet", "yd"] }

  describe "#validate_each" do
    context "with default attribute accessors" do
      it "raises validation if unit is nil" do
        cube.length_unit = nil

        expect(cube).to be_invalid
        expect(cube.errors[:length]).to include("does not have valid unit")
      end

      it "raises validation if unit is invalid" do
        cube.length_unit = "invalid"

        expect(cube).to be_invalid
        expect(cube.errors[:length]).to include("does not have valid unit")
      end
    end
  end
end
