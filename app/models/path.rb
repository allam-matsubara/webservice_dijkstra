class Path < ActiveRecord::Base
  # Validations
  validates :point_a, :point_b, :distance, :name, presence: true

  # This method is just a interface between the controller and the logic to
  # solve the problem. It receives a hash of options and sets local variables
  # based on that hash. The hash contains the data that came from the 
  # controller.
  def self.shortest_path(options_hash = {})
    graph = Hash.new
    map_name    = options_hash["map_name"]
    origin      = options_hash["origin"]
    destination = options_hash["destination"]
    autonomy    = options_hash["autonomy"]
    consumption = options_hash["consumption"]
    
    vertices = get_all_vertices(map_name)
    vertices.each { |v| graph[v.to_sym] = Array.new(find_neighbours(map_name, v)) }
    dijkstra(graph, vertices, origin, destination)
  end

  private

    # XXX: This is not working currently
    # This method was intended to get as entry a graph, which is not a real
    # graph, is just a list of all the vertices, and it's neighbors that came
    # from find_neighbor method(more details are there). The idea was to use 
    # Dijkstra's algorithm to find optimal paths even in large graphs, and 
    # avoid a brute force algorithm that would take ages. Other algorithm 
    # options could be used like Bellman-Ford, but for this case, Dijsktra's
    # would have solved. To use this we need to make some assumptions, like,
    # the graph can't have edges with negative weight(in the context of this 
    # problem it makes no sense to have such thing) and, assumptions that I 
    # made, but are not essential for the algorithm is that the grah is 
    # connected(have no isolated nodes) and it have no direction, meaning 
    # that edges works in both directions from node A to B and from B to A. 
    #  
    def self.dijkstra(graph, vertices, origin, distination)
      shortest = Hash.new
      visited = Array.new
      path_cost = 0

      vertices.each do |v|
        shortest.store(v.to_sym, {weight: Float::INFINITY, via: nil})
      end

      until shortest.empty?
        source = shortest.fetch(origin.to_sym)
        source[:weight] = 0
        short = shortest.min_by { |v| v.last[:weight] }
        break if short.last[:weight] == Float::INFINITY
        shortest.delete(short)
        graph.fetch(short.first).each do |v|
          vert = v[:v].to_sym
          if shortest.include?(vert)
            alt = short.last[:weight] + graph.fetch(short.first)
          end
        end
      end
    end

    # This method simply receives the map name and look for all vertices 
    # contained on that map with that specific name. It returns an array with
    # all the node names without repetition.
    def self.get_all_vertices(map)
      vertices = Array.new

      where(name: map).each do |path|
        vertices.concat([path.point_a, path.point_b])
      end

      vertices.uniq
    end


    # This method receives the map name and a vertex(node) and returns all the
    # neighbors of that partivular node on that map with the distance between 
    # the node passed as argument and the neighbors, It returns an array of 
    # hashes that was the coice to hold more information, instead of a Struct 
    # object, or other possible objects. This method forms what we call a graph;
    # as stated above this isn't a graph, it's not a matrix or a list that is
    # usually used to hold graph data, but you can think of it as an adjacency
    # list, with the header of the list being a node name and the list nodes
    # carrying other nodes and its distancy between the header and the other 
    # nodes on the list.
    def self.find_neighbours(map, vertex)
      result = Array.new

      where("name = :map AND (point_a = :v OR point_b = :v)", {map: map, v: vertex}).
      each do |e|
        result << { v: (e.point_a == vertex ? e.point_b : e.point_a),
                      distance: e.distance }
      end

      result
    end
end
