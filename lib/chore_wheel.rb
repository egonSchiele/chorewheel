# A chore schedule takes place over a timespan.
# In intervals.
# And it is done by some people.

require "util"
require "contracts"
require "timespan"
require "interval"
include Contracts

class ChoreWheel
  attr_accessor :people
  def initialize people, opts = {}
    @people = people
  end

  def create timespan, interval
    schedule = Schedule.new(timespan, interval)
    i = 0
    schedule.set_each do
      i = 0 if i >= people.size
      result = people[i]
      i += 1
      result
    end
    schedule
  end
end
