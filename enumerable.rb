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
    
    
    


end

[1,2,3].my_each_with_index {
    |x,i|
    puts "index is #{i} and value is #{x}"
}