class Interval
  DAY = :day
  WEEKDAY = :weekday
  SPECIFIC_DAYS = Struct.new(:days)
  class SPECIFIC_DAYS
    def inspect
      days.inspect
    end
  end
  WEEK = :week
  MONTH = :month
  YEAR = :year
end
