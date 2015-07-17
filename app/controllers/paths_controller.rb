class PathsController < ApplicationController
  before_action :set_path, only: [:show, :update, :destroy]
  before_action :decode_args, only: [:create, :update]

  # GET /paths
  # GET /paths.json
  def index
    @paths = Path.all

    render json: @paths
  end

  # GET /paths/1
  # GET /paths/1.json
  def show
    render json: @path
  end

  # POST /paths
  # POST /paths.json
  def create
    @path = Path.new(path_params)

    if @path.save
      render json: @path, status: :created, location: @path
    else
      render json: @path.errors, status: :unprocessable_entity
    end
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
      @json["path"]
    end
end
