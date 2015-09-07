require "person"

class ChoreWheel
  attr_accessor :people

  Opts = {

  }

  Contract ArrayOf[String], Opts
  def initialize names, opts = {}
    @people = names.map do |name|
      Person.new name
    end
  end

  def schedule
  end
end
