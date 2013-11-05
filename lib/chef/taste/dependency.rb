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
    # The class that contains information about a dependent cookbook
    #
    class Dependency
      # The name of the dependency
      attr_reader :name

      # The requirement for the dependency
      attr_reader :requirement

      # The version of cookbook used after applying the version constraint
      attr_accessor :version_used

      # The latest version available for the dependency
      attr_accessor :latest

      # The status of the dependency
      attr_accessor :status

      # The source URL for a cookbook
      attr_accessor :source_url

      # The changelog link for the dependency if available
      attr_accessor :changelog

      # Constructor
      #
      # @param name [String] the name of the dependent cookbook
      # @param requirement [String] the version requirement for dependent cookbook
      #
      # @return [Dependency] the Dependency object
      #
      def initialize(name, requirement)
        @name = name
        @requirement = requirement
        @version_used = nil
        @latest = nil
        @status = nil
        @source_url = nil
        @changelog = nil
      end
    end
  end
end
