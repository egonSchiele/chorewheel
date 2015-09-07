RSpec.describe "ChoreSchedule" do
  describe "create" do
    people = [
      [:adit],
      [:adit, :maggie]
    ]

    create_args = [
      [Timespan::WEEK, Interval::DAY],
      [Timespan::WEEK, Interval::WEEKDAY]
    ]

    expected_timespan = {
      [:adit] => {},
      [:adit, :maggie] => {}
    }

    expected_timespan[[:adit]][[Timespan::WEEK, Interval::DAY]] = [
      [:sunday, :adit],
      [:monday, :adit],
      [:tuesday, :adit],
      [:wednesday, :adit],
      [:thursday, :adit],
      [:friday, :adit],
      [:saturday, :adit]
    ]
    expected_timespan[[:adit]][[Timespan::WEEK, Interval::WEEKDAY]] = [
      [:monday, :adit],
      [:tuesday, :adit],
      [:wednesday, :adit],
      [:thursday, :adit],
      [:friday, :adit],
    ]

    expected_timespan[[:adit, :maggie]][[Timespan::WEEK, Interval::DAY]] = [
      [:sunday, :adit],
      [:monday, :maggie],
      [:tuesday, :adit],
      [:wednesday, :maggie],
      [:thursday, :adit],
      [:friday, :maggie],
      [:saturday, :adit]
    ]
    expected_timespan[[:adit, :maggie]][[Timespan::WEEK, Interval::WEEKDAY]] = [
      [:monday, :adit],
      [:tuesday, :maggie],
      [:wednesday, :adit],
      [:thursday, :maggie],
      [:friday, :adit],
    ]
    people.each do |persons|
      create_args.each do |args|
        it "should create timespan for #{args} and #{persons}" do
          cs = ChoreSchedule.new(persons)
          timespan = cs.create(*args)
          expect(timespan.to_a).to eq(expected_timespan[persons][args])
        end
      end
    end
  end
end
