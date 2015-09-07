# A chore schedule takes place over a timespan.
# In intervals.
# And it is done by some people.

class ChoreSchedule
  attr_accessor :people
  def initialize people
    @people = people
  end

  Contract Timespan, Interval => Any
  def create timespan, interval
  end
end
