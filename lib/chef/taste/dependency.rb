require 'chef/taste'

module Chef
  module Taste
    class Dependency

      # The name of the dependency
      attr_reader :name

      # The requirement for the dependency
      attr_reader :requirement

      # The latest version available for the dependency
      attr_reader :latest

      # The status of the dependency
      attr_reader :status

      # The changelog link for the dependency if available
      attr_reader :changelog

      def initialize(name, requirement)
        @name = name
        @requirement = requirement
        @latest = nil
        @status = nil
        @changelog = nil
      end

      def latest=(latest)
        @latest = latest
      end

      def status=(status)
        @status = status
      end

      def changelog=(changelog)
        @changelog = changelog
      end
    end
  end
end
