
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
    for zonename in %w{example.com example.com.}
      dsl = Clouddns::DSL.parse_string <<-EOL
      zone "#{zonename}" do
        A 'test1.example.com', '1.2.3.4'
        A 'test2.example.com.', '1.2.3.4'
      end
      EOL

      assert_equal 'example.com.', dsl.zones.first.name

      records = dsl.zones.first.records
      assert_equal 'test1.example.com.', records[0].name
      assert_equal 'test2.example.com.', records[1].name
    end
  end
end

