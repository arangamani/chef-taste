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
    # The Changelog class that computes the changelog if the current version
    # being used and the latest version are different and the changelog is computable.
    #
    class Changelog
      class << self
        # Compute the changelog for the dependent cookbook if available
        #
        # @param dep [Dependency] the dependent cookbook
        #
        # @return [String] the goo.gl shortened URL for the changelog
        #
        def compute(dep)
          changelog_url =
            if dep.source_url =~ /^(https?:\/\/)?github.com\/(.*)\/(.*)$/
              GithubChangelog.new("#{$2}/#{$3}", dep.version_used, dep.latest).compute
            else
              nil
            end
          Googl.shorten(changelog_url).short_url unless changelog_url.nil?
        end
      end

      # The class for computing the changelog for cookbooks hosted in Github.
      #
      class GithubChangelog
        # The Github repository
        attr_reader :repo

        # The version to compare from
        attr_reader :from_version

        # The version to compare to
        attr_reader :to_version

        # Constructor
        #
        # @param repo [String] the Github repo
        # @param from_version [String] the version to compare from
        # @param to_version [String] the version to compare to
        #
        # @return [GithubChangelog] the Github changelog object
        #
        def initialize(repo, from_version, to_version)
          @repo = repo
          @from_version = from_version
          @to_version = to_version
        end

        # Computes the changelog URL for Github repositories
        #
        # @return [String] the computed changelog URL
        #
        def compute
          tags = Octokit.tags(repo)
          from_tag = nil
          to_tag = nil
          tags.each do |tag|
            tag_name = tag.name
            from_tag = tag_name if tag_name =~ /v?#{from_version}/
            to_tag = tag_name if tag_name =~ /v?#{to_version}/
          end
          compare_url(from_tag, to_tag) if from_tag && to_tag
        end

        # Returns the compare URL for comparing two tags on Github
        #
        # @param from_tag [String] the tag to compare from
        # @param to_tag [String] the tag to compare to
        #
        # @return [String] the Github URL to compare given two tags
        #
        def compare_url(from_tag, to_tag)
          "https://github.com/#{repo}/compare/#{from_tag}...#{to_tag}"
        end
      end
    end
  end
end
