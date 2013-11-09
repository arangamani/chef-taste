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
    # The CLI for chef-taste
    #
    class Cli < Thor
      # The default task
      default_task :check

      method_option :format, type: :string,
                             desc: 'The format to use for display',
                             enum: %w(table json),
                             default: 'table',
                             aliases: '-t'
      desc 'check', 'Check status of dependent cookbooks'
      # The check command
      def check
        dependencies = DependencyChecker.check
        if dependencies.empty?
          puts 'No dependent cookbooks'.yellow
        else
          Display.print(dependencies, options[:format])
        end
      rescue NotACookbookError
        puts 'The path is not a cookbook path'.red
      rescue UnsupportedDisplayFormatError
        puts 'The display format is not supported'.red
      end
    end
  end
end
