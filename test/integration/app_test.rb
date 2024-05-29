# frozen_string_literal: true
require "test_helper"

class AppTest < ActionDispatch::IntegrationTest
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
end