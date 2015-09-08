# Essentially an ordered hash.
# Ruby 1.9 hashes are all ordered.
require "util"
require "interval"
require "contracts"
require "date"
include Contracts

class Timespan
  WEEK = :week
  YEAR = :year

  class MONTH
    attr_accessor :start_date

    Contract Date => Any
    def initialize start_date
      @start_date = start_date
    end
  end
end
