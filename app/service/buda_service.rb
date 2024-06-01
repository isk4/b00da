# frozen_string_literal: true

require "net/http"

class BudaService
    def get_markets
        mkts_uri = URI("https://www.buda.com/api/v2/markets.json")
        res = Net::HTTP.get_response(mkts_uri)

        if !res.is_a?(Net::HTTPSuccess)
            return {message: "error", code: :service_unavailable}
        else
            mkts = JSON.parse(res.body)["markets"]
            mkts = mkts.map { |mkt| mkt["id"] }
            return {markets: mkts, code: :ok}
        end
    end

    def get_spread(mkt_id)
        orders_uri = URI("https://www.buda.com/api/v2/markets/#{mkt_id}/order_book.json")
        res = Net::HTTP.get_response(orders_uri)

        if !res.is_a?(Net::HTTPSuccess)
            return {message: "error", code: status_code_to_sym(res.code.to_i)}
        else
            order_book = JSON.parse(res.body)["order_book"]
            sprd = nil
            unless order_book["asks"].empty? || order_book["bids"].empty?
                sprd = BigDecimal(order_book["asks"][0][0]) - BigDecimal(order_book["bids"][0][0])
            end
            return {spread: {value: sprd, market_id: order_book["market_id"]}, code: :ok}
        end
    end

    def get_all_spreads
        mkts = get_markets

        if mkts[:code] != :ok
            return {message: "error", code: :service_unavailable}
        else
            sprds = mkts[:markets].map do | mkt_id |
                sprd = get_spread(mkt_id)
                return {message: "error", code: sprd[:code]} if sprd[:code] != :ok
                [mkt_id, sprd[:spread][:value]]
            end
            return {spreads: sprds.to_h, code: :ok}
        end
    end

    def save_spread_alert(user, mkt_id, sprd)
        mkts = get_markets

        if mkts[:code] != :ok
            return {message: "error", code: service_unavailable}
        else
            if !mkts[:markets].include?(mkt_id)
                return {message: "error", code: :bad_request}
            else
                user_data = Rails.cache.fetch(user) { {} }
                user_data[mkt_id] = BigDecimal(sprd)
                
                if Rails.cache.write(user, user_data)
                    return {user_alerts: user_data, code: :ok}
                else
                    return {message: "error", code: :internal_server_error}
                end
            end
        end

    end

    def compare_spread(user, mkt_id)
        sprd = get_spread(mkt_id)

        if sprd[:code] != :ok
            return {message: "error", code: sprd[:code]}
        else
            user_data = Rails.cache.read(user)
            saved_sprd = user_data[mkt_id]

            if user_data.nil? || saved_sprd.nil?
                return {message: "error", code: :not_found}
            else
                curr_sprd = sprd[:spread][:value]
    
                msg = if curr_sprd > saved_sprd
                    "greater"
                elsif curr_sprd < saved_sprd
                    "less"
                else
                    "equal"
                end
    
                diff = - (saved_sprd - curr_sprd) 
                return {
                    spread_comp: {
                        market_id: mkt_id,
                        comparison: msg,
                        difference: diff,
                        current_spread: curr_sprd,
                        alert_spread: saved_sprd
                    },
                    code: :ok
                }
            end
        end
    end

    protected

    def status_code_to_sym(code)
        Rack::Utils::HTTP_STATUS_CODES[code].gsub(" ", "_").downcase.to_sym
    end
end 