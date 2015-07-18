class Path < ActiveRecord::Base
  # Validations
  validates :point_a, :point_b, :distance, :name, presence: true

  def self.shortest_path(options_hash = {})
    map_name    = options_hash["map_name"]
    origin      = options_hash["origin"]
    destination = options_hash["destination"]
    autonomy    = options_hash["autonomy"]
    consumption = options_hash["consumption"]

    routes = where(name: map_name)
    dijkstra(routes, origin, destination)
  end

  private

    def self.dijkstra(routes, origin, distination)
      edges = Array.new
      routes.each do |route|
        edges << [route.point_a, route.point_b, route.distance]
      end

      print edges
    end
end
