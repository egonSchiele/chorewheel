require "contracts"
include Contracts

class Interval
  DAY = :day
  WEEKDAY = :weekday
  WEEK = :week
  MONTH = :month
  YEAR = :year

  class SPECIFIC_DAYS
    attr_accessor :days

    Contract ArrayOf[String] => Any
    def initialize days
      @days = days
    end
    def inspect
      days.inspect
    end
  end
end
