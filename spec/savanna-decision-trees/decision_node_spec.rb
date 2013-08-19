require 'spec_helper'

module Savanna
  describe DecisionNode do
    before(:all) do
      @dataset = [[100, 'old'], [1, 'young'], [10, 'young'], [80, 'old']]
    end

    it 'should devide set' do
      Savanna::DecisionNode.new.divide_set(@dataset,1,'young').should == [[[1, 'young'], [10, 'young']],[[100, 'old'], [80, 'old']]]
    end

    it "should count elements" do
      Savanna::DecisionNode.new.count_uniq(@dataset,1).should == {"old" => 2, "young" => 2}
      Savanna::DecisionNode.new.count_uniq(@dataset,0).should ==  {"100"=>1, "1"=>1, "10"=>1, "80"=>1}
    end
  end
end
