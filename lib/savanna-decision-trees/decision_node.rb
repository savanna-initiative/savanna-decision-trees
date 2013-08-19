module Savanna
  class DecisionNode
    def initialize(col = -1, value = nil, results = nil, tb = nil, fb = nil)
      @col = col
      @value = value
      @results = results
      @tb = tb
      @fb = fb
    end
    
    def divide_set(rows, column, value)
      split_function = nil
      if value.class == Fixnum or value.class == Integer or value.class == Float
        split_function = Proc.new { |row| row[column] >= value }
       else
       	split_function = Proc.new { |row| row[column] == value }
      end
      set_one = rows.select { |row| split_function.call(row) == true }
      set_two = rows.select { |row| split_function.call(row) == false }
      return [set_one, set_two]
    end

    def count_uniq(rows, column)
      output = {}
      rows.each do |row|
        r = row[column].to_s
        output[r] ||= 0
        output[r] += 1
      end
      return output
    end
  end
end
