# A chore schedule takes place over a timespan.
# In intervals.
# And it is done by some people.

require "util"
require "contracts"
require "timespan"
require "interval"
include Contracts

class ChoreSchedule
  attr_accessor :people
  def initialize people
    @people = people
  end

  def create timespan, interval
    timespan = Timespan.new(timespan, interval)
    i = 0
    timespan.set_each do
      i = 0 if i >= people.size
      result = people[i]
      i += 1
      result
    end
    timespan
  end
end
