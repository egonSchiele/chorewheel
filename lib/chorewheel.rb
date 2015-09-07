# A chore schedule takes place over a timespan.
# In intervals.
# And it is done by some people.

require "util"
require "contracts"
require "timespan"
require "interval"
include Contracts

class ChoreWheel
  GenericString = Or[String, Symbol]
  attr_accessor :workers_per_shift, :people
  def initialize people, timespan, interval, opts = {}
    unless people.is_a?(Array)
      people = [people]
    end
    @people = people
    @timespan = timespan
    @interval = interval
    @workers_per_shift = opts[:workers_per_shift] || 1
    create
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

  Contract ArrayOf[String]
  def shifts
    chunks.keys
  end

  Contract ArrayOf[ArrayOf[GenericString]]
  def workers
    chunks.values
  end

  Contract ArrayOf[[String, ArrayOf[GenericString]]]
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

  Contract Timespan::MONTH, Interval::DAY => Hash
  def make_chunks timespan, interval
    hash = {}
    start = timespan.start_date
    (start...start.next_month).each do |date|
      hash[date.to_s] = nil
    end
    hash
  end

  Contract Timespan::MONTH, Interval::WEEKDAY => Hash
  def make_chunks timespan, interval
    hash = make_chunks(timespan, Interval::DAY)
    # delete sundays and saturdays
    hash.delete_if do |key, _|
      [0, 6].include?(Date.parse(key).wday)
    end
  end

  Contract Timespan::MONTH, Interval::SPECIFIC_DAYS => Hash
  def make_chunks timespan, interval
    hash = make_chunks(timespan, Interval::DAY)
    hash.delete_if do |key, _|
      !interval.days.include?(Date.parse(key).strftime("%A").downcase)
    end
  end

  Contract Any, Any => Any
  def make_chunks timespan, interval
    fail "don't know how to make timespan with timespan type #{timespan} and interval type #{interval}"
  end

  def create
    i = 0
    _people = people.dup.shuffle
    set_each do
      workers = []
      workers_per_shift.times do
        if i >= _people.size
          i = 0
          _people.shuffle!
        end
        workers << _people[i]
        i += 1
      end
      workers
    end
  end
end
