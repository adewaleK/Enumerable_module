module Enumerable

  def my_each
    x=0
    until x > self.length - 1
      yield(self[x])
      x += 1
    end
    self
  end


  def my_each_with_index
    x=0
    self.my_each do |name|
      yield(name, x)
      x += 1
    end
    self
  end

    
  def my_select
    selected = []
    self.my_each do |n|
    if yield(n)
      selected << n
    end
  end
  selected
end


def my_all?
  result = true
  self.my_each do |item|
   result = false if !yield(item) 
  end
  result
end


def my_any?
  result = false
  self.my_each do |item|
    result = true if yield(item) 
  end
  result 
end


def my_none?
  result = true
  self.my_each do |item|
   result = false if yield(item) 
  end
  result 
end

def my_count
  count = 0
  if block_given?
    self.my_each do |item|
    count += 1 if yield(item)
    end
  else
    count = self.count
  end
  count
end 





    
    
    


end

result = [4,12,8].my_count { |n| n.even? }
puts result