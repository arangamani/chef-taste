require 'chef/taste'

module Chef
  module Taste
    class Changelog
      class << self
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

      class GithubChangelog
        attr_reader :repo
        attr_reader :from_version
        attr_reader :to_version
        def initialize(repo, from_version, to_version)
          @repo = repo
          @from_version = from_version
          @to_version = to_version
        end

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

        def compare_url(from_tag, to_tag)
          "https://github.com/#{repo}/compare/#{from_tag}..#{to_tag}"
        end
      end
    end
  end
end
