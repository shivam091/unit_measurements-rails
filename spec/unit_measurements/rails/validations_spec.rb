# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/unit_measurements/rails/validations_spec.rb

require "byebug"

RSpec.describe MeasuredValidator do
  let(:cube) do
    ValidatedCube.new(
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

  context "with default attribute accessors" do
    it "is valid when all attributes are valid" do
      expect(cube).to be_valid
    end

    it "does not raise validation when attribute is present" do
      expect(ValidatedCube.new(length_presence: UnitMeasurements::Length.new(4, :in))).to be_valid
    end

    it "raises validation when unit is nil" do
      cube.length_unit = nil

      expect(cube).to be_invalid
      expect(cube.errors.full_messages_for(:length)).to include("Length is not a valid unit")
    end

    it "raises validation when unit is invalid" do
      cube.length_unit = "invalid"

      expect(cube).to be_invalid
      expect(cube.errors.full_messages_for(:length)).to include("Length is not a valid unit")
    end

    it "supports the message as a static string" do
      cube.length_message_unit = "invalid"

      expect(cube).to be_invalid
      expect(cube.errors.full_messages_for(:length_message)).to include("Length message has a custom failure message")
    end

    it "overrides the message with a block" do
      cube.length_message_from_block_unit = "junk"

      expect(cube).to be_invalid
      expect(cube.errors.full_messages_for(:length_message_from_block)).to include("Length message from block junk is not a valid unit")
    end

    it "accepts any valid unit" do
      length_units.each do |unit|
        cube.length_unit = unit
        expect(cube).to be_valid

        cube.length_unit = unit.to_s
        expect(cube).to be_valid

        cube.length = UnitMeasurements::Length.new(123, unit)
        expect(cube).to be_valid
      end
    end

    it "accepts a list of units in any format as an option and only allows them to be valid" do
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

    it "accepts the single unit" do
      cube.length_unit_singular_unit = :ft
      expect(cube).to be_valid

      cube.length_unit_singular_unit = "feet"
      expect(cube).to be_valid

      cube.length_unit_singular_unit = :mm
      expect(cube).to be_invalid

      cube.length_unit_singular_unit = "meter"
      expect(cube).to be_invalid
    end

    it "fails if only only the quantity is set" do
      cube.length_unit = nil

      expect(cube).to be_invalid
    end

    context "when unit is from specified units" do
      it "does not raise validation" do
        cube.length_units_multiple_unit = :m

        expect(cube).to be_valid
        expect(cube.errors.full_messages_for(:length_units_multiple)).to be_empty
      end
    end

    context "when unit is not from specified units" do
      it "raises validation" do
        cube.length_units_multiple_unit = :mm

        expect(cube).to be_invalid
        expect(cube.errors.full_messages_for(:length_units_multiple)).to include("Length units multiple is not a valid unit")
      end
    end
  end

  context "with custom attribute accessors" do
    # it "raises validation with custom unit with nil value" do
    #   cube_with_custom_accessors.length_uom = ""
    #   expect(cube_with_custom_accessors.valid?).to be_falsy
    #
    #   expected_errors_hash = {
    #     length: ["is not a valid unit"],
    #     width:  ["is not a valid unit"],
    #     height: ["is not a valid unit"],
    #   }
    #
    #   expect(cube_with_custom_accessors.errors.to_hash).to eq(expected_errors_hash)
    # end
  end
end
