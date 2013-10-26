require 'chef/taste'

module Chef
  module Taste
    class Display
      class << self
        def print(dependencies)

          rows = []
          headings = [
            'Name',
            'Requirement',
            'Latest',
            'Status',
            'Changelog'
          ]
          dependencies.each do |dependency|
            rows << [
              dependency.name,
              dependency.requirement,
              dependency.latest,
              dependency.status,
              dependency.changelog
            ]
          end
          table = Terminal::Table.new headings: headings, rows: rows
          puts table
        end
      end
    end
  end
end
