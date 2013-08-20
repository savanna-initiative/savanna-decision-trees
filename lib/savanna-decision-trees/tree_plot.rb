require 'green_shoes'
require 'rubyvis'
require 'json'    

module Savanna
  class TreePlot
    attr_reader :width, :height, :tree

    def initialize(tree = {'No Data' => nil}, width = 800, height = 600)
      ENV['savanna-plot-width']  = width.to_s
      ENV['savanna-plot-height'] = height.to_s
      ENV['savanna-plot-tree']   = tree.to_json
      ENV['savanna-plot-svg'] = generate_svg
      @width = width
      @height = height
      @tree = ENV['savanna-plot-tree'] = tree.to_json
    end

    def generate_svg
      vis = Rubyvis::Panel.new do
        tree = JSON.parse ENV['savanna-plot-tree']
        width = ENV['savanna-plot-width'].to_f
        height = ENV['savanna-plot-height'].to_f
        root = 'root';width(width);height(height);left(100);right(160);top(10);bottom(10)
        layout_cluster do
          nodes pv.dom(tree).root(root).sort(lambda {|a,b| a.node_name<=>b.node_name}).nodes
          group(0.2); orient("left")
          link.line { stroke_style("lightgrey"); line_width(9); antialias(true) }
          node.dot { stroke_style("black"); fill_style("#ff7f0e") }
          node_label.label { text_style("black"); font_size("20px") }
        end
      end
      vis.render; 
      return vis.to_svg
    end

    def create_popup      
      Shoes.app title: 'Custom Plot :: Savanna Decision Trees', width: width, height: height do        
        img = image(ENV['savanna-plot-svg'], width: width, height: height)
      end      
    end
  end
end
