# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/unit_measurements/active_record_spec.rb

RSpec.describe UnitMeasurements::Rails::ActiveRecord do
  let(:height) { UnitMeasurements::Length.new(10, "cm") }
  let(:new_height) { UnitMeasurements::Length.new(20, "in") }

  let(:thing) { Thing.new(height: height) }

  describe "#measured" do
    it "raises an error if called with something that isn't a UnitMeasurements::Measurement" do
      expect {
        Thing.measured(Object, :field)
      }.to raise_error(UnitMeasurements::Rails::BaseError, "Expecting `Object` to be a subclass of UnitMeasurements::Measurement")
    end

    it "raises an error if called with something that isn't a class" do
      expect {
        Thing.measured(:not_correct, :field)
      }.to raise_error(UnitMeasurements::Rails::BaseError, "Expecting `not_correct` to be a subclass of UnitMeasurements::Measurement")
    end

    it "defines attribute methods" do
      expect(thing).to respond_to(:height)
      expect(thing).to respond_to(:height=)
    end

    describe "when retrieve and assign operations are performed" do
      it "correctly sets and gets the measured attribute" do
        height_measurement = UnitMeasurements::Length.new(5, "meters")
        thing.height = height_measurement

        expect(thing.height).to eq(height_measurement)
      end

      it "correctly sets and gets the unit attribute" do
        unit_value = "m"
        thing.height_unit = unit_value

        expect(thing.height_unit).to eq(unit_value)
      end

      it "handles invalid values" do
        thing.height = "invalid_value"

        expect(thing.height).to be_nil
      end

      it "correctly sets measured attribute with proper rounding" do
        height_measurement = UnitMeasurements::Length.new(5.6789, "meters")
        thing.height = height_measurement

        expect(thing.height.quantity).to eq(5.68)
      end

      it "handles nil measurement" do
        thing.height = nil

        expect(thing.height).to be_nil
      end

      it "handles nil *_unit attribute" do
        thing.height_unit = nil

        expect(thing.height_unit).to be_nil
      end

      it "sets the attribute to nil if it is an incompatible object" do
        thing.height = Object.new

        expect(thing.height).to be_nil
      end

      it "deals when only the *_quantity attribute is set" do
        thing = Thing.new
        thing.height_quantity = 23

        expect(thing.height).to be_nil
      end

      it "deals when only the *_unit attribute is set" do
        thing = Thing.new
        thing.height_unit = "cm"

        expect(thing.height).to be_nil
      end

      it "deals with nil-ing out the *_quantity attribute" do
        thing.height_quantity = nil

        expect(thing.height).to be_nil
      end

      it "deals with nil-ing out the *_unit attribute" do
        thing.height_unit = nil

        expect(thing.height).to be_nil
      end

      it "returns nil measurement object when assigned an invalid value to the *_unit attribute" do
        thing.height_unit = "invalid"

        expect(thing.height).to be_nil
        expect(thing.height_unit).to eq("invalid")
      end

      it "creates an instance from the *_quantity and *_unit attribute" do
        thing = Thing.new
        thing.height_quantity = 23
        thing.height_unit = "ft"

        expect(thing.height).to eq(UnitMeasurements::Length.new(23, "ft"))
      end

      it "assigns a valid value to the *_unit attribute" do
        thing.height_unit = "mm"

        expect(thing.height).to eq(UnitMeasurements::Length.new(10, "mm"))
        expect(thing.height_unit).to eq("mm")
      end

      it "builds a new measurement object from the *_quantity and *_unit attributes" do
        thing = Thing.new(height_quantity: "30", height_unit: "m")

        expect(thing.height).to eq(UnitMeasurements::Length.new(30, "m"))
      end

      it "assigns the properties when a new object is built with a measurement object" do
        thing = Thing.new(height: new_height)

        expect(thing.height).to eq(new_height)
        expect(thing.height_quantity).to eq(20)
        expect(thing.height_unit).to eq("in")
      end

      it "assigns nil values for the *_quantity and *_unit attributes" do
        thing.height = nil

        expect(thing.height).to be_nil
        expect(thing.height_quantity).to be_nil
        expect(thing.height_unit).to be_nil
      end

      it "leaves the *_quantity attribute unchanged when only *_unit attribute is set" do
        thing.height_unit = "in"

        expect(thing.height).to eq(UnitMeasurements::Length.new(10, "in"))
      end

      it "leaves the *_unit attribute unchanged when only *_quantity attribute is set" do
        thing.height_quantity = "10"

        expect(thing.height).to eq(UnitMeasurements::Length.new(10, "cm"))
      end

      it "does not raise an error when assigning invalid value to the *_unit" do
        thing.height_quantity = 123
        thing.height_unit = :invalid

        expect(thing.height).to be_nil
      end
    end

    context "when save operation is performed" do
      it "persists the attributes and retrieves the measurement object" do
        thing = Thing.new(height: UnitMeasurements::Length.new(3, "m"))

        expect(thing.save).to be_truthy
        expect(thing.height_quantity).to eq(3)
        expect(thing.height_unit).to eq("m")

        thing.reload

        expect(thing.height_quantity).to eq(3)
        expect(thing.height_unit).to eq("m")
      end

      it "saves if assigned an invalid unit and there is no validation" do
        thing = Thing.new(height_quantity: "100", height_unit: :invalid)

        expect(thing.save).to be_truthy

        thing.reload

        expect(thing.height).to be_nil
        expect(thing.height_quantity).to eq(100)
      end
    end

    context "when update operation is performed" do
      context "when assigned attributes" do
        it "updates the measured object" do
          thing.attributes = {height_quantity: "30", height_unit: "m"}

          expect(thing.height).to eq(UnitMeasurements::Length.new(30, "m"))
        end
      end

      context "when assigned partial attributes" do
        it "updates the measured object" do
          thing.attributes = {height_quantity: "30"}

          expect(thing.height).to eq(UnitMeasurements::Length.new(30, "cm"))
        end
      end

      it "updates only the *_quantity attribute" do
        thing = Thing.create!

        expect(thing.update(height_quantity: "314")).to be_truthy
        expect(thing.height_quantity).to eq(314)

        thing.reload

        expect(thing.height_quantity).to eq(314)
        expect(thing.height).to be_nil
      end

      it "updates only the *_unit attribute" do
        thing = Thing.create!

        expect(thing.update(height_unit: :cm)).to be_truthy
        expect(thing.height_unit).to eq("cm")

        thing.reload

        expect(thing.height_unit).to eq("cm")
        expect(thing.height).to be_nil
      end

      it "updates *_quantity attribute first and then the *_unit attribute" do
        thing = Thing.create!

        expect(thing.update(height_quantity: 11.1)).to be_truthy
        expect(thing.height).to be_nil

        expect(thing.update(height_unit: "cm")).to be_truthy
        expect(thing.height).to eq(UnitMeasurements::Length.new(11.1, "cm"))
      end

      it "updates *_unit attribute first and then the *_quantity attribute" do
        thing = Thing.create!

        expect(thing.update(height_unit: "inch")).to be_truthy
        expect(thing.height).to be_nil

        expect(thing.update(height_quantity: "314")).to be_truthy
        expect(thing.height).to eq(UnitMeasurements::Length.new(314, "in"))
      end

      it "updates *_quantity and *_unit attributes" do
        thing = Thing.create!

        expect(thing.update(height_unit: "cm", height_quantity: 2)).to be_truthy
        expect(thing.height).to eq(UnitMeasurements::Length.new(2, "cm"))

        thing.reload

        expect(thing.height).to eq(UnitMeasurements::Length.new(2, "cm"))
      end

      it "updates *_unit attribute and converts it" do
        thing = Thing.create!

        expect(thing.update(height_unit: "inch")).to be_truthy
        expect(thing.height_unit).to eq("in")

        thing.reload

        expect(thing.height_unit).to eq("in")
      end

      it "updates *_unit attribute to something invalid" do
        thing = Thing.create!

        expect(thing.update(height_unit: :invalid)).to be_truthy
        expect(thing.height_unit).to eq("invalid")

        thing.reload

        expect(thing.height_unit).to eq("invalid")
        expect(thing.height).to be_nil
      end

      it "modifies only the *_quantity attribute" do
        expect(thing.update(height_quantity: 2)).to be_truthy
        expect(thing.height).to eq(UnitMeasurements::Length.new(2, "cm"))

        thing.reload

        expect(thing.height).to eq(UnitMeasurements::Length.new(2, "cm"))
      end

      it "modifies only the *_unit attribute" do
        expect(thing.update(height_unit: "foot")).to be_truthy
        expect(thing.height).to eq(UnitMeasurements::Length.new(10, "ft"))

        thing.reload

        expect(thing.height).to eq(UnitMeasurements::Length.new(10, "ft"))
      end

      it "modifies the *_unit attribute to something invalid" do
        expect(thing.update(height_unit: :invalid)).to be_truthy
        expect(thing.height).to be_nil
        expect(thing.height_unit).to eq("invalid")

        thing.reload

        expect(thing.height).to be_nil
        expect(thing.height_unit).to eq("invalid")
      end

      it "modifies both the *_quantity and *_unit attributes" do
        expect(thing.update(height_unit: "mm", height_quantity: 1.23)).to be_truthy
        expect(thing.height).to eq(UnitMeasurements::Length.new(1.23, "mm"))

        thing.reload

        expect(thing.height).to eq(UnitMeasurements::Length.new(1.23, "mm"))
      end

      it "assigns the *_quantity value with a BigDecimal rounded to the attribute's rounding scale" do
        thing.height = UnitMeasurements::Length.new(BigDecimal("23.4567891"), "mm")

        expect(thing.height_quantity).to eq(BigDecimal("23.46"))
      end

      it "assigns the *_quantity value with a Float that uses all the rounding scale permissible" do
        thing.height = UnitMeasurements::Length.new(4.45678912, "mm")

        expect(thing.height_quantity).to eq(BigDecimal("4.46"))
      end

      context "when assigned a number with more significant digits than permitted by the column precision" do
        it "does not raise exception when it can be rounded to have lesser significant digits per column's scale" do
          expect {
            thing.height = UnitMeasurements::Length.new(4.45678912123123123, "mm")

            expect(thing.height_quantity).to eq(BigDecimal("4.46"))
          }.to_not raise_error
        end
      end
    end
  end
end
