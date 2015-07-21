class Path < ActiveRecord::Base
  # Defining a new data type to hold node information
  # for usage of this structure inside ths model decalre a node as 
  # Struct::Vertex, e.g.:
  #
  # v = Struct::Vertex.new
  #
  # And them use the dot operator(.) to access itś fields like this:
  #
  # v.name = <node name>
  # v.dist = <number>
  # v.prev = <another node>
  Vertex = Struct.new(:name, :dist, :prev)

  # Validations
  validates :point_a, :point_b, :distance, :name, presence: true
  

  # This method is just a interface between the controller and the logic to
  # solve the problem. It receives a hash of options and sets local variables
  # based on that hash. The hash contains the data that came from the 
  # controller.
  def self.shortest_path(options_hash = {})
    graph = Hash.new
    source_node = Vertex.new
    nodes = String.new

    map_name    = options_hash["map_name"]
    origin      = options_hash["origin"].to_sym
    destination = options_hash["destination"].to_sym
    autonomy    = options_hash["autonomy"]
    fuel_cost   = options_hash["fuel_cost"]
    
    vertices = get_all_vertices(map_name)
    
    vertices.each do |v| 
      graph[v.name.to_sym] = Array.new(find_neighbours(map_name, v.name))
      source_node = v if v.name.to_sym == origin
    end
    source_node.dist = 0
    path = dijkstra(graph, vertices, source_node, destination)

    encapsulate(path, autonomy, fuel_cost)
  end

  private

  # This method is used to isolate values returning logic from shortest_path
  # method. It receives the path generated from Dijkstra's algorithm, autonomy
  # and fuel_cost of the truck. With that, it processes the results and returns
  # a Hash with cost and path.
  def self.encapsulate(path, autonomy, fuel)
    result = Array.new
    node   = path

    while node.present?
      result << node.name
      node = node.prev
    end

    cost = (path.dist.to_f / autonomy.to_f) * fuel.to_f

    {route: result.reverse.join(" "), cost: cost}
  end

  # This method is intended to get as entry a graph, which is not a real
  # graph, is just a list of all the vertices, and it's neighbors that came
  # from find_neighbor method(more details are there). The idea is to use 
  # Dijkstra's algorithm to find optimal paths even in large graphs. Other 
  # algorithm options could be used like Bellman-Ford, but for this case, 
  # Dijsktra's solves our problem. To use this we need to make some assumptions, 
  # like, the graph can't have edges with negative weight(in the context of 
  # this problem it makes no sense to have such thing) and it have no direction,
  # meaning that edges works in both directions from node A to B and from B 
  # to A. The return value is either a Struct::Vertex object containing the 
  # path and wight of the shortest path, or nil, in case if it doesn't. Nil 
  # will be returned in case of diconnected graphs, and the origin and 
  # destination nodes are in different connected components.
  def self.dijkstra(graph, unvisited, source, destination)
    visited = Array.new

    while unvisited.present?
      u = unvisited.min_by { |v| v.dist }
      unvisited.delete(u)

      graph.fetch(u.name.to_sym).each do |adj|
        next if visited.include?(adj[:v])
        
        neighbor = unvisited.select { |v| v.name == adj[:v] }.first
        weight = u.dist + adj[:distance]
        if weight <= neighbor.dist
          neighbor.dist = weight
          neighbor.prev = u
        end
      end
      visited << u.name
     
      return u if u.name.to_sym == destination
    end
    
    nil
  end

  # This method simply receives the map name and look for all vertices 
  # contained on that map with that specific name. It returns an array with
  # all the node names without repetition.
  def self.get_all_vertices(map)
    vertices = Array.new

    where(name: map).each do |path|
      vertex_a = Vertex.new()
      vertex_b = Vertex.new()

      vertex_a.name = path.point_a
      vertex_a.dist = Float::INFINITY
      vertex_a.prev = nil
      vertex_b.name = path.point_b
      vertex_b.dist = Float::INFINITY 
      vertex_b.prev = nil

      vertices.concat([vertex_a, vertex_b])
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
      result << { 
        v: (e.point_a == vertex ? e.point_b : e.point_a),
        distance: e.distance 
      }
    end

    result
  end
end
