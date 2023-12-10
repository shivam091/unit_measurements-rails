# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/unit_measurements/shared_examples.rb

RSpec.shared_examples "measured method" do |unit_group, method_name|
  let!(:mock_model) { Class.new(ActiveRecord::Base) }

  it "responds to .#{method_name}" do
    expect(mock_model).to respond_to(method_name)
  end

  describe ".#{method_name}" do
    it "defines single measurement attribute" do
      mock_model.public_send(method_name, :attribute)

      expect_attribute_definition("attribute", unit_group, "attribute_quantity", "attribute_unit")
    end

    it "defines multiple measurement attributes" do
      mock_model.public_send(method_name, :attribute1, :attribute2)

      expect_attribute_definition("attribute1", unit_group, "attribute1_quantity", "attribute1_unit")
      expect_attribute_definition("attribute2", unit_group, "attribute2_quantity", "attribute2_unit")
    end

    it "accepts string or symbol for measurement attribute name" do
      mock_model.public_send(method_name, "string_attr", :symbol_attr)

      expect_attribute_definition("string_attr", unit_group, "string_attr_quantity", "string_attr_unit")
      expect_attribute_definition("symbol_attr", unit_group, "symbol_attr_quantity", "symbol_attr_unit")
    end

    it "accepts quantity_attribute_name and unit_attribute_name options" do
      mock_model.public_send(method_name, :attribute1, quantity_attribute_name: :custom_quantity, unit_attribute_name: :custom_unit)

      expect_attribute_definition("attribute1", unit_group, "custom_quantity", "custom_unit")
    end

    it "accepts string or symbol for quantity_attribute_name and unit_attribute_name options" do
      mock_model.public_send(method_name, :attribute1, quantity_attribute_name: "custom_quantity", unit_attribute_name: :custom_unit)

      expect_attribute_definition("attribute1", unit_group, "custom_quantity", "custom_unit")
    end

    it "allows using both quantity_attribute_name and unit_attribute_name options simultaneously" do
      mock_model.public_send(method_name, :attribute1, quantity_attribute_name: :custom_quantity, unit_attribute_name: :custom_unit)

      expect_attribute_definition("attribute1", unit_group, "custom_quantity", "custom_unit")
    end
  end

  private

  def expect_attribute_definition(attribute, unit_group, quantity_attribute_name, unit_attribute_name)
    expect(mock_model.measured_attributes).to have_key(attribute)

    attribute_info = mock_model.measured_attributes[attribute]

    expect(attribute_info[:unit_group]).to eq(unit_group)
    expect(attribute_info[:quantity_attribute_name]).to eq(quantity_attribute_name)
    expect(attribute_info[:unit_attribute_name]).to eq(unit_attribute_name)
  end
end
