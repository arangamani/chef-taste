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
        def print(dependencies)
          if dependencies.empty?
            puts "No dependent cookbooks"
          else
            rows = []
            headings = [
              'Name',
              'Requirement',
              'Used',
              'Latest',
              'Status',
              'Changelog'
            ]
            dependencies.each do |dependency|
              color =
                if dependency.status == TICK_MARK
                  'green'
                elsif dependency.status == X_MARK
                  'red'
                else
                  'white'
                end
              rows << [
                dependency.name,
                dependency.requirement,
                dependency.version_used,
                dependency.latest,
                {:value => dependency.status.send(color), :alignment => :center},
                dependency.changelog
              ]
            end

            # If any of the cookbook is out-of-date
            out_of_date = dependencies.any? { |dep| dep.status == X_MARK }
            table = Terminal::Table.new headings: headings, rows: rows
            puts table
            if out_of_date
              puts "Status: out-of-date ( #{X_MARK} )".red
            else
              puts "Status: up-to-date ( #{TICK_MARK} )".green
            end
          end
        end
      end
    end
  end
end
