class ApplicationController < ActionController::API
  
  private

    # This method gets the body of the requests to the API that must all have 
    # parameters in JSON format and parses it. This is used in some actions on 
    # the paths_controller, and the actions that this method must be applied 
    # are defined on that controller. It takes no arguments and the return is 
    # an assigned variable with parsed JSON.
    def decode_args
      @json = JSON.parse(request.body.read)
    end
end
