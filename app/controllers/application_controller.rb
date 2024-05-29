class ApplicationController < ActionController::API
    def index
        buda_service = BudaService.new
        markets = buda_service.get_markets
        markets = {message: "error"} if markets.nil?
        render json: markets
    end
end
