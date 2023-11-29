# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/unit_measurements/rails/measured_validator_spec.rb

RSpec.describe MeasuredValidator do
  let(:cube) do
    CubeWithValidation.new(
      length: UnitMeasurements::Length.new(1, "m"),
      length_true: UnitMeasurements::Length.new(2, "cm"),
      length_presence: UnitMeasurements::Length.new(6, "m"),
      length_unit_singular: UnitMeasurements::Length.new(5, "ft"),
      length_units_multiple: UnitMeasurements::Length.new(4, "m"),
      length_message: UnitMeasurements::Length.new(3, "mm"),
      length_message_from_block: UnitMeasurements::Length.new(7, "mm"),
      length_numericality_inclusive: UnitMeasurements::Length.new(15, "in"),
      length_numericality_exclusive: UnitMeasurements::Length.new(4, "m"),
      length_numericality_equality: UnitMeasurements::Length.new(100, "cm")
    )
  end

  let(:cube_with_custom_accessors) do
    CubeWithCustomAccessor.new(
      length: UnitMeasurements::Length.new(1, "m"),
      width: UnitMeasurements::Length.new(2, "cm"),
      height: UnitMeasurements::Length.new(6, "m")
    )
  end

  let(:length_units) { ["m", "meter", "cm", "mm", "millimeter", "in", "ft", "feet", "yd"] }

  describe "#validate_each" do
    context "with default attribute accessors" do
      it "does not raise validation if all attributes are valid" do
        expect(cube).to be_valid
      end

      it "correctly handles presence validation on measured attributes" do
        cube.length_presence = nil
        expect(cube).to be_invalid
        expect(cube.errors[:length_presence]).to include("can't be blank")

        cube.length_presence_unit = "m"
        expect(cube).to be_invalid

        cube.length_presence_quantity = "3"
        expect(cube).to be_valid
      end

      it "does not raise validation if attribute is present" do
        expect(CubeWithValidation.new(length_presence: UnitMeasurements::Length.new(4, :in))).to be_valid
      end

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

      it "does not raise validation if unit is valid" do
        length_units.each do |unit|
          cube.length_unit = unit
          expect(cube).to be_valid

          cube.length_unit = unit.to_sym
          expect(cube).to be_valid

          cube.length = UnitMeasurements::Length.new(123, unit)
          expect(cube).to be_valid
        end
      end

      it "does not raise validation if unit is set in any format" do
        cube.length_units_multiple_unit = :m
        expect(cube).to be_valid

        cube.length_units_multiple_unit = :cm
        expect(cube).to be_valid

        cube.length_units_multiple_unit = "cm"
        expect(cube).to be_valid

        cube.length_units_multiple_unit = "meter"
        expect(cube).to be_valid

        cube.length_units_multiple = UnitMeasurements::Length.new(3, :cm)
        expect(cube).to be_valid

        cube.length_units_multiple_unit = :mm
        expect(cube).to be_invalid

        cube.length_units_multiple = UnitMeasurements::Length.new(3, :ft)
        expect(cube).to be_invalid
      end

      it "supports validation message as a static string" do
        cube.length_message_unit = "invalid"

        expect(cube).to be_invalid
        expect(cube.errors[:length_message]).to include("has a custom failure message")
      end

      it "overrides validation message with a block" do
        cube.length_message_from_block_unit = "junk"

        expect(cube).to be_invalid
        expect(cube.errors[:length_message_from_block]).to include("junk is not a valid unit")
      end

      it "accepts the single unit using :units" do
        cube.length_unit_singular_unit = :ft
        expect(cube).to be_valid

        cube.length_unit_singular_unit = "feet"
        expect(cube).to be_valid

        cube.length_unit_singular_unit = :mm
        expect(cube).to be_invalid

        cube.length_unit_singular_unit = "meter"
        expect(cube).to be_invalid
      end

      it "raises validation if singular unit if not from :units" do
        cube.length_unit_singular_unit = :mm

        expect(cube).to be_invalid
        expect(cube.errors[:length_unit_singular]).to include("custom message")
      end

      it "raises validation if if unit is not supported by default and is not custom supported" do
        cube.length_unit_singular_unit = :t

        expect(cube).to be_invalid
        expect(cube.errors[:length_unit_singular]).to include("custom message")
      end

      it "does not raise validation if unit is from :units" do
        cube.length_units_multiple_unit = :m

        expect(cube).to be_valid
        expect(cube.errors[:length_units_multiple]).to be_empty
      end

      it "raises validation if unit is not from :units" do
        cube.length_units_multiple_unit = :mm

        expect(cube).to be_invalid
        expect(cube.errors[:length_units_multiple]).to include("is not included within list")
      end

      it "checks numericality comparisons against Measurement subclass" do
        cube.length_invalid_comparison = UnitMeasurements::Length.new(30, "in")

        expect {
          cube.valid?
        }.to raise_error(ArgumentError, ":not_a_measured_subclass must be either Numeric or Measurement")
      end

      it "checks numericality comparisons :greater_than" do
        cube.length_numericality_exclusive = UnitMeasurements::Length.new(4, "m")

        expect(cube).to be_valid
      end

      it "checks numericality comparisons :less_than" do
        cube.length_numericality_exclusive = UnitMeasurements::Length.new(1, "m")

        expect(cube).to be_invalid
      end

      it "checks numericality comparisons :greater_than_or_equal_to" do
        cube.length_numericality_inclusive = UnitMeasurements::Length.new(10, "in")

        expect(cube).to be_valid
      end

      it "checks numericality comparisons :less_than_or_equal_to" do
        cube.length_numericality_exclusive = UnitMeasurements::Length.new(3, "m")

        expect(cube).to be_invalid
      end

      it "checks numericality comparisons :equal_to and can use procs to look up values" do
        cube.length_numericality_equality = UnitMeasurements::Length.new(100, "cm")
        expect(cube).to be_valid

        cube.length_numericality_equality = UnitMeasurements::Length.new(1, "m")
        expect(cube).to be_valid

        cube.length_numericality_equality = UnitMeasurements::Length.new("99.9", "cm")
        expect(cube).to be_invalid
        expect(cube.errors[:length_numericality_equality]).to include("must be exactly 100cm")

        cube.length_numericality_equality = UnitMeasurements::Length.new(101, "cm")
        expect(cube).to be_invalid
        expect(cube.errors[:length_numericality_equality]).to include("must be exactly 100cm")
      end

      it "uses a default invalid validation message for numericality comparisons" do
        cube.length_numericality_inclusive = UnitMeasurements::Length.new(30, :in)
        expect(cube).to be_invalid
        expect(cube.errors[:length_numericality_inclusive]).to include("30.0 in must be less than or equal to 20 in")

        cube.length_numericality_inclusive = UnitMeasurements::Length.new(1, :mm)
        expect(cube).to be_invalid
        expect(cube.errors[:length_numericality_inclusive]).to include("1.0 mm must be greater than or equal to 10 in")
      end

      it "uses a custom validation message for numericality comparisons" do
        cube.length_numericality_exclusive = UnitMeasurements::Length.new(2, :m)
        expect(cube).to be_invalid
        expect(cube.errors[:length_numericality_exclusive]).to include("is not ok")

        cube.length_numericality_exclusive = UnitMeasurements::Length.new(6000, :mm)
        expect(cube).to be_invalid
        expect(cube.errors[:length_numericality_exclusive]).to include("is not ok")
      end

      it "does not raise validation if valid unit is set but no quantity" do
        cube.length_numericality_exclusive_quantity = nil
        cube.length_numericality_exclusive_unit = "cm"

        expect(cube).to be_valid
      end

      it "raises validation if quantity is set but no unit" do
        cube.length_numericality_exclusive_quantity = 1
        cube.length_numericality_exclusive_unit = nil

        expect(cube).to be_invalid
      end
    end

    context "with custom attribute accessors" do
      it "does not raise validation if all attributes are valid" do
        expect(cube_with_custom_accessors).to be_valid
      end

      it "raises validation if valid quantity and no unit" do
        cube_with_custom_accessors.length_uom = ""

        expected_errors_hash = {
          length: ["does not have valid unit"],
        }

        expect(cube_with_custom_accessors).to be_invalid
        expect(cube_with_custom_accessors.errors.to_hash).to eq(expected_errors_hash)
      end

      it "does not raise validation if valid unit and no quantity" do
        cube_with_custom_accessors.length_quantity = nil

        expect(cube_with_custom_accessors).to be_valid
      end
    end
  end
end
