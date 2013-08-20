require_relative 'decision_node'
require_relative 'tree_plot'

module Savanna
  class DecisionTree
  	attr_reader :dataset, :tree, :hash

    def initialize(dataset)
      @dataset = dataset
      @tree = Savanna::DecisionNode.new.build_tree(dataset)      
      @hash = Savanna::DecisionNode.hashify_tree(tree)
    end

    def show
      Savanna::TreePlot.new(hash).create_popup
    end

    def classify(observation)
      Savanna::DecisionNode.new.classify(observation, tree)
    end
  end
end
