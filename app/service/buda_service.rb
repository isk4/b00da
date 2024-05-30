# frozen_string_literal: true

require "net/http"

class BudaService
    def initialize
    end

    def get_markets
        mkts_uri = URI("https://www.buda.com/api/v2/markets.json")
        res = Net::HTTP.get_response(mkts_uri)

        if res.is_a?(Net::HTTPSuccess)
            mkts = JSON.parse(res.body)["markets"]
            mkts = mkts.map.with_index do | mkt, i |
                {id: mkt["id"], number: "#{i + 1}"}
            end
            return {markets: mkts}
        end
    end

    def get_spread(mkt_id)
        orders_uri = URI("https://www.buda.com/api/v2/markets/#{mkt_id}/order_book.json")
        res = Net::HTTP.get_response(orders_uri)

        if res.is_a?(Net::HTTPSuccess)
            order_book = JSON.parse(res.body)["order_book"]
            sprd = nil
            # Getting value of cheapest ask and most expensive bid
            unless order_book["asks"].empty? || order_book["bids"].empty?
                sprd = BigDecimal(order_book["asks"][0][0]) - BigDecimal(order_book["bids"][0][0])
            end
            return {spread: {value: sprd, market_id: order_book["market_id"]}}
        end
    end

    def get_all_spreads
        mkts = get_markets
        unless mkts.nil?
            mkt_ids = mkts[:markets].map { | mkt | mkt[:id] }
            sprd_error = false
            sprds = mkt_ids.map do | mkt_id |
                sprd = get_spread(mkt_id)
                sprd.nil? ? sprd_error = true : sprd = sprd[:spread][:value]
                [mkt_id, sprd]
            end
            return sprd_error ? nil : {spreads: sprds.to_h}
        end
    end

    def compare_spread(mkt_id, saved_value)
        sprd = get_spread(mkt_id)
        if sprd
            curr_value = sprd[:spread][:value]            
            msg = if curr_value > saved_value
                "greater"
            elsif curr_value < saved_value
                "less"
            else
                "equal"
            end
            diff = - (saved_value - curr_value) 
            return {spread: {
                market_id: mkt_id,
                comparison: msg,
                difference: diff,
                current_spread: curr_value,
                alert_spread: saved_value
            }}
        end
    end
end 