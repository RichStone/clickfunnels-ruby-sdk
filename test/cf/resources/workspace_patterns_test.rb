# frozen_string_literal: true

require "test_helper"

class CF::Resources::WorkspacePatternsTest < Minitest::Test
  def setup
    configure_cf
    CF.configuration.workspace_id = "ws_default"
  end

  def test_contacts_tag_uses_workspace_pattern
    stub_request(:get, "https://test.myclickfunnels.com/api/v2/workspaces/ws_default/contacts/tags")
      .to_return(status: 200, body: JSON.generate({ tags: [] }))
    
    result = CF::Contacts::Tag.list
    assert_equal({ tags: [] }, result)
  end

  def test_orders_tag_uses_workspace_pattern
    stub_request(:get, "https://test.myclickfunnels.com/api/v2/workspaces/ws_default/orders/tags")
      .to_return(status: 200, body: JSON.generate({ tags: [] }))
    
    result = CF::Orders::Tag.list
    assert_equal({ tags: [] }, result)
  end

  def test_funnels_tag_uses_workspace_pattern
    stub_request(:get, "https://test.myclickfunnels.com/api/v2/workspaces/ws_default/funnels/tags")
      .to_return(status: 200, body: JSON.generate({ tags: [] }))
    
    result = CF::Funnels::Tag.list
    assert_equal({ tags: [] }, result)
  end

  def test_products_tag_uses_workspace_pattern
    stub_request(:get, "https://test.myclickfunnels.com/api/v2/workspaces/ws_default/products/tags")
      .to_return(status: 200, body: JSON.generate({ tags: [] }))
    
    result = CF::Products::Tag.list
    assert_equal({ tags: [] }, result)
  end

  def test_products_collection_uses_workspace_pattern
    stub_request(:get, "https://test.myclickfunnels.com/api/v2/workspaces/ws_default/products/collections")
      .to_return(status: 200, body: JSON.generate({ collections: [] }))
    
    result = CF::Products::Collection.list
    assert_equal({ collections: [] }, result)
  end

  def test_workspace_pattern_with_override_id
    stub_request(:get, "https://test.myclickfunnels.com/api/v2/workspaces/ws_custom/contacts/tags")
      .to_return(status: 200, body: JSON.generate({ tags: [] }))
    
    result = CF::Contacts::Tag.list(workspace_id: "ws_custom")
    assert_equal({ tags: [] }, result)
  end

  def test_workspace_pattern_without_config_raises_error
    CF.configuration.workspace_id = nil
    
    assert_raises CF::ConfigurationError do
      CF::Contacts::Tag.list
    end
  end

  def test_orders_invoice_as_workspace_nested
    stub_request(:get, "https://test.myclickfunnels.com/api/v2/workspaces/ws_default/orders/invoices")
      .to_return(status: 200, body: JSON.generate({ invoices: [] }))
    
    result = CF::Orders::Invoice.list
    assert_equal({ invoices: [] }, result)
  end

  def test_orders_invoice_as_order_nested
    stub_request(:get, "https://test.myclickfunnels.com/api/v2/orders/order_123/invoices")
      .to_return(status: 200, body: JSON.generate({ invoices: [] }))
    
    result = CF::Orders::Invoice.list(order_id: "order_123")
    assert_equal({ invoices: [] }, result)
  end

  def test_regular_nested_pattern_still_works
    stub_request(:get, "https://test.myclickfunnels.com/api/v2/contacts/contact_123/applied_tags")
      .to_return(status: 200, body: JSON.generate({ applied_tags: [] }))
    
    result = CF::Contacts::AppliedTag.list(contact_id: "contact_123")
    assert_equal({ applied_tags: [] }, result)
  end

  def test_workspace_pattern_get_operation
    stub_request(:get, "https://test.myclickfunnels.com/api/v2/workspaces/ws_default/contacts/tags/tag_123")
      .to_return(status: 200, body: JSON.generate({ tag: { id: "tag_123", name: "VIP" } }))
    
    result = CF::Contacts::Tag.get("tag_123")
    assert_equal({ tag: { id: "tag_123", name: "VIP" } }, result)
  end

  def test_workspace_pattern_create_operation
    stub_request(:post, "https://test.myclickfunnels.com/api/v2/workspaces/ws_default/contacts/tags")
      .with(body: JSON.generate({ name: "New Tag" }))
      .to_return(status: 201, body: JSON.generate({ tag: { id: "tag_456", name: "New Tag" } }))
    
    result = CF::Contacts::Tag.create(name: "New Tag")
    assert_equal({ tag: { id: "tag_456", name: "New Tag" } }, result)
  end

  def test_workspace_pattern_update_operation
    stub_request(:patch, "https://test.myclickfunnels.com/api/v2/workspaces/ws_default/contacts/tags/tag_123")
      .with(body: JSON.generate({ name: "Updated Tag" }))
      .to_return(status: 200, body: JSON.generate({ tag: { id: "tag_123", name: "Updated Tag" } }))
    
    result = CF::Contacts::Tag.update("tag_123", name: "Updated Tag")
    assert_equal({ tag: { id: "tag_123", name: "Updated Tag" } }, result)
  end

  def test_workspace_pattern_delete_operation
    stub_request(:delete, "https://test.myclickfunnels.com/api/v2/workspaces/ws_default/contacts/tags/tag_123")
      .to_return(status: 204, body: "")
    
    result = CF::Contacts::Tag.delete("tag_123")
    assert_nil result
  end

  def test_workspace_pattern_with_query_params
    stub_request(:get, "https://test.myclickfunnels.com/api/v2/workspaces/ws_default/contacts/tags?filter[name]=VIP")
      .to_return(status: 200, body: JSON.generate({ tags: [] }))
    
    result = CF::Contacts::Tag.list(filter: { name: "VIP" })
    assert_equal({ tags: [] }, result)
  end
end