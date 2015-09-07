require_relative "../lib/util"

RSpec.describe "Schedule" do
  describe "chunks" do
    it "should make chunks for week/day" do
      t = Schedule.new(Timespan::WEEK, Interval::DAY)
      expect(t.chunks).to eq(make_hash days)
    end

    it "should make chunks for week/weekday" do
      t = Schedule.new(Timespan::WEEK, Interval::WEEKDAY)
      expect(t.chunks).to eq(make_hash weekdays)
    end

    it "should make chunks for week/specific_days" do
      t = Schedule.new(Timespan::WEEK, Interval::SPECIFIC_DAYS.new([:tuesday, :thursday, :friday]))
      expect(t.chunks).to eq({:tuesday => nil, :thursday => nil, :friday => nil})
    end
  end

  describe "interface" do
    before :each do
      @t = Schedule.new(Timespan::WEEK, Interval::WEEKDAY)
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
end
