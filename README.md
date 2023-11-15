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

This gem is the Rails integration for the [unit_measurements](https://github.com/shivam091/unit_measurements) gem.
It provides ActiveRecord adapter for persisting and retrieving measurements with their units.

## Minimum Requirements

* Ruby 3.2+ (https://www.ruby-lang.org/en/downloads/branches/)
* Rails 7.0.0+ (https://rubygems.org/gems/rails/versions)

## Installation

If using bundler, first add this line to your application's Gemfile:

```ruby
gem "unit_measurements-rails"
```

And then execute:

`$ bundle install`

Or otherwise simply install it yourself as:

`$ gem install unit_measurements-rails`

## Usage

### ActiveRecord

Attribute names are expected to have the `_quantity` and `_unit` suffix, and be `DECIMAL` and `VARCHAR` types, respectively, and defaults values are accepted.

```ruby
class CreateTableCubes < ActiveRecord::Migration[7.0]
  def change
    create_table :cubes do |t|
      t.decimal :length_quantity, precision: 10, scale: 2
      t.string :length_unit, limit: 12
      t.decimal :width_quantity, precision: 10, scale: 2
      t.string :width_unit, limit: 12
      t.decimal :height_quantity, precision: 10, scale: 2
      t.string :height_unit, limit: 12
      t.timestamps
    end
  end
end
```

A column can be declared as a measured with its unit group class:

```ruby
class Cube < ActiveRecord::Base
  measured UnitMeasurements::Length, :height
end
```

This will allow you to access and assign a measured attribute:

```ruby
cube = Cube.new
cube.height = UnitMeasurements::Length.new(5, "ft")
cube.height_quantity   #=> 0.5e1
cube.height_unit       #=> "ft"
cube.height            #=> 5.0 ft
```

Order of assignment does not matter, and each attribute can be assigned separately
and with mass assignment:

```ruby
params = {height_quantity: "3", height_unit: "ft"}
cube = Cube.new(params)
cube.height            #=> 3.0 ft
```

You can specify multiple measured attributes at a time:

```ruby
class Land < ActiveRecord::Base
  measured UnitMeasurements::Area, :carpet_area, :buildup_area
end
```

There are some simpler methods for predefined types:

```ruby
class Package < ActiveRecord::Base
  measured_length :size
  measured_weight :item_weight, :package_weight
  measured_area :carpet_area
  measured_volume :total_volume
end
```

This will allow you to access and assign a measurement object:

```ruby
package = Package.new
package.item_weight = UnitMeasurements::Weight.new(10, "g")
package.item_weight_unit       #=> "g"
package.item_weight_value      #=> 10
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am "Add some feature"`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

Copyright 2023 [Harshal V. LADHE]((https://shivam091.github.io)), Released under the [MIT License](http://opensource.org/licenses/MIT).
