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
        # Prints the status of dependent cookbooks as a table
        #
        # @param dependencies [Array<Dependency>] list of cookbook dependency objects
        #
        def print(dependencies, type = 'table')
          if type == 'table'
            TableDisplay.print(dependencies)
          elsif type == 'json'
            JSONDisplay.print(dependencies)
          else
            raise UnsupportedDisplayTypeError, "Display type '#{type}' is not supported"
          end
        end
      end
    end

    class TableDisplay
      class << self
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

        def status_to_symbol_and_color(status)
          if status == 'up-to-date'
            return TICK_MARK, 'green'
          elsif status == 'out-of-date'
            return X_MARK, 'red'
          else
            return '', 'white'
          end
        end
      end
    end

    class JSONDisplay
      class << self
        def print(dependencies)
        end
      end
    end
  end
end
