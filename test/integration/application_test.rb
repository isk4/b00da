# frozen_string_literal: true
require "test_helper"

class ApplicationTest < ActionDispatch::IntegrationTest
    test "connection to Buda markets" do
        get "/markets"
        assert_response :success
    end

    test "getting single market spread" do
        get "/spread/BTC-CLP"
        assert_response :success
    end

    test "getting all spreads" do
        get "/spreads"
        assert_response :success
    end

    test "saving spread alert and polling about it" do
        post "/spread_alert", params: {alert: {market_id: "BTC-CLP", spread: 1000}}
        assert_response :success
        get "/spread_alert/BTC-CLP"
        assert_response :success
    end
end