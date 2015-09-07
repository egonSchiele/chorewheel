RSpec.describe "ChoreWheel" do
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

    expected_schedule = {
      [:adit] => {},
      [:adit, :maggie] => {}
    }

    expected_schedule[[:adit]][[Timespan::WEEK, Interval::DAY]] = [
      [:sunday, :adit],
      [:monday, :adit],
      [:tuesday, :adit],
      [:wednesday, :adit],
      [:thursday, :adit],
      [:friday, :adit],
      [:saturday, :adit]
    ]

    expected_schedule[[:adit]][[Timespan::WEEK, Interval::WEEKDAY]] = [
      [:monday, :adit],
      [:tuesday, :adit],
      [:wednesday, :adit],
      [:thursday, :adit],
      [:friday, :adit]
    ]

    expected_schedule[[:adit]][[Timespan::WEEK, specific_days]] = [
      [:tuesday, :adit],
      [:thursday, :adit],
      [:friday, :adit]
    ]

    expected_schedule[[:adit, :maggie]][[Timespan::WEEK, Interval::DAY]] = [
      [:sunday, :adit],
      [:monday, :maggie],
      [:tuesday, :adit],
      [:wednesday, :maggie],
      [:thursday, :adit],
      [:friday, :maggie],
      [:saturday, :adit]
    ]

    expected_schedule[[:adit, :maggie]][[Timespan::WEEK, Interval::WEEKDAY]] = [
      [:monday, :adit],
      [:tuesday, :maggie],
      [:wednesday, :adit],
      [:thursday, :maggie],
      [:friday, :adit],
    ]

    expected_schedule[[:adit, :maggie]][[Timespan::WEEK, specific_days]] = [
      [:tuesday, :adit],
      [:thursday, :maggie],
      [:friday, :adit]
    ]

    people.each do |persons|
      create_args.each do |args|
        it "should create timespan for #{args} and #{persons}" do
          cs = ChoreWheel.new(persons)
          schedule = cs.create(*args)
          expect(schedule.to_a).to eq(expected_schedule[persons][args])
        end
      end
    end
  end
end
