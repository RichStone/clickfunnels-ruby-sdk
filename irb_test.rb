#!/usr/bin/env ruby
# 🚀 ClickFunnels SDK - Interactive IRB Test Environment
# Run with: bundle exec irb -r ./irb_test.rb
require_relative 'lib/cf'

puts "🚀 ClickFunnels SDK - Interactive Test Environment"
puts "=================================================="
puts "✨ All improvements loaded and ready to test!"

# Configure with test values
CF.configure do |config|
  config.subdomain = ENV["CLICK_FUNNELS_WORKSPACE"]
  config.api_token = ENV["CLICK_FUNNELS_API_KEY_RUBY_SDK"]
  config.workspace_id = ENV["CLICK_FUNNELS_WORKSPACE_ID"]
  config.team_id = ENV["CLICK_FUNNELS_API_KEY_RUBY_SDK"]
  config.debug = false
end

puts "\n✅ Configuration:"
puts "  Subdomain: #{CF.configuration.subdomain}"
puts "  Base URL: #{CF.configuration.base_url}"
puts "  Workspace ID: #{CF.configuration.workspace_id}"
puts "  Team ID: #{CF.configuration.team_id}"
puts "  Valid: #{CF.configuration.valid?}"

puts "\n✅ Available resources (new naming convention):"
resources = [
  "CF::Teams",                  # Collection
  "CF::Users",                  # Collection
  "CF::Workspaces::Contact",    # 🆕 Workspace-nested resource
  "CF::Orders::Invoice",        # Updated naming
  "CF::Products::Price",        # Updated naming
  "CF::Courses::Enrollment"     # Updated naming
]

resources.each do |resource|
  begin
    klass = Object.const_get(resource)
    puts "  #{resource} ✓"
  rescue NameError
    puts "  #{resource} ✗ (not found)"
  end
end

puts "\n✅ Path generation examples:"
begin
  puts "  CF::Orders::Invoice.list -> #{CF::Orders::Invoice.send(:build_path, 'list', nil, {})}"
  puts "  CF::Orders::Invoice.get(123) -> #{CF::Orders::Invoice.send(:build_path, 'get', 123, {})}"
  puts "  CF::Workspaces::Contact.list -> #{CF::Workspaces::Contact.send(:build_path, 'list', nil, {})}"
  puts "  CF::Workspaces::Contact.list(workspace_id: 'custom') -> #{CF::Workspaces::Contact.send(:build_path, 'list', nil, {workspace_id: 'custom'})}"
  puts "  CF::Teams::Workspace.list -> #{CF::Teams::Workspace.send(:build_path, 'list', nil, {})}"
rescue => e
  puts "  Error generating paths: #{e.message}"
end

puts "\n🎯 Ready for interactive testing!"
puts "\n📋 Try these commands:"
puts "  # Basic resources (no parent ID needed)"
puts "  CF::Orders::Invoice.list"
puts "  CF::Users.list"
puts "  CF::Teams.list"
puts ""
puts "  # Workspace-nested resources (uses default workspace_id)"
puts "  CF::Workspaces::Contact.list"
puts "  CF::Workspaces::Product.list"
puts ""
puts "  # Override workspace for specific calls"
puts "  CF::Workspaces::Contact.list(workspace_id: 'different_ws')"
puts ""
puts "  # Error handling examples (returns objects, not exceptions)"
puts "  result = CF::Orders::Invoice.get(999999)"
puts "  puts result[:error] ? \"Error: \#{result[:message]}\" : \"Success!\""
puts ""
puts "  # Pagination and filtering"
puts "  CF::Orders::Invoice.list(after: {id: 100}, filter: {status: 'paid'})"

puts "\n🆕 New Features Available:"
puts "  ✓ Error objects instead of exceptions"
puts "  ✓ Parent ID support (workspace_id, team_id)"
puts "  ✓ Default parent IDs in configuration"
puts "  ✓ Proper naming convention (CF::Workspaces::Contact)"

puts "\n💡 Pro tip: Enable debug mode to see all HTTP requests:"
puts "  CF.configuration.debug = true"

puts "\n🚧 Note: API calls will return error objects with fake credentials"
puts "   Update config with real token and workspace_id for live testing"