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
                {"#{i + 1}": mkt["id"]}
            end
            
            return {markets: mkts}
        end
    end

    def get_spread(mkt_id)
        orders_uri = URI("https://www.buda.com/api/v2/markets/#{mkt_id}/order_book.json")
        res = Net::HTTP.get_response(orders_uri)

        if res.is_a?(Net::HTTPSuccess)
            order_book = JSON.parse(res.body)["order_book"]
            # Getting value of cheapest ask and most expensive bid
            sprd = Float(order_book["asks"][0][0]) - Float(order_book["bids"][0][0])
            return {spread: sprd, market_id: order_book["market_id"]}
        end
    end
end