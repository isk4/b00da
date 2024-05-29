class ApplicationController < ActionController::API
    before_action :initialize_buda_service

    def markets
        markets = @buda_service.get_markets
        markets = {message: "error"} if markets.nil?
        code = markets.nil? ? :service_unavailable : :ok
        render json: markets, status: code
    end

    def spread
        mkt_id = params[:market_id]
        spread = @buda_service.get_spread(mkt_id)
        spread = {message: "error"} if spread.nil?
        code = spread.nil? ? :service_unavailable : :ok
        render json: spread, status: code
    end

    def all_spreads
        spreads = @buda_service.get_all_spreads
        code = spreads.nil? ? :service_unavailable : :ok
        render json: spreads, status: code
    end

    protected

    def initialize_buda_service
        @buda_service = BudaService.new
    end
end
