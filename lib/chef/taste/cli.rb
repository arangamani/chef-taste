require 'chef/taste'

module Chef
  module Taste
    class Cli < Thor
      desc 'check', 'Check status of dependent cookbooks'
      def check
        puts "Checking..."
        dependencies = DependencyChecker.check
        Display.print(dependencies)
      end
    end
  end
end
