require 'spec_helper'

describe Chef::Taste::Dependency do
  context 'Initialized with a valid name and requirement' do
    let(:dependency) do
      described_class.new('blah', '1.0.0')
    end

    it 'should have the name set correctly' do
      dependency.name.should eq('blah')
    end

    it 'should have the dependency set correctly' do
      dependency.requirement.should eq('1.0.0')
    end

    it 'should have an attr_accessor for version_used' do
      dependency.version_used.should be_nil
      dependency.version_used = '1.0.0'
      dependency.version_used.should eq('1.0.0')
    end

    it 'should have an attr_accessor for latest' do
      dependency.latest.should be_nil
      dependency.latest = '1.0.0'
      dependency.latest.should eq('1.0.0')
    end

    it 'should have an attr_accessor for status' do
      dependency.status.should be_nil
      dependency.status = 'up-to-date'
      dependency.status.should eq('up-to-date')
    end

    it 'should have an attr_accessor for source_url' do
      dependency.source_url.should be_nil
      dependency.source_url = 'https://github.com/arangamani-cookbooks/media'
      dependency.source_url.should eq('https://github.com/arangamani-cookbooks/media')
    end

    it 'should have an attr_accessor for changelog' do
      dependency.changelog.should be_nil
      dependency.changelog = 'http://goo.gl/abcdef'
      dependency.changelog.should eq('http://goo.gl/abcdef')
    end
  end

  describe '#to_hash' do
    let(:dependency) do
      dependency = described_class.new('blah', '1.0.0')
      dependency.version_used = '1.0.0'
      dependency.latest = '1.0.0'
      dependency.status = 'up-to-date'
      dependency.source_url = 'https://github.com/arangamani-cookbooks/media'
      dependency.changelog = 'http://goo.gl/abcdef'
      dependency
    end

    it 'should return the hash format of the dependency object' do
      hash = dependency.to_hash
      hash.should be_an_instance_of(Hash)
      hash.should eq({
        requirement: '1.0.0',
        used: '1.0.0',
        latest: '1.0.0',
        status: 'up-to-date',
        changelog: 'http://goo.gl/abcdef'
      })
    end
  end
end
