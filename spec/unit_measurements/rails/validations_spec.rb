# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/unit_measurements/rails/validations_spec.rb

RSpec.describe MeasuredValidator do
  let(:length) { UnitMeasurements::Length.new(10, "ft") }
  let(:width) { UnitMeasurements::Length.new(5, "ft") }
  let(:height) { UnitMeasurements::Length.new(10, "cm") }
  let(:new_height) { UnitMeasurements::Length.new(20, "in") }

  let(:cube) { Cube.new(length: length, width: width, height: height) }

  it "is valid" do
     expect(cube.valid?).to be_truthy
  end

  it "leaves a model valid and deals with blank unit" do
    expect(ValidatedCube.new(length_presence: UnitMeasurements::Length.new(4, :in)).valid?).to be_truthy
  end
end
