# Chef::Taste

[![Gem Version](http://img.shields.io/gem/v/chef-taste.svg)][gem]
[![Build Status](http://img.shields.io/travis/arangamani/chef-taste.svg)][travis]
[![Dependency Status](http://img.shields.io/gemnasium/arangamani/chef-taste.svg)][gemnasium]
[![Code Climate](http://img.shields.io/codeclimate/github/arangamani/chef-taste.svg)][codeclimate]

[gem]: https://rubygems.org/gems/chef-taste
[travis]: http://travis-ci.org/arangamani/chef-taste
[gemnasium]: https://gemnasium.com/arangamani/chef-taste
[codeclimate]: https://codeclimate.com/github/arangamani/chef-taste

Chef Taste is a simple command line utility to check a cookbook's dependency status.
It will list the dependent cookbooks in a tabular format with the version information,
status, and the changelog (if possible) for out-of-date cookbooks.

## Installation

Add this line to your application's Gemfile:

    gem 'chef-taste'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install chef-taste

## Usage

When you are inside the cookbooks directory, simply type `taste` to taste the cookbook.
The `metadata.rb` of the cookbook is parsed to obtain the dependencies. It will display
a table that contains the following rows:

* `Name` - The name of the cookbook
* `Requirement` - The version requirement specified in the metadata
* `Used` - The final version used based on the requirement constraint
* `Latest` - The latest version available in the community site
* `Status` - The status of the cookbook: up-to-date (a green tick mark) or out-of-date (a red x mark)
* `Changelog` - The changelog of out-of-date cookbooks if available.

The overall status will also be displayed in the bottom of the table.

### Changelog
Most of the cookbooks are hosted in Github and are tagged for every release.
The changelog is computed by obtaining the source URL provided in the community site and
finding the tags being used and the latest tag and displaying a compare view that
compares these two tags. This URL is then shortened using goo.gl URL shortener to fit the table.

The details are obtained only for cookbooks available in the community site. Other cookbooks are
displayed but will simply be empty in the details column.

### Display Format

Two display formats are supported: table and json

1. The table format will display the dependency status as an ASCII table
2. The json format will display the dependency status as a JSON object

### Examples

These examples are based on the cookbooks available in the `test/cookbooks` directory
in this repository.

#### 1. fried_rice cookbook

```bash
kannanmanickam@mac fried_rice$ taste
+------------+-------------+--------+--------+--------+----------------------+
| Name       | Requirement | Used   | Latest | Status | Changelog            |
+------------+-------------+--------+--------+--------+----------------------+
| ntp        | ~> 1.4.0    | 1.4.0  | 1.5.0  |   ✖    | http://goo.gl/qsfgwA |
| swap       | = 0.3.5     | 0.3.5  | 0.3.6  |   ✖    | http://goo.gl/vZtUQJ |
| windows    | >= 0.0.0    | 1.11.0 | 1.11.0 |   ✔    |                      |
| awesome_cb | >= 0.0.0    |        |        |        |                      |
+------------+-------------+--------+--------+--------+----------------------+
Status: out-of-date ( ✖ )
```

#### 2. noodles cookbook

```bash
kannanmanickam@mac noodles$ taste --format json
{
  "mysql": {
    "requirement": "~> 3.0.12",
    "used": "3.0.12",
    "latest": "4.0.4",
    "status": "out-of-date",
    "changelog": "http://goo.gl/e1nBfW"
  },
  "apache2": {
    "requirement": "~> 1.7.0",
    "used": "1.7.0",
    "latest": "1.8.4",
    "status": "out-of-date",
    "changelog": "http://goo.gl/9ejcpi"
  },
  "windows": {
    "requirement": ">= 0.0.0",
    "used": "1.11.0",
    "latest": "1.11.0",
    "status": "up-to-date",
    "changelog": null
  }
}
```

#### 3. curry cookbook

```bash
kannanmanickam@mac curry$ taste --format table
+-----------------+-------------+-------+--------+--------+-----------+
| Name            | Requirement | Used  | Latest | Status | Changelog |
+-----------------+-------------+-------+--------+--------+-----------+
| ntp             | >= 0.0.0    | 1.5.0 | 1.5.0  |   ✔    |           |
| lvm             | >= 0.0.0    | 1.0.0 | 1.0.0  |   ✔    |           |
| application     | >= 0.0.0    | 4.1.0 | 4.1.0  |   ✔    |           |
| application_php | >= 0.0.0    | 2.0.0 | 2.0.0  |   ✔    |           |
+-----------------+-------------+-------+--------+--------+-----------+
Status: up-to-date ( ✔ )
```

#### 4. water cookbook

```bash
kannanmanickam@mac water$ taste
No dependent cookbooks
```


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/arangamani/chef-taste/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

