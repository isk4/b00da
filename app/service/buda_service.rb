# frozen_string_literal: true

require "net/http"
require "bigdecimal"

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
            unless order_book["asks"].empty? || order_book["bids"].empty?
                # Getting value of cheapest ask and most expensive bid
                sprd = BigDecimal(order_book["asks"][0][0]) - BigDecimal(order_book["bids"][0][0])
                return {spread: {value: sprd, market_id: order_book["market_id"]}}
            end
        end
    end

    def get_all_spreads
        mkts = get_markets[:markets]
        mkt_ids = mkts.map { | mkt | mkt[:id] }

        sprds = mkt_ids.map do | mkt_id |
            sprd = get_spread(mkt_id)
            sprd = sprd[:spread][:value] unless sprd.nil?
            [mkt_id, sprd]
        end
        return {spreads: sprds.to_h}
    end
end 