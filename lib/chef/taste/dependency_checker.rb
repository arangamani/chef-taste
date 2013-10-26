require 'chef/taste'

module Chef
  module Taste
    class DependencyChecker
      class << self
        def check
          dep1 = Dependency.new('ntp', '~> 0.1.0')
          dep1.latest = '0.2.2'
          dep2 = Dependency.new('swap', '~> 0.2.2')
          [dep1, dep2]
        end
      end
    end
  end
end
