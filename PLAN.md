# Simplified Dynamic Ruby SDK Plan for ClickFunnels API

## Core Components

### 1. HTTP Client Wrapper
- Abstract HTTP layer with Net::HTTP as default
- Support for swapping HTTP backends
- Handle SSL, timeouts, headers

### 2. Dynamic Resource System
- Base resource class with metaprogramming
- Automatic namespace generation (CF::Orders::Invoice)
- Standard CRUD operations (list, get, create, update, delete) so that all endpoints from ENDPOINTS.md are covered.

### 3. Authentication
- Simple Bearer token authentication
- Token passed via configuration

### 4. Request/Response Pipeline
- Request builder with proper headers
- Response parser with error handling
- Custom exception classes

### 5. OpenAPI Integration
- Extract endpoint paths and operations only
- No complex schema validation

### 6. Query Building
- Filters and pagination parameters
- Proper parameter serialization

### 7. Response Handling
- JSON parsing
- Simple object/hash responses

### 8. Configuration
- API subdomain, version, token
- Debug mode for request logging

### 9. Debug Logging
- When debug=true, log all requests to file
- Include request/response details

### 10. Testing
- Minitest framework
- Basic unit and integration tests

## Gem Structure

```
clickfunnels-ruby-sdk/
├── lib/
│   ├── cf/
│   │   ├── client.rb
│   │   ├── configuration.rb
│   │   ├── version.rb
│   │   ├── http/
│   │   │   ├── client.rb
│   │   │   └── net_http_adapter.rb
│   │   ├── resources/
│   │   │   └── base.rb
│   │   ├── auth.rb
│   │   └── errors.rb
│   └── cf.rb
├── test/
│   ├── test_helper.rb
│   └── cf/
│       └── resources/
├── README.md
├── Gemfile
├── clickfunnels-ruby-sdk.gemspec
└── Rakefile
```

## Usage Examples

```ruby
# Configuration
CF.configure do |config|
  config.subdomain = "myaccount"
  config.api_token = "bearer_token"
  config.debug = true
end

# API calls
CF::Orders::Invoice.list(after: {id: 123}, filters: {id: [1,2]})
CF::Orders::Invoice.get(123)
CF::Orders::Invoice.create(amount: 100, currency: "USD")
CF::Orders::Invoice.update(123, status: "paid")
CF::Orders::Invoice.delete(123)
```

## Implementation Tasks

1. **Setup gem structure and dependencies** (High Priority)
   - Create gemspec file
   - Setup Bundler and dependencies
   - Configure gem metadata

2. **Design HTTP client wrapper with swappable backend** (High Priority)
   - Create abstract HTTP client interface
   - Implement Net::HTTP adapter
   - Support request/response abstraction

3. **Create base resource class with dynamic method generation** (High Priority)
   - Metaprogramming for CRUD operations
   - Dynamic namespace creation
   - Method delegation pattern
   - so that all endpoints from ENDPOINTS.md are covered.

4. **Implement Bearer token authentication** (High Priority)
   - Simple header injection
   - Token storage in configuration

5. **Build request/response handling with error management** (High Priority)
   - Request builder with headers and body
   - Response parser
   - Error class hierarchy

6. **Extract endpoint definitions from OpenAPI schema** (Medium Priority)
   - Parse OpenAPI YAML/JSON
   - Extract resource paths and operations
   - Generate resource list

7. **Implement pagination support for list operations** (Medium Priority)
   - Handle 'after' and 'before' cursors
   - Response metadata parsing

8. **Add filtering and query parameter handling** (Medium Priority)
   - Support nested filters
   - Array parameter serialization
   - Query string building

9. **Build response parsing and object mapping** (Medium Priority)
   - JSON to Ruby hash conversion
   - Symbolize keys option
   - Handle empty responses

10. **Create configuration system** (Medium Priority)
    - Global configuration singleton
    - Per-request overrides
    - Debug mode toggle

11. **Implement debug logging to file** (Low Priority)
    - Log requests when debug=true
    - Include timestamps, URLs, payloads
    - Configurable log path

12. **Create test suite with Minitest** (Low Priority)
    - Unit tests for each component
    - Integration tests with mocked HTTP
    - Test helpers and fixtures

13. **Write README with usage examples** (Low Priority)
    - Installation instructions
    - Configuration guide
    - API usage examples
    - Troubleshooting section