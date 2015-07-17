class ApplicationController < ActionController::API
  
  private

  def decode_args
    @json = JSON.parse(request.body.read)
  end
end
