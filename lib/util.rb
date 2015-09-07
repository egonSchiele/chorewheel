def weekdays
  [:monday, :tuesday, :wednesday, :thursday, :friday]
end

def days
  [:sunday] + weekdays + [:saturday]
end

def make_hash keys
  hash = {}
  keys.each do |key|
    hash[key] = nil
  end
  hash
end
