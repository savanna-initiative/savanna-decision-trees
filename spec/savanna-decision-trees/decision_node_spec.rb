require 'spec_helper'

module Savanna
  describe DecisionNode do
    before(:all) do
      @dataset = [[100, 'old'], [1, 'young'], [10, 'young'], [80, 'old']]
    end
    
    it 'should devide set' do
      Savanna::DecisionNode.new.divide_set(@dataset,1,'young').should == [[[1, 'young'], [10, 'young']],[[100, 'old'], [80, 'old']]]
    end
  end
end
