require 'chef/taste'

module Chef
  module Taste
    class DependencyChecker
      class << self
        def check(path = Dir.pwd)
          raise NotACookbook, "Current directory is not a cookbook" unless File.exists?(File.join(path, 'metadata.rb'))
          ridley = Ridley::Chef::Cookbook::Metadata.from_file(File.join(path, 'metadata.rb'))
          rest = Berkshelf::CommunityREST.new
          ridley.dependencies.map do |name, version|
            dep = Dependency.new(name, version)
            begin
              dep.latest = rest.latest_version(name)
            rescue Berkshelf::CookbookNotFound
              next
            end
            # Obtain the version used based on the version constraint
            #
            if version
              dep.version_used = rest.satisfy(name, version)
            else
              dep.version_used = dep.latest
            end
            dep.source_url = rest.get(name).body['external_url']

            # Calculate the status based on the version being used and the latest version
            #
            if Solve::Version.new(dep.version_used).eql?(Solve::Version.new(dep.latest))
              dep.status = TICK_MARK
            else
              dep.status = X_MARK
              dep.changelog = Changelog.compute(dep)
            end
            dep
          end
        end
      end
    end
  end
end
