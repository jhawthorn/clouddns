
require 'test_helper'

class DslTest < Test::Unit::TestCase
  def test_simple
    dsl = Clouddns::DSL.parse_string <<-EOL
      zone "example.com." do
        A 'www.example.com.', '1.2.3.4'
      end
    EOL
    assert_equal 1, dsl.zones.count

    zone = dsl.zones.first
    assert_equal 'example.com.', zone.name
    assert_equal 1, zone.records.count

    record = zone.records.first
    assert_equal 'A', record.type
    assert_equal 'www.example.com.', record.name
    assert_equal ['1.2.3.4'], record.value
  end
  def test_trailing_dot_is_implied
    dsl = Clouddns::DSL.parse_string <<-EOL
      zone "example.com" do
        A 'www.example.com', '1.2.3.4'
      end
    EOL

    assert_equal 'example.com.', dsl.zones.first.name
    assert_equal 'www.example.com.', dsl.zones.first.records.first.name
  end
end

