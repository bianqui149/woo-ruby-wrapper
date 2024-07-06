# Products API Wrapper

This project is a product management API built with Ruby on Rails. The API acts as a wrapper to interact with an external WooCommerce API, allowing for CRUD operations on products (index, show, create).

## Requirements

- Ruby 3.0.0 or higher
- Rails 7.0.0 or higher

## Installation

1. Clone the repository:

    ```sh
    git clone https://github.com/your_username/products-api.git
    cd products-api
    ```

2. Install dependencies:

    ```sh
    bundle install
    ```

3. Configure environment variables:

    Create a `.env` file in the root of the project and add the following environment variables:

    ```
    WOOCOMMERCE_SITE=http://0.0.0.0:8000/wp-json/wc/v3
    WOOCOMMERCE_CONSUMER_KEY=your_consumer_key
    WOOCOMMERCE_CONSUMER_SECRET=your_consumer_secret
    ```

4. Start the Rails server:

    ```sh
    rails server
    ```

## API Endpoints

### List All Products

- **URL**: `/products`
- **Method**: `GET`

- **Example Request**:

    ```sh
    curl -X GET http://0.0.0.0:3000/products
    ```

### Get a Specific Product

- **URL**: `/products/:id`
- **Method**: `GET`

- **Example Request**:

    ```sh
    curl -X GET http://0.0.0.0:3000/products/1
    ```

### Create a Product

- **URL**: `/products`
- **Method**: `POST`
- **Headers**: `Content-Type: application/json`
- **Body**:

    ```json
    {
        "product": {
            "name": "New Product",
            "price": 19.99,
            "description": "Product description",
            "stock": 100
        }
    }
    ```

- **Example Request**:

    ```sh
    curl -X POST http://0.0.0.0:3000/products \
        -H "Content-Type: application/json" \
        -d '{
            "product": {
                "name": "New Product",
                "price": 19.99,
                "description": "Product description",
                "stock": 100
            }
        }'
    ```

## Error Handling

- The API returns appropriate HTTP status codes and error messages for invalid requests.
- Common error responses include:
    - `400 Bad Request`
    - `404 Not Found`
    - `500 Internal Server Error`

## Logging

- Rails logs can be found in the `log` directory.
- To log variables or other information, you can use the `logger` method in your controllers, for example:

    ```ruby
    logger.debug "This is a debug message"
    logger.info "This is an info message"
    logger.error "This is an error message"
    ```

## OAuth Helper

The `OauthHelper` module is used to generate OAuth signatures for API requests. This is necessary for authenticating requests to the WooCommerce API.

## Contribution

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/fooBar`)
3. Commit your changes (`git commit -am 'Add some fooBar'`)
4. Push to the branch (`git push origin feature/fooBar`)
5. Create a new Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
