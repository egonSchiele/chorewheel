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

# infinitely keep yielding
# elements of the array, starting
# from the beginning when you are at the end
def cycle arr
  while true
    arr.each do |elem|
      yield elem
    end
  end
end
