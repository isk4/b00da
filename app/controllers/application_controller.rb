class ApplicationController < ActionController::API
    before_action :initialize_buda_service

    def markets
        markets = @buda_service.get_markets
        # markets = {message: "error"} if markets.nil?
        code = markets.nil? ? :service_unavailable : :ok
        render json: markets, status: code
    end

    def spread
        mkt_id = params[:market_id]
        spread = @buda_service.get_spread(mkt_id)
        # spread = {message: "error"} if spread.nil?
        code = spread.nil? ? :service_unavailable : :ok
        render json: spread, status: code
    end

    def all_spreads
        spreads = @buda_service.get_all_spreads
        code = spreads.nil? ? :service_unavailable : :ok
        render json: spreads, status: code
    end

    def save_spread_alert
        user = request.remote_ip
        user_data = Rails.cache.fetch(user) { {} }
        mkt_id = params[:market_id]
        spread = params[:spread]
        user_data[mkt_id] = spread
        Rails.cache.write(user, user_data)
    end

    def poll_spread_alert
        user = request.remote_ip
        user_data = Rails.cache.read(user)
        mkt_id = params[:market_id]
        if user_data && user_data[mkt_id]
            saved_spread = BigDecimal(user_data[mkt_id])
            spread_comp = @buda_service.compare_spread(mkt_id, saved_spread)
            render json: spread_comp
        end
    end

    protected

    def initialize_buda_service
        @buda_service = BudaService.new
    end
end
