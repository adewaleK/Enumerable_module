module Enumerable
  def my_each
    return to_enum unless block_given?

    x = 0
    new_class = self.class
    result_array =
      if new_class == Array
        self
      elsif new_class == Range
        to_a
      else
        flatten
      end
    while x < result_array.length
      if new_class == Hash
        yield(result_array[x], result_array[x + 1])
        x += 2
      else
        yield(result_array[x])
        x += 1
      end
    end
  end

  def my_each_with_index
    return to_enum unless block_given?

    array = self.class == Array ? self : to_a
    x = 0
    array.my_each do |name|
      yield(name, x)
      x += 1
    end
    array
  end

  def my_select
    return to_enum unless block_given?
  
    selected = self.class == Array ? [] : {}
    if selected.class == Array
      selected.my_each do |n|
        selected << n if yield(n)
      end
    else
      selected.my_each do |key, value|
        selected[key] = value if yield(key, value)
      end
    end
    selected
  end

  def my_all?(param = nil)
    return true if (self.class == Array && count.zero?) || (!block_given? && param.nil? && !include?(nil))
    
    return false unless block_given? || !param.nil?

    bool = true
    if self.class == Array
      my_each do |n|
        if block_given?
          bool = false unless yield(n)
        elsif param.class == Regexp
          bool = false unless n.match(param)
        elsif param.class <= Numeric
          bool = false unless n == param
        else
          bool = false unless n.class <= param
        end
        break unless bool
      end
    else
      my_each do |key, value|
        bool = false unless yield(key, value)
      end
    end
    bool
  end

  def my_any?(param = nil)
    return false if (self.class == Array && count.zero?) || (!block_given? && param.nil? && !include?(true))
        
    return true unless block_given? || !param.nil?

    bool = false
    if self.class == Array
      my_each do |n|
        if block_given?
          bool = true if yield(n)
        elsif param.class == Regexp
          bool = true if n.match(param)
        elsif param.class == String
          bool = true if n == param
        elsif n.class <= param
          bool = true
        end
      end
    else
      my_each do |key, value|
        bool = true if yield(key, value)
      end
    end
    bool
  end

  def my_none?(param = nil)
    return true if count.zero? || (self[0].nil? && !include?(true))

    return false unless block_given? || !param.nil?

    bool = true
    if self.class == Array
      my_each do |n|
        if block_given?
          bool = false if yield(n)
        elsif param.class == Regexp
          bool = false if n.match(param)
        elsif param.class <= Numeric
          bool = false if n == param
        elsif n.class <= param
          bool = false
        end
        break unless bool
      end
    else
      my_each do |key, value|
        bool = false if yield(key, value)
        break unless bool
      end
    end
    bool
  end

  def my_count
    count = 0
    if block_given?
      my_each do |item|
        count += 1 if yield(item)
      end
    else
      count = self.count
    end
    count
  end

  def my_map(&my_proc)
    result_array = []
    my_each do |item|
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
      end
    elsif !args[1].nil?
      symbol = args[1]
      result = args[0]
      arr.my_each do |i|
        result = result.send(symbol, i)
      end
    end
    result
  end
end

def multiply_els(arr)
  result = arr.my_inject { |acc, n| acc * n }
  result
end

# def multiply_els(arr)
#   result = arr.my_inject(:*)
#   result
# end

#  puts 'multiply_els([2, 4, 5]) result: ' + multiply_els([2, 4, 5]).to_s
# Proc to test the implementation of the my_map method
# puts 'array.map { |n| n * 7 } output: ' + [1,2,3].map { |n| n * 7 }.to_s


