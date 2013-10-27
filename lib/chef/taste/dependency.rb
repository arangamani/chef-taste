require 'chef/taste'

module Chef
  module Taste
    class Dependency

      # The name of the dependency
      attr_reader :name

      # The requirement for the dependency
      attr_reader :requirement

      # The version of cookbook used after applying the version constraint
      attr_reader :version_used

      # The latest version available for the dependency
      attr_reader :latest

      # The status of the dependency
      attr_reader :status

      # The source URL for a cookbook
      attr_reader :source_url

      # The changelog link for the dependency if available
      attr_reader :changelog

      def initialize(name, requirement)
        @name = name
        @requirement = requirement
        @latest = nil
        @status = nil
        @changelog = nil
      end

      def version_used=(version_used)
        @version_used = version_used
      end

      def latest=(latest)
        @latest = latest
      end

      def status=(status)
        @status = status
      end

      def source_url=(source_url)
        @source_url = source_url
      end

      def changelog=(changelog)
        @changelog = changelog
      end
    end
  end
end
