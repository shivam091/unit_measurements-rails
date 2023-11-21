# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/unit_measurements/rails/active_record_spec.rb

RSpec.describe UnitMeasurements::Rails::ActiveRecord do
  let(:length) { UnitMeasurements::Length.new(10, "ft") }
  let(:width) { UnitMeasurements::Length.new(5, "ft") }
  let(:height) { UnitMeasurements::Length.new(10, "cm") }
  let(:new_height) { UnitMeasurements::Length.new(20, "in") }

  let(:cube) { Cube.new(height: height) }
  let(:cube_with_custom_accessors) { CubeWithCustomAccessor.new(length: length, width: width, height: height) }

  describe ".measured" do
    it "raises an error if called with something that isn't a UnitMeasurements::Measurement" do
      expect {
        Cube.measured(Object, :field)
      }.to raise_error(UnitMeasurements::Rails::BaseError, "Expecting `Object` to be a subclass of UnitMeasurements::Measurement")
    end

    it "raises an error if called with something that isn't a class" do
      expect {
        Cube.measured(:not_correct, :field)
      }.to raise_error(UnitMeasurements::Rails::BaseError, "Expecting `not_correct` to be a subclass of UnitMeasurements::Measurement")
    end

    it "defines attribute methods" do
      expect(cube).to respond_to(:height)
      expect(cube).to respond_to(:height=)
    end

    it "raises if you attempt to define a field twice" do
      expect {
        Cube.measured UnitMeasurements::Length, :height
      }.to raise_error(UnitMeasurements::Rails::BaseError, "The field 'height' has already been measured.")
    end

    describe "when retrieve and assign operations are performed" do
      it "correctly sets and gets the measured attribute" do
        height_measurement = UnitMeasurements::Length.new(5, "meters")
        cube.height = height_measurement

        expect(cube.height).to eq(height_measurement)
      end

      it "correctly sets and gets the unit attribute" do
        unit_value = "m"
        cube.height_unit = unit_value

        expect(cube.height_unit).to eq(unit_value)
      end

      it "handles invalid values" do
        cube.height = "invalid_value"

        expect(cube.height).to be_nil
      end

      it "correctly sets measured attribute with proper rounding" do
        height_measurement = UnitMeasurements::Length.new(5.6789, "meters")
        cube.height = height_measurement

        expect(cube.height.quantity).to eq(5.68)
      end

      it "handles nil measurement" do
        cube.height = nil

        expect(cube.height).to be_nil
      end

      it "handles nil *_unit attribute" do
        cube.height_unit = nil

        expect(cube.height_unit).to be_nil
      end

      it "sets the attribute to nil if it is an incompatible object" do
        cube.height = Object.new

        expect(cube.height).to be_nil
      end

      it "deals when only the *_quantity attribute is set" do
        cube = Cube.new
        cube.height_quantity = 23

        expect(cube.height).to be_nil
      end

      it "deals when only the *_unit attribute is set" do
        cube = Cube.new
        cube.height_unit = "cm"

        expect(cube.height).to be_nil
      end

      it "deals with nil-ing out the *_quantity attribute" do
        cube.height_quantity = nil

        expect(cube.height).to be_nil
      end

      it "deals with nil-ing out the *_unit attribute" do
        cube.height_unit = nil

        expect(cube.height).to be_nil
      end

      it "returns nil measurement object when assigned an invalid value to the *_unit attribute" do
        cube.height_unit = "invalid"

        expect(cube.height).to be_nil
        expect(cube.height_unit).to eq("invalid")
      end

      it "creates an instance from the *_quantity and *_unit attribute" do
        cube = Cube.new
        cube.height_quantity = 23
        cube.height_unit = "ft"

        expect(cube.height).to eq(UnitMeasurements::Length.new(23, "ft"))
      end

      it "assigns a valid value to the *_unit attribute" do
        cube.height_unit = "mm"

        expect(cube.height).to eq(UnitMeasurements::Length.new(10, "mm"))
        expect(cube.height_unit).to eq("mm")
      end

      it "builds a new measurement object from the *_quantity and *_unit attributes" do
        cube = Cube.new(height_quantity: "30", height_unit: "m")

        expect(cube.height).to eq(UnitMeasurements::Length.new(30, "m"))
      end

      it "assigns the properties when a new object is built with a measurement object" do
        cube = Cube.new(height: new_height)

        expect(cube.height).to eq(new_height)
        expect(cube.height_quantity).to eq(20)
        expect(cube.height_unit).to eq("in")
      end

      it "assigns nil values for the *_quantity and *_unit attributes" do
        cube.height = nil

        expect(cube.height).to be_nil
        expect(cube.height_quantity).to be_nil
        expect(cube.height_unit).to be_nil
      end

      it "leaves the *_quantity attribute unchanged when only *_unit attribute is set" do
        cube.height_unit = "in"

        expect(cube.height).to eq(UnitMeasurements::Length.new(10, "in"))
      end

      it "leaves the *_unit attribute unchanged when only *_quantity attribute is set" do
        cube.height_quantity = "10"

        expect(cube.height).to eq(UnitMeasurements::Length.new(10, "cm"))
      end

      it "does not raise an error when assigning invalid value to the *_unit" do
        cube.height_quantity = 123
        cube.height_unit = :invalid

        expect(cube.height).to be_nil
      end
    end

    context "when save operation is performed" do
      it "persists the attributes and retrieves the measurement object" do
        cube = Cube.new(height: UnitMeasurements::Length.new(3, "m"))

        expect(cube.save).to be_truthy
        expect(cube.height_quantity).to eq(3)
        expect(cube.height_unit).to eq("m")

        cube.reload

        expect(cube.height_quantity).to eq(3)
        expect(cube.height_unit).to eq("m")
      end

      it "saves if assigned an invalid unit and there is no validation" do
        cube = Cube.new(height_quantity: "100", height_unit: :invalid)

        expect(cube.save).to be_truthy

        cube.reload

        expect(cube.height).to be_nil
        expect(cube.height_quantity).to eq(100)
      end
    end

    context "when update operation is performed" do
      context "when assigned attributes" do
        it "updates the measured object" do
          cube.attributes = {height_quantity: "30", height_unit: "m"}

          expect(cube.height).to eq(UnitMeasurements::Length.new(30, "m"))
        end
      end

      context "when assigned partial attributes" do
        it "updates the measured object" do
          cube.attributes = {height_quantity: "30"}

          expect(cube.height).to eq(UnitMeasurements::Length.new(30, "cm"))
        end
      end

      it "updates only the *_quantity attribute" do
        cube = Cube.create!

        expect(cube.update(height_quantity: "314")).to be_truthy
        expect(cube.height_quantity).to eq(314)

        cube.reload

        expect(cube.height_quantity).to eq(314)
        expect(cube.height).to be_nil
      end

      it "updates only the *_unit attribute" do
        cube = Cube.create!

        expect(cube.update(height_unit: :cm)).to be_truthy
        expect(cube.height_unit).to eq("cm")

        cube.reload

        expect(cube.height_unit).to eq("cm")
        expect(cube.height).to be_nil
      end

      it "updates *_quantity attribute first and then the *_unit attribute" do
        cube = Cube.create!

        expect(cube.update(height_quantity: 11.1)).to be_truthy
        expect(cube.height).to be_nil

        expect(cube.update(height_unit: "cm")).to be_truthy
        expect(cube.height).to eq(UnitMeasurements::Length.new(11.1, "cm"))
      end

      it "updates *_unit attribute first and then the *_quantity attribute" do
        cube = Cube.create!

        expect(cube.update(height_unit: "inch")).to be_truthy
        expect(cube.height).to be_nil

        expect(cube.update(height_quantity: "314")).to be_truthy
        expect(cube.height).to eq(UnitMeasurements::Length.new(314, "in"))
      end

      it "updates *_quantity and *_unit attributes" do
        cube = Cube.create!

        expect(cube.update(height_unit: "cm", height_quantity: 2)).to be_truthy
        expect(cube.height).to eq(UnitMeasurements::Length.new(2, "cm"))

        cube.reload

        expect(cube.height).to eq(UnitMeasurements::Length.new(2, "cm"))
      end

      it "updates *_unit attribute and converts it" do
        cube = Cube.create!

        expect(cube.update(height_unit: "inch")).to be_truthy
        expect(cube.height_unit).to eq("in")

        cube.reload

        expect(cube.height_unit).to eq("in")
      end

      it "updates *_unit attribute to something invalid" do
        cube = Cube.create!

        expect(cube.update(height_unit: :invalid)).to be_truthy
        expect(cube.height_unit).to eq("invalid")

        cube.reload

        expect(cube.height_unit).to eq("invalid")
        expect(cube.height).to be_nil
      end

      it "modifies only the *_quantity attribute" do
        expect(cube.update(height_quantity: 2)).to be_truthy
        expect(cube.height).to eq(UnitMeasurements::Length.new(2, "cm"))

        cube.reload

        expect(cube.height).to eq(UnitMeasurements::Length.new(2, "cm"))
      end

      it "modifies only the *_unit attribute" do
        expect(cube.update(height_unit: "foot")).to be_truthy
        expect(cube.height).to eq(UnitMeasurements::Length.new(10, "ft"))

        cube.reload

        expect(cube.height).to eq(UnitMeasurements::Length.new(10, "ft"))
      end

      it "modifies the *_unit attribute to something invalid" do
        expect(cube.update(height_unit: :invalid)).to be_truthy
        expect(cube.height).to be_nil
        expect(cube.height_unit).to eq("invalid")

        cube.reload

        expect(cube.height).to be_nil
        expect(cube.height_unit).to eq("invalid")
      end

      it "modifies both the *_quantity and *_unit attributes" do
        expect(cube.update(height_unit: "mm", height_quantity: 1.23)).to be_truthy
        expect(cube.height).to eq(UnitMeasurements::Length.new(1.23, "mm"))

        cube.reload

        expect(cube.height).to eq(UnitMeasurements::Length.new(1.23, "mm"))
      end

      it "assigns the *_quantity value with a BigDecimal rounded to the attribute's rounding scale" do
        cube.height = UnitMeasurements::Length.new(BigDecimal("23.4567891"), "mm")

        expect(cube.height_quantity).to eq(BigDecimal("23.46"))
      end

      it "assigns the *_quantity value with a Float that uses all the rounding scale permissible" do
        cube.height = UnitMeasurements::Length.new(4.45678912, "mm")

        expect(cube.height_quantity).to eq(BigDecimal("4.46"))
      end

      context "when assigned a number with more significant digits than permitted by the column precision" do
        it "does not raise exception when it can be rounded to have lesser significant digits per column's scale" do
          expect {
            cube.height = UnitMeasurements::Length.new(4.45678912123123123, "mm")

            expect(cube.height_quantity).to eq(BigDecimal("4.46"))
          }.to_not raise_error
        end
      end
    end

    context "using custom *_quantity and *_unit accessors" do
      it "works correctly with custom *_quantity accessors" do
        expect(cube_with_custom_accessors.length).to eq(UnitMeasurements::Length.new(10, "ft"))
        expect(cube_with_custom_accessors.width).to eq(UnitMeasurements::Length.new(5, "ft"))
        expect(cube_with_custom_accessors.height).to eq(UnitMeasurements::Length.new(10, "cm"))
      end

      it "works correctly with custom *_unit accessors" do
        expect(cube_with_custom_accessors.length).to eq(UnitMeasurements::Length.new(10, "ft"))
        expect(cube_with_custom_accessors.width).to eq(UnitMeasurements::Length.new(5, "ft"))
        expect(cube_with_custom_accessors.height).to eq(UnitMeasurements::Length.new(10, "cm"))
      end
    end
  end

  describe ".measured_attributes" do
    it "returns the configuration for all measured fields on the class" do
      expected = {
        "length" => {unit_group: UnitMeasurements::Length, quantity_attribute_name: "length_quantity", unit_attribute_name: "length_unit"},
        "width" => {unit_group: UnitMeasurements::Length, quantity_attribute_name: "width_quantity", unit_attribute_name: "width_unit"},
        "height" => {unit_group: UnitMeasurements::Length, quantity_attribute_name: "height_quantity", unit_attribute_name: "height_unit"}
      }

      expect(Cube.measured_attributes).to eq(expected)
    end
  end
end
