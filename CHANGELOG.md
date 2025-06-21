# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2025-06-21

### Added
- Initial implementation of ClickFunnels Ruby SDK
- Complete Ruby SDK implementation based on OpenAPI spec
- HTTP client with configurable adapters (Net::HTTP default)
- Resource-based API with method mapping for all ClickFunnels endpoints
- Comprehensive test suite with WebMock integration
- Debug logging with configurable file logger
- Error handling with structured error responses
- Bearer token authentication
- Support for workspace-scoped and team-scoped resources
- Dynamic resource path building with parent ID support
- MIT License

### Features
- 138+ auto-generated resource classes covering all ClickFunnels API endpoints
- Configurable subdomain, API token, workspace ID, and team ID
- Graceful error handling returning structured error objects instead of exceptions
- Query parameter support for filtering, pagination, and search
- Full CRUD operations (GET, POST, PUT, PATCH, DELETE) for all resources
- Comprehensive documentation and interactive testing environment

[0.1.0]: https://github.com/RichStone/clickfunnels-ruby-sdk/releases/tag/v0.1.0
