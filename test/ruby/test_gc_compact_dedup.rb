# frozen_string_literal: true
require 'test/unit'
require 'fiddle'

class TestGCCompactDedup < Test::Unit::TestCase
  COUNT = 1000

  def test_dedup_frozen_strings
    arr = 1000.times.map { "STRING".freeze }

    assert_equal COUNT, arr.map(&:object_id).uniq.count
    GC.compact(dedup: true)
    assert_equal 1, arr.map(&:object_id).uniq.count
  end
end
