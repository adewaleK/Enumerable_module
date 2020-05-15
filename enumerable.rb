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

    
    
    


end

result = [1,2,3,4,5,6].my_select { |n| n.even? }
puts result