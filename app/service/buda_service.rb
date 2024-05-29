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
end