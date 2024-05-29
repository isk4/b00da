# frozen_string_literal: true

require "net/http"

class BudaService
    def initialize
    end

    def get_markets
        markets_uri = URI("https://www.buda.com/api/v2/markets.json")
        res = Net::HTTP.get_response(markets_uri)
        if res.is_a?(Net::HTTPSuccess)
            res = JSON.parse(res.body)
            mkts = []

            res = res["markets"].each_with_index do | market, index |
                mkts << { "#{index + 1}": market["id"] }
            end
            
            return { markets: mkts }
        end
    end
end