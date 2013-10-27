require 'chef/taste'

module Chef
  module Taste
    class DependencyChecker
      class << self
        def check
          ridley = Ridley::Chef::Cookbook::Metadata.from_file('metadata.rb')
          rest = Berkshelf::CommunityREST.new
          ridley.dependencies.map do |name, version|
            dep = Dependency.new(name, version)
            dep.latest = rest.latest_version(name)
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
