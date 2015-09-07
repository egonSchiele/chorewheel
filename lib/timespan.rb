# Essentially an ordered hash.
# Ruby 1.9 hashes are all ordered.
require "util"
require "interval"
require "contracts"
include Contracts

class Timespan
  WEEK = :week
  MONTH = :month
  YEAR = :year
end
