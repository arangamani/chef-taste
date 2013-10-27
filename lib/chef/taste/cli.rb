require 'chef/taste'

module Chef
  module Taste
    class Cli < Thor

      default_task :check

      desc 'check', 'Check status of dependent cookbooks'
      def check
        puts "Checking..."
        dependencies = DependencyChecker.check
        Display.print(dependencies)
      end
    end
  end
end
