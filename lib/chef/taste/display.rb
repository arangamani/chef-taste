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
            'Used',
            'Latest',
            'Status',
            'Changelog'
          ]
          dependencies.each do |dependency|
            rows << [
              dependency.name,
              dependency.requirement,
              dependency.version_used,
              dependency.latest,
              {:value => dependency.status, :alignment => :center},
              dependency.changelog
            ]
          end
          overall_status = dependencies.all? { |dep| dep.status == TICK_MARK }
          table = Terminal::Table.new headings: headings, rows: rows
          puts table
          if overall_status
            puts "Status: up-to-date ( #{TICK_MARK} )\n"
          else
            puts "Status: out-of-date ( #{X_MARK} )\n"
          end
        end
      end
    end
  end
end
