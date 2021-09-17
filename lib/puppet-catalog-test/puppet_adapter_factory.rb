# frozen_string_literal: true

require 'puppet/version'
require 'puppet-catalog-test/puppet_adapter/base_puppet_adapter'

require 'puppet-catalog-test/puppet_adapter/puppet_3x_adapter'
require 'puppet-catalog-test/puppet_adapter/puppet_4x_adapter'

class PuppetCatalogTest::PuppetAdapterFactory
  def self.create_adapter(config)
    return PuppetCatalogTest::Puppet3xAdapter.new(config) if Puppet.version.start_with?('3.')

    return PuppetCatalogTest::Puppet4xAdapter.new(config) if Puppet.version =~ /^(4|5|6|7)/

    raise RuntimeException, "Unsupported Puppet version detected (#{Puppet.version})"
  end
end
