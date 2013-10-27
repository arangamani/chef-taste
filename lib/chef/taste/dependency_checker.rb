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
    # The class checks for cookbook dependencies and populates all fields for the dependent cookbook
    #
    class DependencyChecker
      class << self
        # Check for cookbook dependencies and their versions
        #
        # @param path [String] the path for the cookbook
        #
        # @return [Array<Dependency>] list of dependency objects
        #
        # @raise NotACookbook the current/given path is not a cookbook
        #
        def check(path = Dir.pwd)
          raise NotACookbook, "Path is not a cookbook" unless File.exists?(File.join(path, 'metadata.rb'))
          ridley = Ridley::Chef::Cookbook::Metadata.from_file(File.join(path, 'metadata.rb'))
          dependencies =
            ridley.dependencies.map do |name, version|
              Dependency.new(name, version)
            end
          populate_fields(dependencies)
        end

        # Populate various fields for all dependencies
        #
        # @param dependencies [Array<Dependency>] list of dependency objects
        #
        # @return [Array<Dependency>] list of dependency objects with updated fields
        #
        def populate_fields(dependencies)
          rest = Berkshelf::CommunityREST.new
          dependencies.each do |dep|
            # Skip cookbooks that are not available in the community site. It might be an external cookbook.
            #
            next unless cookbook_exists?(dep.name)

            dep.latest = rest.latest_version(dep.name)
            # Obtain the version used based on the version constraint
            #
            dep.version_used = rest.satisfy(dep.name, dep.requirement)
            dep.source_url = rest.get(dep.name).body['external_url']

            # Calculate the status based on the version being used and the latest version
            #
            if Solve::Version.new(dep.version_used).eql?(Solve::Version.new(dep.latest))
              dep.status = TICK_MARK
            else
              dep.status = X_MARK
              dep.changelog = Changelog.compute(dep)
            end
          end
        end

        # Checks if a particular cookbook exists in the community site
        #
        # @param name [String] the name of the cookbook
        #
        # @return [Boolean] whether the cookbook exists in the community site or not
        #
        def cookbook_exists?(name)
          rest = Berkshelf::CommunityREST.new
          rest.get(name).status == 200
        end
      end
    end
  end
end
