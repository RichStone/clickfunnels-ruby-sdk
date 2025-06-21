# frozen_string_literal: true

require "test_helper"

class CF::Resources::BaseTest < Minitest::Test
  def setup
    configure_cf
  end

  def test_list_operation
    stub_request_with_response(:get, "/users", { users: [] })
    
    result = CF::Users.list
    assert_equal({ users: [] }, result)
  end

  def test_get_operation
    stub_request_with_response(:get, "/users/123", { user: { id: 123 } })
    
    result = CF::User.get(123)
    assert_equal({ user: { id: 123 } }, result)
  end

  def test_create_operation
    stub_request_with_response(:post, "/products", { product: { id: 123, name: "Test" } })
    
    result = CF::Product.create(name: "Test")
    assert_equal({ product: { id: 123, name: "Test" } }, result)
  end

  def test_update_operation
    stub_request_with_response(:patch, "/products/123", { product: { id: 123, name: "Updated" } })
    
    result = CF::Product.update(123, name: "Updated")
    assert_equal({ product: { id: 123, name: "Updated" } }, result)
  end

  def test_delete_operation
    stub_request_with_response(:delete, "/products/123", {})
    
    result = CF::Product.delete(123)
    assert_equal({}, result)
  end

  def test_error_response_object
    stub_request_with_response(:get, "/users/999", { error: "Not found" }, 404)
    
    result = CF::User.get(999)
    assert result[:error]
    assert_equal "CF::NotFoundError", result[:error_type]
    assert_equal "Not Found", result[:message]
    assert_equal 404, result[:status]
  end

  def test_workspace_resource_with_id
    configure_cf
    CF.configuration.workspace_id = "default_workspace_123"
    
    stub_request(:get, "https://test.myclickfunnels.com/api/v2/workspaces/default_workspace_123/contacts")
      .to_return(status: 200, body: JSON.generate({ contacts: [] }))
    
    result = CF::Workspaces::Contact.list
    assert_equal({ contacts: [] }, result)
  end

  def test_workspace_resource_with_override_id
    configure_cf
    CF.configuration.workspace_id = "default_workspace_123"
    
    stub_request(:get, "https://test.myclickfunnels.com/api/v2/workspaces/override_456/contacts")
      .to_return(status: 200, body: JSON.generate({ contacts: [] }))
    
    result = CF::Workspaces::Contact.list(workspace_id: "override_456")
    assert_equal({ contacts: [] }, result)
  end

  def test_list_with_pagination
    stub_request(:get, "https://test.myclickfunnels.com/api/v2/users?after[id]=123")
      .to_return(status: 200, body: JSON.generate({ users: [] }))
    
    CF::Users.list(after: { id: 123 })
  end

  def test_list_with_filters
    stub_request(:get, "https://test.myclickfunnels.com/api/v2/users?filter[status]=active")
      .to_return(status: 200, body: JSON.generate({ users: [] }))
    
    CF::Users.list(filter: { status: "active" })
  end
end