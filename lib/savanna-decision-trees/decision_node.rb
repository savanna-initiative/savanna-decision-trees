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

    def count_uniq(rows, column = nil)
      column ||= rows.first.size - 1
      output = {}
      rows.each do |row|
        r = row[column].to_s
        output[r] ||= 0
        output[r] += 1
      end
      return output
    end

    def gini_impurity(rows, column = nil)
      total = rows.size
      counts = count_uniq(rows, column)
      imp = 0
      counts.each_key do |key_one|
        p_one = counts[key_one].to_f/total
        counts.each_key do |key_two|
          next if key_one == key_two
          p_two = counts[key_two].to_f/total
          imp += p_one*p_two
        end
      end
      return imp
    end

    def entropy(rows, column = nil)
      log_two = Proc.new { |x| Math.log(x)/Math.log(2) }
      results = count_uniq(rows, column)
      ent = 0.0
      results.each_key do |r|
        p = results[r].to_f/rows.size
        ent = ent - p*log_two.call(p)
      end
      return ent
    end
  end
end
