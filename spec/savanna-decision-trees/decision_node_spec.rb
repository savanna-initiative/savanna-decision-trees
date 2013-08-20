require 'spec_helper'

module Savanna
  describe DecisionNode do
    before(:all) do
      @dataset_simple = [[100, 'old'], [1, 'young'], [10, 'young'], [80, 'old']]
      @dataset_large = [['slashdot','USA','yes',18,'None'],
                        ['google','France','yes',23,'Premium'],
                        ['digg','USA','yes',24,'Basic'],
                        ['kiwitobes','France','yes',23,'Basic'],
                        ['google','UK','no',21,'Premium'],
                        ['(direct)','New Zealand','no',12,'None'],
                        ['(direct)','UK','no',21,'Basic'],
                        ['google','USA','no',24,'Premium'],
                        ['slashdot','France','yes',19,'None'],
                        ['digg','USA','no',18,'None'],
                        ['google','UK','no',18,'None'],
                        ['kiwitobes','UK','no',19,'None'],
                        ['digg','New Zealand','yes',12,'Basic'],
                        ['slashdot','UK','no',21,'None'],
                        ['google','UK','yes',18,'Basic'],
                        ['kiwitobes','France','yes',19,'Basic']]
    end

    it 'should devide set' do
      Savanna::DecisionNode.new.divide_set(@dataset_simple,1,'young').should == [[[1, 'young'], [10, 'young']],[[100, 'old'], [80, 'old']]]
    end

    it 'should count elements' do
      Savanna::DecisionNode.new.count_uniq(@dataset_simple,1).should == {'old' => 2, 'young' => 2}
      Savanna::DecisionNode.new.count_uniq(@dataset_simple,0).should ==  {'100'=>1, '1'=>1, '10'=>1, '80'=>1}
      Savanna::DecisionNode.new.count_uniq(@dataset_simple).should == {'old' => 2, 'young' => 2}
    end

    it 'should calculate gini impurity' do
      Savanna::DecisionNode.new.gini_impurity(@dataset_simple, 1).should == 0.5
      Savanna::DecisionNode.new.gini_impurity(@dataset_simple, 0).should == 0.75
      Savanna::DecisionNode.new.gini_impurity(@dataset_large).should == 0.6328125
    end

    it 'should calculate entropy' do
      Savanna::DecisionNode.new.entropy(@dataset_simple).should == 1.0
      Savanna::DecisionNode.new.entropy(@dataset_simple, 0).should == 2.0
      Savanna::DecisionNode.new.entropy(@dataset_large).should == 1.5052408149441479
    end

    it 'should build a tree' do
      tree = Savanna::DecisionNode.new.build_tree(@dataset_large)
      tree.col.should == 0
      tree.value.should == 'google'      
        tree.tb.col.should == 3
        tree.tb.value.should == 21          
          tree.tb.tb.col.should == nil
          tree.tb.tb.value.should == nil
          tree.tb.tb.results.should == { 'Premium' => 3 }
          tree.tb.fb.col.should == 2
          tree.tb.fb.value.should == 'no'        
          tree.tb.fb.results.should == nil
            tree.tb.fb.tb.col.should == nil
            tree.tb.fb.tb.value.should == nil
            tree.tb.fb.tb.results.should == { 'None' => 1 }
            tree.tb.fb.fb.col.should == nil
            tree.tb.fb.fb.value.should == nil
            tree.tb.fb.fb.results.should == { 'Basic' => 1 }
        tree.fb.col.should == 0
        tree.fb.value.should == 'slashdot'
          tree.fb.tb.col.should == nil
          tree.fb.tb.value.should == nil
          tree.fb.tb.results.should == { 'None' => 3 }
          tree.fb.fb.col.should == 2
          tree.fb.fb.value.should == 'yes'        
          tree.fb.fb.results.should == nil
            tree.fb.fb.tb.col.should == nil
            tree.fb.fb.tb.value.should == nil
            tree.fb.fb.tb.results.should == { 'Basic' => 4 }
            tree.fb.fb.fb.col.should == 3
            tree.fb.fb.fb.value.should == 21
            tree.fb.fb.fb.results.should == nil
              tree.fb.fb.fb.tb.col.should == nil
              tree.fb.fb.fb.tb.value.should == nil
              tree.fb.fb.fb.tb.results.should == { 'Basic' => 1 }             
              tree.fb.fb.fb.fb.col.should == nil
              tree.fb.fb.fb.fb.value.should == nil
              tree.fb.fb.fb.fb.results.should == { 'None' => 3 }
    end
  end
end
