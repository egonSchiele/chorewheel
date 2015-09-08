require "date"

RSpec.describe "ChoreWheel" do
  describe "chunks" do
    it "should make chunks for week/day" do
      t = ChoreWheel.new(:adit, Timespan::WEEK, Interval::DAY)
      expect(t.shifts).to eq(days)
    end

    it "should make chunks for week/weekday" do
      t = ChoreWheel.new(:adit, Timespan::WEEK, Interval::WEEKDAY)
      expect(t.shifts).to eq(weekdays)
    end

    it "should make chunks for week/specific_days" do
      t = ChoreWheel.new(:adit, Timespan::WEEK, Interval::SPECIFIC_DAYS.new(["tuesday", "thursday", "friday"]))
      expect(t.shifts).to eq(["tuesday", "thursday", "friday"])
    end

    describe "chunks for months" do
      before :each do
        @month = Timespan::MONTH.new(Date.strptime("2015-09-01", "%Y-%m-%d"))
      end

      it "should make chunks for month/days" do
        t = ChoreWheel.new(:adit, @month, Interval::DAY)
        expect(t.shifts).to eq(["2015-09-01", "2015-09-02", "2015-09-03", "2015-09-04", "2015-09-05", "2015-09-06", "2015-09-07", "2015-09-08", "2015-09-09", "2015-09-10", "2015-09-11", "2015-09-12", "2015-09-13", "2015-09-14", "2015-09-15", "2015-09-16", "2015-09-17", "2015-09-18", "2015-09-19", "2015-09-20", "2015-09-21", "2015-09-22", "2015-09-23", "2015-09-24", "2015-09-25", "2015-09-26", "2015-09-27", "2015-09-28", "2015-09-29", "2015-09-30"])
      end

      it "should make chunks for month/weekdays" do
        t = ChoreWheel.new(:adit, @month, Interval::WEEKDAY)
        expect(t.shifts).to eq(["2015-09-01", "2015-09-02", "2015-09-03", "2015-09-04", "2015-09-07", "2015-09-08", "2015-09-09", "2015-09-10", "2015-09-11", "2015-09-14", "2015-09-15", "2015-09-16", "2015-09-17", "2015-09-18", "2015-09-21", "2015-09-22", "2015-09-23", "2015-09-24", "2015-09-25", "2015-09-28", "2015-09-29", "2015-09-30"])
      end

      it "should make chunks for month/specific days" do
        t = ChoreWheel.new(:adit, @month, Interval::SPECIFIC_DAYS.new(["tuesday", "thursday", "friday"]))
        expect(t.shifts).to eq(["2015-09-01", "2015-09-03", "2015-09-04", "2015-09-08", "2015-09-10", "2015-09-11", "2015-09-15", "2015-09-17", "2015-09-18", "2015-09-22", "2015-09-24", "2015-09-25", "2015-09-29"])
      end
    end
  end

  describe "interface" do
    before :each do
      @t = ChoreWheel.new(:adit, Timespan::WEEK, Interval::WEEKDAY)
    end

    it "to_a" do
      expect(@t.to_a).to eq([["monday", [:adit]], ["tuesday", [:adit]], ["wednesday", [:adit]], ["thursday", [:adit]], ["friday", [:adit]]])
    end

    it "shifts" do
      expect(@t.shifts).to eq(weekdays)
    end

    it "workers" do
      expect(@t.workers).to eq([[:adit], [:adit], [:adit], [:adit], [:adit]])
    end
  end

  describe "create" do
    people = [
      [:adit],
      [:adit, :maggie]
    ]

    specific_days = Interval::SPECIFIC_DAYS.new(["tuesday", "thursday", "friday"])

    create_args = [
      [Timespan::WEEK, Interval::DAY],
      [Timespan::WEEK, Interval::WEEKDAY],
      [Timespan::WEEK, specific_days]
    ]

    expected_shifts = {
      [Timespan::WEEK, Interval::DAY] => ["sunday", "monday", "tuesday", "wednesday", "thursday", "friday", "saturday"],
      [Timespan::WEEK, Interval::WEEKDAY] => ["monday", "tuesday", "wednesday", "thursday", "friday"],
      [Timespan::WEEK, specific_days] => ["tuesday", "thursday", "friday"]
    }

    people.each do |persons|
      create_args.each do |args|
        it "should create timespan for #{args} and #{persons}" do
          cw = ChoreWheel.new(persons, *args)
          expect(cw.shifts).to eq(expected_shifts[args])

          check_even_distribution(cw)
        end
      end
    end
  end

  describe "workers_per_shift" do
    before :each do
      @cw = ChoreWheel.new([:adit, :maggie], Timespan::WEEK, Interval::WEEKDAY, {:workers_per_shift => 2})
    end
    it "should assign 2 workers per shift" do
      @cw.workers.each do |arr|
        expect(arr.size).to eq(2)
      end
    end

    it "should assign the shifts evenly" do
      check_even_distribution(@cw)
    end
  end

  describe "hash" do
    it "should convert to json correctly" do
      cw = ChoreWheel.new([:adit, :maggie], Timespan::WEEK, Interval::DAY, {:workers_per_shift => 2})
      chunks = cw.chunks

      expected = {
        "people" => [:adit, :maggie],
        "timespan" => Timespan::WEEK,
        "interval" => Interval::DAY,
        "workers_per_shift" => 2,
        "chunks" => chunks
      }

      expect(cw.to_hash).to eq(expected)
    end

    it "should convert from json correctly" do
      cw = ChoreWheel.new([:adit, :maggie], Timespan::WEEK, Interval::DAY, {:workers_per_shift => 2})
      chunks = cw.chunks

      hash = cw.to_hash

      cw2 = ChoreWheel.from_hash hash

      expect(cw2.people).to eq([:adit, :maggie])
      expect(cw2.timespan).to eq(Timespan::WEEK)
      expect(cw2.interval).to eq(Interval::DAY)
      expect(cw2.workers_per_shift).to eq(2)
      expect(cw2.chunks).to eq(chunks)
    end
  end
end
