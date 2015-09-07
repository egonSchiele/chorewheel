# Essentially an ordered hash.
# Ruby 1.9 hashes are all ordered.
require "util"
require "interval"
require "contracts"
include Contracts

class Schedule
  def initialize timespan, interval
    @timespan = timespan
    @interval = interval
  end

  Contract Hash
  def chunks
    @chunks ||= make_chunks @timespan, @interval
    @chunks
  end

  def map &blk
    arr = []
    chunks.values.map do |val|
      arr << blk.call[val]
    end
    arr
  end

  def keys
    chunks.keys
  end

  def values
    chunks.values
  end

  def to_a
    chunks.to_a
  end

  def each &blk
    chunks.values.each do |val|
      blk.call(val)
    end
    self
  end

  def set_each &blk
    chunks.each do |key, val|
      chunks[key] = blk.call key
    end
    self
  end

  private

  Contract Timespan::WEEK, Interval::WEEKDAY => Hash
  def make_chunks timespan, interval
    make_hash weekdays
  end

  Contract Timespan::WEEK, Interval::DAY => Hash
  def make_chunks timespan, interval
    make_hash days
  end

  Contract Timespan::WEEK, Interval::SPECIFIC_DAYS => Hash
  def make_chunks timespan, interval
    hash = {}
    interval.days.each do |day|
      hash[day] = nil
    end
    hash
  end

  Contract Any, Any => Any
  def make_chunks timespan, interval
    fail "don't know how to make timespan with timespan type #{timespan} and interval type #{interval}"
  end
end