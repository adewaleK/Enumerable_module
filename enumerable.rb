module Enumerable
  def my_each
    x = 0
    until x > self.length - 1
      yield(self[x])
      x += 1
    end
    self
  end


  def my_each_with_index
    x = 0
    self.my_each do |name|
      yield(name, x)
      x += 1
    end
    self
  end

    
  def my_select
    selected = []
    self.my_each do |n|
      selected << n if yield(n)
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


  def my_map(&my_proc)
    result_array = []
    self.my_each do |item|
      if my_proc.nil?
        new_array << my_proc.call(item)
      else
        result_array << yield(item)
    end
    result_array
  end

  def my_inject(*args) 
    arr = to_a
    if block_given?
      arr = dup.to_a
      result = args[0].nil? ? arr[0] : args[0]
      arr.shift if args[0].nil?
      arr.each do |n|
        result = yield(result, n)
      end
    elsif !block_given?
      arr = to_a
      if args[1].nil?
        symbol = args[0]
        result = arr[0]
        arr[1..-1].my_each do |i|
        result = result.send(symbol, i)
      end
      elsif !args[1].nil?
        symbol = args[1]
        result = args[0]
        arr.my_each do |i|
          result = result.send(symbol, i)
        end
      end
    end
    result
  end

# Testing my_inject with a multiplication function

  def multiply_els(arr)
    result = arr.my_inject { |acc, n| acc * n }
    result
  end
  
end


def multiply_els(arr)
  result = arr.my_inject(:*)
  result
end

puts 'multiply_els([2, 4, 5]) result: ' + multiply_els([2, 4, 5]).to_s

# Proc to test the implementation of the my_map method

puts 'array.map { |n| n * 7 } output: ' + [1,2,3].map { |n| n * 7 }.to_s

even_numbers = [4, 5, 6].my_select(&:even?)

puts even_numbers