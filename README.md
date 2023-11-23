# Unit Measurements Rails

A Rails adaptor that encapsulate measurements and their units in Ruby on Rails.

[![Ruby](https://github.com/shivam091/unit_measurements-rails/actions/workflows/main.yml/badge.svg)](https://github.com/shivam091/unit_measurements-rails/actions/workflows/main.yml)
[![Gem Version](https://badge.fury.io/rb/unit_measurements-rails.svg)](https://badge.fury.io/rb/unit_measurements-rails)
[![Gem Downloads](https://img.shields.io/gem/dt/unit_measurements-rails.svg)](http://rubygems.org/gems/unit_measurements-rails)
[![Maintainability](https://api.codeclimate.com/v1/badges/b319a452f37addbc077b/maintainability)](https://codeclimate.com/github/shivam091/unit_measurements-rails/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/b319a452f37addbc077b/test_coverage)](https://codeclimate.com/github/shivam091/unit_measurements-rails/test_coverage)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](https://github.com/shivam091/unit_measurements-rails/blob/main/LICENSE.md)

[Harshal V. Ladhe, Master of Computer Science.](https://shivam091.github.io)

## Introduction

This gem is designed as a Rails integration for the [unit_measurements](https://github.com/shivam091/unit_measurements) gem.
It provides an `ActiveRecord` adapter for persisting and retrieving measurements
along with their units, simplifying complex measurement handling within your
Rails applications.


## Minimum Requirements

* Ruby 3.2+ ([Download Ruby](https://www.ruby-lang.org/en/downloads/branches/))
* Rails 7.0.0+ ([RubyGems - Rails Versions](https://rubygems.org/gems/rails/versions))

## Installation

To use `unit_measurements-rails` in your Rails application, add the following line to your Gemfile:

```ruby
gem "unit_measurements-rails"
```

And then execute:

`$ bundle install`

Or otherwise simply install it yourself as:

`$ gem install unit_measurements-rails`

## Usage

### ActiveRecord integration

This gem provides an ActiveRecord integration allowing you to declare measurement attributes with their corresponding units in your database schema:

```ruby
class CreateCubes < ActiveRecord::Migration[7.0]
  def change
    create_table :cubes do |t|
      # Define the columns for measurements
      t.decimal :length_quantity, precision: 10, scale: 2
      t.string :length_unit, limit: 12
      # ... additional columns for other measured attributes ...
      t.timestamps
    end
  end
end
```

Next, declare a column as measured with its associated unit group class:

```ruby
class Cube < ActiveRecord::Base
  measured UnitMeasurements::Length, :height
end
```

This setup allows you to access and assign measured attributes conveniently:

```ruby
cube = Cube.new
cube.height = UnitMeasurements::Length.new(5, "ft")
cube.height_quantity   #=> 0.5e1
cube.height_unit       #=> "ft"
cube.height            #=> 5.0 ft
```

Attribute names are expected to have the `_quantity` and `_unit` suffix, and be
`DECIMAL` and `VARCHAR` types, respectively, and defaults values are accepted.

You can customize the model's quantity and unit accessors by specifying them in the `quantity_attribute_name` and `unit_attribute_name` options, respectively.

```ruby
class CubeWithCustomAccessor < ActiveRecord::Base
  measured_length :length, unit_attribute_name: :length_uom
  measured_length :width, quantity_attribute_name: :width_value
  measured_length :height, quantity_attribute_name: :height_value, unit_attribute_name: :height_uom
end
```

For a more streamlined approach, predefined methods are available for commonly used types like `length`, `weight`, `area`, `volume`, etc.:

```ruby
class Package < ActiveRecord::Base
  measured_length :size
  measured_weight :item_weight, :package_weight
  measured_area :carpet_area
  measured_volume :total_volume
end
```

### Validations

`unit_measurements-rails` also provides validations to ensure the correctness of measurement attributes:

```ruby
class CubeWithValidation < ActiveRecord::Base
  measured_length :length

  validates :length, measured: true
end
```

These validations ensure that the unit is defined on the measurement and that a quantity exists.
Additionally, validations accept various options such as `message`, `units`, and comparison
operators like `greater_than`, `less_than`, etc.

All comparison validations require `UnitMeasurements::Measurement` values, not scalars.
Most of these options replace the `numericality` validator which compares the
measurement/method name/proc to the column's value. Validations can also be combined
with `presence` validator.

**Note:** Validations are strongly recommended since assigning an invalid unit
will cause the measurement to return `nil`, even if there is a quantity:

## Contributing

Contributions to this project are welcomed! To contribute:

1. Fork this repository
2. Create a new branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am "Add some feature`")
4. Push the changes to your branch (`git push origin my-new-feature`)
5. Create a new **Pull Request**

## License

Copyright 2023 [Harshal V. LADHE]((https://shivam091.github.io)), Released under the [MIT License](http://opensource.org/licenses/MIT).
