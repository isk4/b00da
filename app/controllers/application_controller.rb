class ApplicationController < ActionController::API
    before_action :initialize_buda_service

    def index
        markets = @buda_service.get_markets
        markets = {message: "error"} if markets.nil?
        render json: markets
    end

    def spread
        mkt_id = params[:market_id]
        spread = @buda_service.get_spread(mkt_id)
        spread = {message: "error"} if spread.nil?
        render json: spread 
    end

    def all_spreads
        spreads = @buda_service.get_all_spreads
        render json: spreads
    end

    protected

    def initialize_buda_service
        @buda_service = BudaService.new
    end
end
