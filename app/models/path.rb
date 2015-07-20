class Path < ActiveRecord::Base
  # Validations
  validates :point_a, :point_b, :distance, :name, presence: true

  def self.shortest_path(options_hash = {})
    graph = Hash.new
    map_name    = options_hash["map_name"]
    origin      = options_hash["origin"]
    destination = options_hash["destination"]
    autonomy    = options_hash["autonomy"]
    consumption = options_hash["consumption"]
    
    vertices = get_all_vertices(map_name)
    vertices.each { |v| graph[v.to_sym] = Array.new(find_neighbours(map_name, v)) }

    #dijkstra(map_name, origin, destination)
  end

  def self.dijkstra(map, origin, distination)
    edges  = Array.new
    path   = Array.new
    weight = Array.new
  end

  def self.get_all_vertices(map)
    vertices = Array.new

    where(name: map).each do |path|
      vertices.concat([path.point_a, path.point_b])
    end

    vertices.uniq
  end

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
