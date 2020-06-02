module Enumerable # rubocop:disable Metrics/ModuleLength
  def my_each
    return to_enum unless block_given?

    if is_a? Array
      i = 0
      while i < size
        yield(self[i])
        i += 1
      end
    elsif is_a? Hash
      while i < size
        yield(values[i], keys[i])
        i += 1
      end
    end
    self
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

  def my_all?(pattern = nil) # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    my_arr = self
    if !block_given? && pattern.nil?
      my_arr.my_each do |item|
        return false unless item
      end
    elsif pattern.is_a? Regexp
      my_arr.my_each do |item|
        return false unless item =~ pattern
      end
    elsif pattern.is_a? Class
      my_arr.my_each do |item|
        return false unless item.is_a? pattern
      end
    elsif pattern
      my_arr.my_each do |item|
        return false unless item == pattern
      end
    elsif is_a? Array
      my_arr.my_each do |item|
        return false unless yield(item)
      end
    elsif is_a? Hash
      my_arr.my_each do |k, v|
        return false unless yield(k, v)
      end
    end
    true
  end

  def my_any?(pattern = nil) # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    my_arr = self
    if !block_given? && pattern.nil?
      my_arr.my_each do |item|
        return true if item
      end
    elsif pattern.is_a? Regexp
      my_arr.my_each do |item|
        return true if item =~ pattern
      end
    elsif pattern.is_a? Class
      my_arr.my_each do |item|
        return true if item.is_a? pattern
      end
    elsif pattern
      my_arr.my_each do |item|
        return true if item == pattern
      end
    elsif is_a? Array
      my_arr.my_each do |item|
        return true if yield(item)
      end
    elsif is_a? Hash
      my_arr.my_each do |k, v|
        return true if yield(k, v)
      end
    end
    false
  end

  def my_none?(pattern = nil) # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    my_arr = self
    if !block_given? && pattern.nil?
      my_arr.my_each do |item|
        return false if item
      end
    elsif pattern.is_a? Regexp
      my_arr.my_each do |item|
        return false if item =~ pattern
      end
    elsif pattern.is_a? Class
      my_arr.my_each do |item|
        return false if item.is_a? pattern
      end
    elsif pattern
      my_arr.my_each do |item|
        return false if item == pattern
      end
    elsif is_a? Array
      my_arr.my_each do |item|
        return false if yield(item)
      end
    elsif is_a? Hash
      my_arr.my_each do |k, v|
        return false if yield(k, v)
      end
    end
    true
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
