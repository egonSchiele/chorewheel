# A chore schedule takes place over a timespan.
# In intervals.
# And it is done by some people.

require "util"
require "contracts"
require "timespan"
require "interval"
include Contracts

class ChoreWheel
  def initialize people, timespan, interval
    @people = people
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

  def count &blk
    counter = 0
    chunks.each do |key, val|
      result = blk.call key, val
      counter += 1 if result
    end
    counter
  end

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

  def create
    i = 0
    set_each do
      i = 0 if i >= @people.size
      result = @people[i]
      i += 1
      result
    end
    self
  end
end
