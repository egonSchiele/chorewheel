RSpec.describe "ChoreWheel" do
  describe "chunks" do
    it "should make chunks for week/day" do
      t = ChoreWheel.new(:adit, Timespan::WEEK, Interval::DAY)
      expect(t.chunks).to eq(make_hash days)
    end

    it "should make chunks for week/weekday" do
      t = ChoreWheel.new(:adit, Timespan::WEEK, Interval::WEEKDAY)
      expect(t.chunks).to eq(make_hash weekdays)
    end

    it "should make chunks for week/specific_days" do
      t = ChoreWheel.new(:adit, Timespan::WEEK, Interval::SPECIFIC_DAYS.new([:tuesday, :thursday, :friday]))
      expect(t.chunks).to eq({:tuesday => nil, :thursday => nil, :friday => nil})
    end
  end

  describe "interface" do
    before :each do
      @t = ChoreWheel.new(:adit, Timespan::WEEK, Interval::WEEKDAY)
    end

    it "to_a" do
      expect(@t.to_a).to eq([[:monday, nil], [:tuesday, nil], [:wednesday, nil], [:thursday, nil], [:friday, nil]])
    end

    it "keys" do
      expect(@t.keys).to eq(weekdays)
    end

    it "values" do
      expect(@t.values).to eq([nil, nil, nil, nil, nil])
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

    expected_keys = {
      [Timespan::WEEK, Interval::DAY] => [:sunday, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday],
      [Timespan::WEEK, Interval::WEEKDAY] => [:monday, :tuesday, :wednesday, :thursday, :friday],
      [Timespan::WEEK, specific_days] => [:tuesday, :thursday, :friday]
    }

    people.each do |persons|
      create_args.each do |args|
        it "should create timespan for #{args} and #{persons}" do
          cw = ChoreWheel.new(persons, *args)
          cw.create
          expect(cw.keys).to eq(expected_keys[args])

          # get the number of shifts for each person
          shifts = persons.map do |name|
            cw.count do |day, person|
              person == name
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
end
