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
      t = ChoreWheel.new(:adit, Timespan::WEEK, Interval::SPECIFIC_DAYS.new([:tuesday, :thursday, :friday]))
      expect(t.shifts).to eq([:tuesday, :thursday, :friday])
    end
  end

  describe "interface" do
    before :each do
      @t = ChoreWheel.new(:adit, Timespan::WEEK, Interval::WEEKDAY)
    end

    it "to_a" do
      expect(@t.to_a).to eq([[:monday, [:adit]], [:tuesday, [:adit]], [:wednesday, [:adit]], [:thursday, [:adit]], [:friday, [:adit]]])
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

    specific_days = Interval::SPECIFIC_DAYS.new([:tuesday, :thursday, :friday])

    create_args = [
      [Timespan::WEEK, Interval::DAY],
      [Timespan::WEEK, Interval::WEEKDAY],
      [Timespan::WEEK, specific_days]
    ]

    expected_shifts = {
      [Timespan::WEEK, Interval::DAY] => [:sunday, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday],
      [Timespan::WEEK, Interval::WEEKDAY] => [:monday, :tuesday, :wednesday, :thursday, :friday],
      [Timespan::WEEK, specific_days] => [:tuesday, :thursday, :friday]
    }

    people.each do |persons|
      create_args.each do |args|
        it "should create timespan for #{args} and #{persons}" do
          cw = ChoreWheel.new(persons, *args)
          expect(cw.shifts).to eq(expected_shifts[args])

          # get the number of shifts for each person
          shifts = persons.map do |name|
            cw.count do |day, persons|
              persons.include?(name)
            end
          end

          # each person should have not more than 1 away from the avg number of shifts
          avg = shifts.inject(:+) / shifts.size.to_f

          persons.zip(shifts).each do |name, shift|
            if (shift - avg).abs > 1
              raise "Person #{name} is doing #{shift} shifts, but the average is #{avg}."
            end
          end
        end
      end
    end
  end

  describe "workers_per_shift" do
    before :each do
      @cw = ChoreWheel.new([:adit, :maggie], Timespan::WEEK, Interval::WEEKDAY, {"workers_per_shift": 2})
    end
    it "should assign 2 workers per shift" do
    end
  end
end
