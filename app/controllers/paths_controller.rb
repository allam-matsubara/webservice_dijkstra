class PathsController < ApplicationController
  before_action :decode_args, only: [:create, :find_shortest] 

  # This method expects a JSON which must contain two points, point_a and 
  # point_b, the distance between them and a map name to which those points 
  # belong .e.g;:
  #
  # '{
  #   "path" : [{
  #     point_a: "A point",
  #     point_b: "B point",
  #     distance: number of km,
  #     name: "map_name",
  #   }]
  # }'
  #
  # NOTE: ensure that you encapsulate the path value ofthe hash into an array.
  # This is required to allow saving multiple points at once.
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
  #     fuel_cost: 2.9
  #   }
  # }'
  # This must be sent to our server using POST HTTP verb.
  def find_shortest
    @path = Path.shortest_path(path_params["find_shortest"])

    if @path
      render json: @path.to_json, status: :ok
    else
      render json: {}.to_json, status: :unprocessable_entity
    end
    
  end

  private

    def path_params
      @json
    end
end
