# chorewheel

![travis-ci](https://travis-ci.org/egonSchiele/chorewheel.svg)

Simple chore scheduler in Ruby.

## Usage

```ruby
# a chore needs to be done every day, assign adit or maggie to do it
cw = ChoreWheel.new([:adit, :maggie], Timespan::WEEK, Interval::DAY)
p cw.chunks

# a chore needs to be done every tuesday and thursday
# the month of sept 2015, and two people are required.
timespan = Timespan::MONTH.new(Date.parse("2015-09-01"))
interval = Interval::SPECIFIC_DAYS.new(["tuesday", "thursday"])
opts = {
  :workers_per_shift => 2
}
cw = ChoreWheel.new([:adit, :maggie, :samosa], timespan, interval)
p cw.chunks
```
