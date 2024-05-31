class ApplicationController < ActionController::API
    before_action :init_buda_service

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
        mkt_id = spread_alert_params[:market_id]
        spread = spread_alert_params[:spread]
        user_data[mkt_id] = BigDecimal(spread)
        code = Rails.cache.write(user, user_data) ? :ok : service_unavailable
        render json: {user_alerts: user_data}, status: code
    end

    def poll_spread_alert
        user = request.remote_ip
        user_data = Rails.cache.read(user)
        mkt_id = params[:market_id]
        if user_data && user_data[mkt_id]
            saved_spread = user_data[mkt_id]
            spread_comp = @buda_service.compare_spread(mkt_id, saved_spread)
        end
        code = spread_comp ? :ok : :not_found
        render json: spread_comp, status: code
    end

    protected

    def init_buda_service
        @buda_service = BudaService.new
    end

    def spread_alert_params
        params.require(:alert).permit(:market_id, :spread)
    end
end
