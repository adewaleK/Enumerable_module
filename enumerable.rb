module Enumerable # rubocop:disable Metrics/ModuleLength
  # def my_each
  #   return to_enum unless block_given?

  #   x = 0
  #   new_class = self.class
  #   result_array =
  #     if new_class == Array
  #       self
  #     elsif new_class == Range
  #       to_a
  #     else
  #       flatten
  #     end
  #   while x < result_array.length
  #     if new_class == Hash
  #       yield(result_array[x], result_array[x + 1])
  #       x += 2
  #     else
  #       yield(result_array[x])
  #       x += 1
  #     end
  #   end
  # end

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

    arr_to_work = self
    if is_a? Array
      myarr = []
      arr_to_work.my_each do |item|
        myarr.push(item) if yield(item)
      end
    elsif is_a? Hash
      myarr = {}
      arr_to_work.my_each do |k, v|
        myarr[k] = v if yield(k, v)
      end
    end
    myarr
  end

  def my_all?(param = nil) # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
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

  def my_any?(param = nil) # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
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

  def my_none?(param = nil) # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
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

  def my_count(xxx = nil) # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    return length unless block_given? || !xxx.nil?

    my_arr = self
    counter = 0
    if !xxx.nil?
      my_arr.my_each do |item|
        counter += 1 if item == xxx
      end
    elsif is_a? Array
      my_arr.my_each do |item|
        counter += 1 if yield(item)
      end
    elsif is_a? Hash
      my_arr.my_each do |x, y|
        counter += 1 if yield(x, y)
      end
    end
    counter
  end

  def my_map
    return to_enum unless block_given?

    arr = self
    result_array = []
    if is_a? Array
      arr.my_each do |k|
        result_array << yield(k)
      end
    elsif is_a? Hash
      arr.my_each do |k, v|
        result_array << yield(k, v)
      end
    end
    result_array
  end

  def my_inject(*args) # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
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

puts 'multiply_els([2, 4, 5]) result: ' + multiply_els([2, 4, 5]).to_s
