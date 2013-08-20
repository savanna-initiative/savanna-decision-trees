require 'spec_helper'

module Savanna
  describe DecisionNode do
    before(:all) do
      @dataset = [[100, 'old'], [1, 'young'], [10, 'young'], [80, 'old']]
    end

    it 'should devide set' do
      Savanna::DecisionNode.new.divide_set(@dataset,1,'young').should == [[[1, 'young'], [10, 'young']],[[100, 'old'], [80, 'old']]]
    end

    it 'should count elements' do
      Savanna::DecisionNode.new.count_uniq(@dataset,1).should == {"old" => 2, "young" => 2}
      Savanna::DecisionNode.new.count_uniq(@dataset,0).should ==  {"100"=>1, "1"=>1, "10"=>1, "80"=>1}
      Savanna::DecisionNode.new.count_uniq(@dataset).should == {"old" => 2, "young" => 2}
    end

    it 'should calculate gini impurity' do
      Savanna::DecisionNode.new.gini_impurity(@dataset).should == 0.5
      Savanna::DecisionNode.new.gini_impurity(@dataset, 0).should == 0.75
    end

    it 'should calculate entropy' do
      Savanna::DecisionNode.new.entropy(@dataset, 1).should == 1.0
      Savanna::DecisionNode.new.entropy(@dataset, 0).should == 2.0
    end
  end
end
