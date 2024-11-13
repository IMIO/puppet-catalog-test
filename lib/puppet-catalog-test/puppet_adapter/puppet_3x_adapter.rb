# frozen_string_literal: true

require 'puppet'
require 'rubygems'

class PuppetCatalogTest::Puppet3xAdapter < PuppetCatalogTest::BasePuppetAdapter
  def initialize(config)
    super(config)

    require 'puppet/test/test_helper'
    parser = config[:parser]

    init_config

    # initialize was added in 3.1.0
    Puppet::Test::TestHelper.initialize if Gem::Version.new(version) > Gem::Version.new('3.1.0')

    Puppet::Test::TestHelper.before_all_tests

    Puppet::Node::Environment.new.modules_by_path.each_value do |mod|
      mod.entries.each do |entry|
        ldir = entry.plugin_directory
        $LOAD_PATH << ldir unless $LOAD_PATH.include?(ldir)
      end
    end

    # future parser was added in 3.2.0
    if parser && (Gem::Version.new(version) > Gem::Version.new('3.2.0'))
      parser_regex = /^(current|future)$/
      raise ArgumentError, "[ERROR] parser (#{parser}) is not a valid parser, should be 'current' or 'future'" unless parser.match(parser_regex)

      puts "[INFO] Using #{parser} puppet parser"
      Puppet.settings[:parser] = parser
    end

    Puppet.parse_config
  end

  def nodes
    parser = Puppet::Parser::Parser.new(Puppet::Node::Environment.new)
    parser.known_resource_types.nodes.keys
  end

  def compile(node)
    catalog = Puppet::Parser::Compiler.compile(node)
    validate_relationships(catalog)
  rescue StandardError => e
    raise e
  ensure
    Puppet::Test::TestHelper.after_each_test
  end

  def create_node(hostname, facts)
    Puppet::Test::TestHelper.before_each_test
    init_config
    node = Puppet::Node.new(hostname)
    node.merge(facts)
    node
  end

  def version
    Puppet::PUPPETVERSION
  end

  def validate_relationships(catalog)
    catalog.resources.each do |resource|
      next unless resource.is_a?(Puppet::Resource)

      resource.each do |param, value|
        pclass = Puppet::Type.metaparamclass(param)
        next unless !pclass.nil? && pclass < Puppet::Type::RelationshipMetaparam
        next if value.is_a?(String)

        check_if_resource_exists(catalog, resource, param, value)
      end
    end
    nil
  end

  private

  def check_if_resource_exists(catalog, resource, param, value)
    case value
    when Array
      value.each { |v| check_if_resource_exists(catalog, resource, param, v) }
    when Puppet::Resource
      matching_resource = catalog.resources.find do |ref_resource|
        ref_resource.type == value.type &&
          (ref_resource.title.to_s == value.title.to_s ||
           ref_resource[:name] == value.title ||
           ref_resource[:alias] == value.title)
      end

      raise "#{resource} has #{param} relationship to invalid resource #{value}" unless matching_resource
    end
  end
end
