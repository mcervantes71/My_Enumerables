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
