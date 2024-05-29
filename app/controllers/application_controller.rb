class ApplicationController < ActionController::API
    def index
        buda_service = BudaService.new
        markets = buda_service.get_markets

        render json: markets
    end
end
