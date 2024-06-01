class ApplicationController < ActionController::API
    before_action :init_buda_service

    def markets
        markets = @buda_service.get_markets
        code = markets[:code]
        market.delete(:code) unless markets[:message] == "error"
        render json: markets, status: code
    end

    def spread
        mkt_id = params[:market_id]
        spread = @buda_service.get_spread(mkt_id)
        code = spread[:code]
        spread.delete(:code) unless spread[:message] == "error"
        render json: spread, status: code
    end

    def all_spreads
        spreads = @buda_service.get_all_spreads
        code = spreads[:code]
        spreads.delete(:code) unless spreads[:message] == "error"
        render json: spreads, status: code
    end

    def save_spread_alert
        user = request.remote_ip
        mkt_id = spread_alert_params[:market_id]
        spread = spread_alert_params[:spread]
        alert = @buda_service.save_spread_alert(user, mkt_id, spread)
        code = alert[:code]
        alert.delete(:code) unless alert[:message] == "error"
        render json: alert, status: code
    end

    def poll_spread_alert
        user = request.remote_ip
        mkt_id = params[:market_id]
        sprd_comp = @buda_service.compare_spread(user, mkt_id)
        code = sprd_comp[:code]
        sprd_comp.delete(:code) unless sprd_comp[:message] == "error"
        render json: sprd_comp, status: code
    end

    protected

    def init_buda_service
        @buda_service = BudaService.new
    end

    def spread_alert_params
        params.require(:alert).permit(:market_id, :spread)
    end
end
