module Savanna
  class DecisionNode
  	attr_reader :col, :value, :results, :tb, :fb

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
      return 0.0 if rows.size == 0
      log_two = Proc.new { |x| Math.log(x)/Math.log(2) }
      results = count_uniq(rows, column)
      ent = 0.0
      results.each_key do |r|
        p = results[r].to_f/rows.size
        ent = ent - p*log_two.call(p)
      end
      return ent
    end

    def build_tree(rows)
      return DecisionNode.new if rows.size == 0
      current_score = entropy(rows)
      best_gain = 0.0
      best_criteria = nil
      best_sets = nil
      column_count = rows[0].size - 2
      (0..column_count).to_a.each do |col|
        column_values = {}
        rows.each {|row| column_values[row[col]] = 1}
        column_values.each_key do |value|
          devided_set = divide_set(rows,col,value)
          set_one = devided_set[0]
          set_two = devided_set[1]
          p = set_one.size.to_f/rows.size
          gain = current_score - p*entropy(set_one) - (1 - p)*entropy(set_two)          
          if gain > best_gain && set_one.size > 0 && set_two.size > 0
            best_gain = gain
            best_criteria = [col, value]
            best_sets = [set_one, set_two]
          end
        end
      end
      if best_gain > 0
        true_branch = build_tree(best_sets[0])
        false_branch = build_tree(best_sets[1])
        return DecisionNode.new(best_criteria[0], best_criteria[1], nil, true_branch, false_branch)
       else
       	return DecisionNode.new(nil, nil, count_uniq(rows), nil, nil)
      end
    end
  end
end
