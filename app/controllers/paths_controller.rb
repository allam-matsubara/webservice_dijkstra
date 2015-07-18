class PathsController < ApplicationController
  before_action :set_path, only: [:show, :update, :destroy]
  before_action :decode_args, only: [:create, :find_shortest]

  # GET /paths
  # GET /paths.json
  def index
    @paths = Path.all

    render json: @paths
  end
  
  # POST /paths
  # POST /paths.json
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

  # PATCH/PUT /paths/1
  # PATCH/PUT /paths/1.json
  def update
    @path = Path.find(params[:id])

    if @path.update(path_params)
      head :no_content
    else
      render json: @path.errors, status: :unprocessable_entity
    end
  end

  # DELETE /paths/1
  # DELETE /paths/1.json
  def destroy
    @path.destroy

    head :no_content
  end

  private

    def set_path
      @path = Path.find(params[:id])
    end

    def path_params
      @json
    end
end
