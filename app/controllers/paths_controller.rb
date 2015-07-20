class PathsController < ApplicationController
  

  # This method expects a JSON which must contain two points, point_a and 
  # point_b, the distance between them and a map name to which those points 
  # belong .e.g;:
  #
  # '{
  #   "path" : {
  #     point_a: "A point",
  #     point_b: "B point",
  #     distance: number of km,
  #     name: "map_name",
  #   }
  # }'
  # This must be sent to our server using POST HTTP verb.
  def create
    path_params["path"].each do |p|
      @path = Path.new(p)

      unless @path.save
        render json: @path.errors, status: :unprocessable_entity
        return false
      end
    end
    
    head :created
  end

  # This method expects a JSON which must contain a map name, origin and 
  # destination points, autonomy and consumption, e.g.:
  #
  # '{
  #   "find_shortest" : {
  #     map_name: "map_x",
  #     origin: "A",
  #     destination: "B",
  #     autonomy: 20,
  #     consumption: 8.5
  #   }
  # }'
  # This must be sent to our server using POST HTTP verb.
  def find_shortest
    Path.shortest_path(path_params["find_shortest"])
  end

  private

    def set_path
      @path = Path.find(params[:id])
    end

    def path_params
      @json
    end
end
