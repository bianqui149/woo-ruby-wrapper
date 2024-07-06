class ProductsController < ApplicationController
    
    ##
    # This function sends a GET request using OAuth authentication and handles the response
    # accordingly to get the list of products.
    def index
      begin
        signed_url = self.oauth('GET')
        uri = URI(signed_url)
  
        response = Net::HTTP.get_response(uri)
  
        if response.is_a?(Net::HTTPSuccess)
          render json: response.body
        else
          render json: { error: "Error in request: #{response.message}" }, status: response.code
        end
      rescue StandardError => e
        render json: { error: "Error in servel: #{e.message}" }, status: :internal_server_error
      end
    end
      
    ##
    # The `show` function retrieves a product's information using OAuth authentication and handles
    # potential errors.
    def show
      begin
        product_id = params['id']
        signed_url = self.oauth('GET', {}, product_id)
        uri = URI(signed_url)
  
        response = Net::HTTP.get_response(uri)
  
        if response.is_a?(Net::HTTPSuccess)
          render json: response.body
        else
          render json: { error: "Error in request: #{response.message}" }, status: response.code
        end
      rescue StandardError => e
        render json: { error: "Error in servel: #{e.message}" }, status: :internal_server_error
      end
    end

   
    ##
    # The `create` function sends a POST request to create a product with specified parameters
    # and handles potential errors.
    def create
      begin
        product_params = {
          name: params[:name],
          price: params[:price],
          description: params[:description],
          stock: params[:stock]
        }
  
        signed_url = oauth('POST', product_params)
        uri = URI(signed_url)

        response = Net::HTTP.post(uri, product_params.to_json, 'Content-Type' => 'application/json')
        if response.is_a?(Net::HTTPSuccess)
          render json: { message: "Product created successfully" }, status: :created
        else
          render json: { error: "Error in request: #{response.message}" }, status: response.code
        end
      rescue StandardError => e
        render json: { error: "Error in server: #{e.message}" }, status: :internal_server_error
      end
    end


    private

    ##
    # The function `oauth` generates a signed URL using OAuth authentication for WooCommerce API
    # requests in Ruby.
    # 
    # Args:
    #   method: The `oauth` method you provided takes a parameter called `method`, which is used to
    # determine the HTTP method for the OAuth request. This method is then used along with other
    # environment variables like `WOOCOMMERCE_CONSUMER_SECRET`, `WOOCOMMERCE_SITE`, and `WOOC
    # 
    # Returns:
    #   The `oauth` method returns a signed URL generated using the OAuthHelper class, the HTTP
    # method, site URL, consumer key, and consumer secret obtained from environment variables.
    def oauth(method, params = {}, product_id = '')
      
      base_url = ENV['WOOCOMMERCE_SITE']

      if product_id.present?
        base_url += "#{product_id}"
      end
      
      http_method = method
      consumer_secret = ENV['WOOCOMMERCE_CONSUMER_SECRET']
      signed_url = OauthHelper.generate_signed_url(
        http_method,
        base_url,
        params,
        ENV['WOOCOMMERCE_CONSUMER_KEY'],
        consumer_secret
      )
      return signed_url
    end
end
  
