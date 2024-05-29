class ApplicationController < ActionController::API
    def index
        render json: { hola: "mundo "}
    end
end
