module Enumerable

    def my_each
        x=0
        until x > self.length - 1
          yield(self[x])
          x += 1
        end
        self
      end
    
    


end

[1,2,3].my_each {
    |x|
    puts x * 3
}