#
# Copyright (c) 2013 Kannan Manickam <me@arangamani.net>
#
# MIT License
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

require 'chef/taste'

module Chef
  module Taste
    # Displays the status of the dependency cookbooks
    #
    class Display
      class << self
        # Prints the status of dependent cookbooks in specified format
        #
        # @param dependencies [Array<Dependency>] list of cookbook dependency objects
        # @param format [String] the format used for display
        #
        def print(dependencies, format)
          case format
          when 'table'
            TableDisplay.print(dependencies)
          when'json'
            JSONDisplay.print(dependencies)
          else
            raise UnsupportedDisplayFormatError, "Display format '#{format}' is not supported"
          end
        end
      end
    end

    # Displays the cookbook dependency status in a table format
    #
    class TableDisplay
      class << self
        # Prints the status of dependent cookbooks as a table
        #
        # @param dependencies [Array<Dependency>] list of cookbook dependency objects
        #
        def print(dependencies)
          rows = []
          headings = %w(Name Requirement Used Latest Status Changelog)
          dependencies.each do |dependency|
            status_symbol, color = status_to_symbol_and_color(dependency.status)
            rows << [
              dependency.name,
              dependency.requirement,
              dependency.version_used,
              dependency.latest,
              { value: status_symbol.send(color), alignment: :center },
              dependency.changelog
            ]
          end

          # If any of the cookbook is out-of-date
          table = Terminal::Table.new headings: headings, rows: rows
          puts table
          if dependencies.any? { |dep| dep.status == 'out-of-date' }
            puts "Status: out-of-date ( #{X_MARK} )".red
          else
            puts "Status: up-to-date ( #{TICK_MARK} )".green
          end
        end

        # Given the status of the cookbook, this method will convert it to the unicode symbol
        # and color. The up-to-date cookbook will receive a green color TICK mark whereas
        # the out-of-date cookbook will receive a red color 'X' mark.
        #
        # @param status [String] the status of the cookbook
        #
        # @return [String, String] status symbol and color
        #
        def status_to_symbol_and_color(status)
          case status
          when 'up-to-date'
            return TICK_MARK, 'green'
          when'out-of-date'
            return X_MARK, 'red'
          else
            return '', 'white'
          end
        end
      end
    end

    # Displays the cookbook dependency status in JSON format
    #
    class JSONDisplay
      class << self
        # Prints the status of dependent in JSON
        #
        # @param dependencies [Array<Dependency>] list of cookbook dependency objects
        #
        def print(dependencies)
          puts JSON.pretty_generate(dependencies_hash(dependencies))
        end

        # Converts the dependency objects to JSON object
        #
        # @param dependencies [Array<Dependency>] list of cookbook dependency objects
        #
        def dependencies_hash(dependencies)
          {}.tap do |hash|
            dependencies.each do |dependency|
              hash[dependency.name] = dependency.to_hash
            end
          end
        end
      end
    end
  end
end
