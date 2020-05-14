#!/usr/bin/env ruby

# frozen_string_literal: true

#
# Extending Enumerable module with replicated methods for the following:
# each, each_with_index, select, all?, any? none?, count, map and inject
#
module Enumerable
  def my_each
    entry = is_a?(Range) ? to_a : self

    if block_given?
      entry.length.times { |i| yield(entry[i]) }
    else
      entry.to_enum
    end
  end

  def my_each_with_index
    entry = is_a?(Range) ? to_a : self

    if block_given?
      entry.length.times { |i| yield(i, entry[i]) }
    else
      entry.to_enum :each_with_index
    end
  end

  def my_select
    entry = is_a?(Range) ? to_a : self
    output = []

    if block_given?
      my_each { |i| (yield i) == true ? output << i : output }
      output
    else
      entry.to_enum :select
    end
  end

  def my_all?(*args, &block)
    entry = is_a?(Range) ? to_a : self
    result = true

    if entry.empty?
      result = true
    elsif !args[0].nil?
      if args[0].is_a? Class
        entry.my_each { |i| result = false unless i.is_a?(args[0]) }
      elsif args[0].is_a?(Regexp)
        entry.my_each { |i| result = false unless args[0].match(i) }
      else
        entry.my_each { |i| result = false unless i == args[0] }
      end
    elsif !block.nil?
      entry.my_each { |i| result = false unless block.call(i) }
    else
      entry.my_each { |i| result = false unless i }
    end

    result
  end

  def my_any?(*args, &block)
    entry = is_a?(Range) ? to_a : self
    result = false

    if entry.empty?
      result = false
    elsif !args[0].nil?
      if args[0].is_a? Class
        entry.my_each { |i| result = true if i.is_a?(args[0]) }
      elsif args[0].is_a?(Regexp)
        regex = entry.join(' ')
        result = true if regex =~ args[0]
      else
        entry.my_each { |i| result = true if i == args[0] }
      end
    elsif !block.nil?
      entry.my_each { |i| result = true if block.call(i) }
    else
      entry.my_each { |i| result = true if i }
    end

    result
  end

  def my_count(arg = nil)
    entry = is_a?(Range) ? to_a : self
    count = 0

    if block_given?
      my_each { |i| count += 1 if yield(i) }
    elsif arg
      my_each { |i| count += 1 if i == arg }
    else
      count = entry.length
    end

    count
  end

  def my_map(proc = nil)
    entry = is_a?(Range) ? to_a : self
    output = []

    if !proc.nil?
      entry.my_each { |i| output << proc.call(i) }
    elsif block_given?
      entry.my_each { |i| output << yield(i) }
    else
      result = entry.to_enum :map
    end

    !result.is_a?(Enumerator) ? output : result
  end
end

test_array1 = [11, 2, 3, 56]

test_array2 = %w[a b c d]

true_array = [1, true, 'hi', []]

false_array = [nil, false, nil, false]

words = %w[dog door rod blade]

# my_each

p '* * * * * * *       my_each       * * * * * * *'

test_array1.my_each { |x| p x }

test_array2.my_each { |x| p x }

p test_array2.my_each

array = [1, 2, 3, 5, 1, 7, 3, 4, 5, 7, 2, 3, 2, 0, 8, 8, 7, 8, 1, 6, 1, 1, 7, 2,
         1, 2, 5, 8, 6, 0, 4, 5, 8, 2, 2, 5, 4, 7, 3, 4, 3, 3, 8, 5, 1, 0, 3, 7,
         5, 5, 7, 2, 6, 7, 7, 0, 4, 4, 0, 2, 0, 6, 6, 8, 1, 6, 8, 6, 2, 3, 6, 1,
         5, 2, 6, 7, 2, 5, 8, 2, 0, 7, 3, 2, 3, 6, 1, 2, 8, 3, 7, 0, 5, 0, 0, 2,
         6, 1, 5, 2]

my_each_output = ''

block = proc { |num| my_each_output += num.to_s }

array.my_each(&block)

p my_each_output

p '* * * * *     my_each_with_index     * * * * *'

test_array1.my_each_with_index { |x, y| p "item[#{x}] -> #{y}" }

p test_array2.my_each_with_index

p '* * * * * * *       my_select       * * * * * * *'

p test_array1.my_select(&:even?)

p test_array2.my_select { |x| x == 'c' }

p [1, 2, 3, 4, 5].my_select { |num| num.even? }

p [1, 2, 3, 4, 5].my_select { |num| num.odd? }

p [1, 2, 3, 4, 5].my_select { |num| num > 4 }

p test_array2.my_select

p '* * * * * * *       my_all       * * * * * * *'

p (%w[ant bear cat]).my_all? { |word| word.length >= 3 }

p (%w[ant bear cat]).my_all? { |word| word.length >= 4 }

p %w[ant bear cat].my_all?(/t/)

p [1, 2].my_all?(Numeric)

p [1, 2].my_all?(String)

p [1, 2].my_all?(1)

p [1, 1].my_all?(1)

p true_array.my_all?

p words.my_all?(/d/)

p %w[ant bear cat].my_all?(/t/)

p %w[ant tiger cat].my_all?(/t/)

p '* * * * * * *       my_any       * * * * * * *'

p %w[ant bear cat].my_any? { |word| word.length >= 3 }

p %w[ant bear cat].my_any? { |word| word.length >= 4 }

p %w[ant bear cat].my_any?(/d/)

p [nil, true, 99].my_any?(Integer)

p [nil, true, 99].my_any?

p [].my_any?

p [1, 2, 3, 's'].my_any?(String)

p [1, 2, 3, 's'].my_any?(Numeric)

p [1, 2, 3].my_any?(String)

p [1, 2].my_any?(1)

p [1, 1].my_any?(1)

p false_array.my_any?

p words.my_any?(/d/)

p '* * * * * * *       my_count       * * * * * * *'

ary = [1, 2, 4, 2]

p ary.my_count

p ary.my_count(9)

p ary.my_count(2)

p ary.my_count(&:even?)

p '* * * * * * *       my_map       * * * * * * *'

arr = [1, 2, 7, 4, 5]

p arr.my_map { |x| x * x }

p (1..2).my_map { |x| x * x }

myMapP = Proc.new { |x| x * x }

p arr.my_map (myMapP)

myMapP = Proc.new { |x| x * 2 }

p arr.my_map (myMapP) { |x| x * x}

p array.my_map
