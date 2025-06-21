# frozen_string_literal: true

module CF
  module Resources
    class Base
      class << self
        def client
          CF.client
        end

        def list(params = {})
          path = build_path("list", nil, params)
          query_params = params.reject { |k, _v| parent_id_param?(k) }
          client.get(path, query_params)
        end

        def get(id, params = {})
          path = build_path("get", id, params)
          query_params = params.reject { |k, _v| parent_id_param?(k) }
          client.get(path, query_params)
        end

        def create(attributes = {}, params = {})
          # Extract parent IDs from attributes based on path convention
          extracted_params = extract_parent_ids_from_attributes(attributes)
          attributes = extracted_params[:attributes]
          params = params.merge(extracted_params[:params])
          
          path = build_path("create", nil, params)
          query_params = params.reject { |k, _v| parent_id_param?(k) }
          wrapped_attributes = wrap_attributes_for_request(attributes)
          client.post(path, wrapped_attributes, query_params)
        end

        def update(id, attributes = {}, params = {})
          # Extract parent IDs from attributes based on path convention
          extracted_params = extract_parent_ids_from_attributes(attributes)
          attributes = extracted_params[:attributes]
          params = params.merge(extracted_params[:params])
          
          path = build_path("update", id, params)
          query_params = params.reject { |k, _v| parent_id_param?(k) }
          wrapped_attributes = wrap_attributes_for_request(attributes)
          client.patch(path, wrapped_attributes, query_params)
        end

        def delete(id, params = {})
          path = build_path("delete", id, params)
          query_params = params.reject { |k, _v| parent_id_param?(k) }
          client.delete(path, query_params)
        end

        private

        def build_path(action, id = nil, params = {})
          segments = resource_path_segments(params)
          
          case action
          when "list"
            "/#{segments.join("/")}"
          when "create"
            build_create_path(segments, params)
          when "get", "update", "delete"
            "/#{segments.join("/")}/#{id}"
          else
            raise ArgumentError, "Unknown action: #{action}"
          end
        end

        def resource_path_segments(params = {})
          # Convert class name to path segments
          # CF::Orders::Invoice -> ["orders", "invoices"]  
          # CF::Workspaces::Contact -> ["workspaces", "123", "contacts"] (with workspace_id: 123)
          # CF::Contacts::AppliedTag -> ["contacts", "123", "applied_tags"] (with contact_id: 123)
          # CF::Contacts::Tag -> ["workspaces", "123", "contacts", "tags"] (special case)
          
          parts = name.split("::")
          parts.shift # Remove "CF"
          
          # Check for special workspace-nested patterns
          special_pattern = special_workspace_pattern(parts)
          if special_pattern
            return build_special_workspace_path(special_pattern, params)
          end
          
          # Special case for Orders::Invoice - can be workspace OR order nested
          if parts == ["Orders", "Invoice"] && !params.key?(:order_id)
            return build_special_workspace_path({ path_suffix: "orders/invoices" }, params)
          end
          
          segments = []
          parts.each_with_index do |part, index|
            segment = part.gsub(/([A-Z])/, "_\\1").downcase.gsub(/^_/, "")
            
            # For the final resource (last part), make it plural for the URL
            if index == parts.length - 1
              # Last segment - this is the resource, make it plural
              segments << pluralize(segment)
            else
              # Namespace - use as-is (should already be plural in new convention)
              segments << segment
              
              # Check if this specific namespace needs a parent ID
              parent_id_key = "#{segment.chomp("s")}_id".to_sym
              
              # Always check if the parent ID is provided in params
              if params.key?(parent_id_key)
                # If parent ID is explicitly provided, use it (enables nested access)
                segments << params[parent_id_key].to_s
              elsif needs_parent_id_for_namespace?(segment, parts)
                # If this namespace requires a parent ID by default, get it from config
                parent_id = get_default_parent_id(parent_id_key)
                
                if parent_id
                  segments << parent_id.to_s
                else
                  raise CF::ConfigurationError, "#{parent_id_key} is required. Provide it as a parameter or set it in configuration."
                end
              end
            end
          end
          
          segments
        end

        def needs_parent_id_for_namespace?(segment, parts)
          # Determine which namespaces actually need parent IDs based on API structure
          # This is more specific than just "all multi-part resources"
          
          case segment.downcase
          when "workspaces"
            # CF::Workspaces::Contact -> needs workspace_id
            true
          when "teams"
            # CF::Teams::Workspace -> needs team_id  
            true
          when "contacts"
            # CF::Contacts::AppliedTag -> needs contact_id
            true
          when "courses"
            # CF::Courses::Section, CF::Courses::Enrollment -> needs course_id
            true
          when "orders"
            # CF::Orders::Invoice might be top-level collection OR nested
            # We'll check if order_id is provided in params to decide
            false  # Default to top-level for now
          when "products"
            # CF::Products::Price -> needs product_id if it's nested
            false  # Default to top-level for now  
          when "forms"
            # CF::Forms::FieldSet -> might need form_id
            false  # Default to top-level for now
          else
            # For other cases, check if it's a known nested pattern
            false
          end
        end

        def get_default_parent_id(parent_id_key)
          case parent_id_key
          when :workspace_id
            CF.configuration.workspace_id
          when :team_id
            CF.configuration.team_id
          when :contact_id, :course_id, :order_id, :product_id, :form_id
            # These don't have defaults - must be provided
            nil
          else
            nil
          end
        end

        def parent_id_param?(key)
          # Any parameter ending with "_id" is considered a parent ID parameter
          key.to_s.end_with?("_id")
        end

        def extract_parent_ids_from_attributes(attributes)
          # Extract parent IDs that match the path convention from attributes
          # For CF::Contacts::AppliedTag, look for contact_id in attributes
          # For CF::Products::Price, look for product_id in attributes
          
          expected_parent_ids = get_expected_parent_ids_for_class
          params = {}
          remaining_attributes = {}
          
          attributes.each do |key, value|
            if expected_parent_ids.include?(key.to_sym)
              params[key] = value
            else
              remaining_attributes[key] = value
            end
          end
          
          { attributes: remaining_attributes, params: params }
        end

        def get_expected_parent_ids_for_class
          # Based on the class name, determine what parent IDs are expected
          # CF::Contacts::AppliedTag -> [:contact_id]
          # CF::Products::Price -> [:product_id]
          # CF::Workspaces::Contact -> [:workspace_id]
          
          parts = name.split("::")[1..-1] # Remove "CF"
          return [] if parts.length <= 1
          
          parent_ids = []
          
          # Check each namespace part for expected parent IDs
          parts[0..-2].each do |part|
            segment = part.gsub(/([A-Z])/, "_\\1").downcase.gsub(/^_/, "")
            parent_id_key = "#{segment.chomp('s')}_id".to_sym
            parent_ids << parent_id_key
          end
          
          parent_ids
        end

        def build_create_path(segments, params)
          # For create operations, check if we need parent ID in the path
          # This handles cases like CF::Products::Price.create(product_id: 123)
          # which should POST to /products/123/prices instead of /products/prices
          
          return "/#{segments.join("/")}" if segments.length <= 1
          
          # Check if we have a parent resource that needs ID in the path
          parent_resource = segments[-2] # Second to last segment
          resource = segments[-1] # Last segment
          
          # Build parent ID parameter name from parent resource
          parent_id_key = "#{parent_resource.chomp('s')}_id".to_sym
          
          if params.key?(parent_id_key)
            # Replace the parent collection with parent/id pattern
            path_segments = segments.dup
            path_segments[-2] = "#{parent_resource}/#{params[parent_id_key]}"
            path_segments.pop # Remove the resource name
            path_segments << resource # Add it back
            "/#{path_segments.join("/")}"
          else
            # No parent ID provided, use collection path
            "/#{segments.join("/")}"
          end
        end

        def wrap_attributes_for_request(attributes)
          # Wrap attributes with the proper resource key for API requests
          # Example: CF::Contacts::Tag -> { contacts_tag: attributes }
          resource_key = generate_resource_key
          { resource_key => attributes }
        end

        def generate_resource_key
          # Generate the resource key from class name
          # CF::Contact -> :contact
          # CF::Contacts::Tag -> :contacts_tag
          # CF::Courses::LessonCompletion -> :courses_lesson_completion
          
          parts = name.split("::")[1..-1] # Remove "CF"
          
          # Convert each part to snake_case
          # For namespaces (all but last), keep plural
          # For resource (last), make singular
          key_parts = parts.map.with_index do |part, index|
            snake_case = part.gsub(/([A-Z])/, "_\\1").downcase.gsub(/^_/, "")
            
            if index == parts.length - 1
              # Last part is the resource - make it singular
              singularize(snake_case)
            else
              # Namespace parts - keep as-is (should already be plural)
              snake_case
            end
          end
          
          key_parts.join("_").to_sym
        end

        def singularize(word)
          # Simple singularization rules
          return word unless word.end_with?('s')
          
          case word
          when /ies$/
            word.sub(/ies$/, "y")
          when /ses$/, /ches$/, /xes$/, /zes$/
            word.sub(/es$/, "")
          when /s$/
            word.sub(/s$/, "")
          else
            word
          end
        end

        def special_workspace_pattern(parts)
          # Map special cases where resources are under /workspaces but have different namespace
          # Returns the pattern info if it matches, nil otherwise
          return nil if parts.length != 2
          
          namespace = parts[0].downcase
          resource = parts[1].downcase
          
          # These patterns require workspace_id despite their namespace
          workspace_nested_patterns = {
            ["contacts", "tag"] => "contacts/tags",
            ["orders", "tag"] => "orders/tags", 
            ["funnels", "tag"] => "funnels/tags",
            ["products", "tag"] => "products/tags",
            ["products", "collection"] => "products/collections"
          }
          
          # Special handling for Orders::Invoice - it can be both workspace and order nested
          # We'll treat it as workspace-nested ONLY when no order_id is provided
          if namespace == "orders" && resource == "invoice"
            return nil  # Let normal logic handle it
          end
          
          pattern_key = [namespace, resource]
          if workspace_nested_patterns.key?(pattern_key)
            { path_suffix: workspace_nested_patterns[pattern_key] }
          else
            nil
          end
        end
        
        def build_special_workspace_path(pattern_info, params)
          # Build path for special workspace-nested resources
          segments = ["workspaces"]
          
          # Get workspace_id from params or config
          workspace_id = params[:workspace_id] || get_default_parent_id(:workspace_id)
          
          if workspace_id
            segments << workspace_id.to_s
          else
            raise CF::ConfigurationError, "workspace_id is required. Provide it as a parameter or set it in configuration."
          end
          
          # Add the specific path suffix (e.g., "contacts/tags")
          segments << pattern_info[:path_suffix]
          
          segments
        end

        def pluralize(word)
          # Simple pluralization rules
          # Don't pluralize words that are already plural
          return word if word.end_with?('s') && !word.end_with?('ss')
          
          case word
          when /y$/
            word.sub(/y$/, "ies")
          when /sh$/, /ch$/, /x$/, /z$/
            "#{word}es"
          else
            "#{word}s"
          end
        end
      end
    end

    # Dynamic class generation for all endpoints
    # TODO: This can be more "dynamic" by using the naming conventions.
    def self.generate_resource_classes!
      # Define all the resource classes based on ENDPOINTS.md
      # Following convention: CF::NamespaceS(plural)::Resource(singular)
      
      # Top-level resources
      define_resource_class("CF::Teams")      # Collection
      define_resource_class("CF::Team")       # Individual resource
      define_resource_class("CF::Users")      # Collection
      define_resource_class("CF::User")       # Individual resource
      
      # Workspace nested resources
      define_resource_class("CF::Teams::Workspace")    # Nested under teams
      define_resource_class("CF::Workspaces")          # Collection
      define_resource_class("CF::Workspace")           # Individual resource
      define_resource_class("CF::Workspaces::Contact") # Nested under workspaces
      define_resource_class("CF::Contact")             # Individual resource
      # FIXME: Instead of this, these need to be actions.
      define_resource_class("CF::Contacts::GdprDestroy")
      define_resource_class("CF::Workspaces::Contacts::Upsert")

      # Contact Tags
      define_resource_class("CF::Contacts::AppliedTag")
      define_resource_class("CF::Contacts::Tag")  # This maps to /workspaces/{id}/contacts/tags
      
      # Courses
      define_resource_class("CF::Workspaces::Course")
      define_resource_class("CF::Courses")
      define_resource_class("CF::Course")
      define_resource_class("CF::Courses::Enrollment")
      define_resource_class("CF::Courses::Section")
      define_resource_class("CF::Courses::Sections::Lesson")
      define_resource_class("CF::Courses::Lesson")
      define_resource_class("CF::Courses::LessonCompletion")
      
      # Forms
      define_resource_class("CF::Workspaces::Form")
      define_resource_class("CF::Forms")
      define_resource_class("CF::Form")
      define_resource_class("CF::Forms::FieldSet")
      define_resource_class("CF::Forms::FieldSets::Field")
      define_resource_class("CF::Forms::Field")
      define_resource_class("CF::Forms::FieldSets::Fields::Reorder")
      define_resource_class("CF::Forms::Fields::Option")
      define_resource_class("CF::Forms::Submission")
      define_resource_class("CF::Workspaces::FormSubmission")
      define_resource_class("CF::Forms::Submissions::Answer")
      
      # Orders
      define_resource_class("CF::Workspaces::Order")
      define_resource_class("CF::Orders")
      define_resource_class("CF::Order")
      define_resource_class("CF::Orders::AppliedTag")
      define_resource_class("CF::Workspaces::Orders::Tag")
      define_resource_class("CF::Orders::Tag")
      define_resource_class("CF::Orders::Invoice")
      define_resource_class("CF::Workspaces::Orders::Invoice")
      define_resource_class("CF::Orders::Transaction")
      define_resource_class("CF::Workspaces::Orders::Invoices::Restock")
      define_resource_class("CF::Orders::Invoices::Restock")
      
      # Products  
      define_resource_class("CF::Workspaces::Product")
      define_resource_class("CF::Products")
      define_resource_class("CF::Product")
      define_resource_class("CF::Products::Archive")
      define_resource_class("CF::Products::Unarchive")
      define_resource_class("CF::Workspaces::Products::Collection")
      define_resource_class("CF::Products::Collection")
      define_resource_class("CF::Products::Price")
      define_resource_class("CF::Products::Variant")
      define_resource_class("CF::Workspaces::Products::Tag")
      define_resource_class("CF::Products::Tag")
      
      # Fulfillments
      define_resource_class("CF::Workspaces::Fulfillment")
      define_resource_class("CF::Fulfillments")
      define_resource_class("CF::Fulfillment")
      define_resource_class("CF::Fulfillments::Cancel")
      define_resource_class("CF::Workspaces::Fulfillments::Location")
      define_resource_class("CF::Fulfillments::Location")
      
      # Funnels
      define_resource_class("CF::Workspaces::Funnel")
      define_resource_class("CF::Funnels")
      define_resource_class("CF::Funnel")
      define_resource_class("CF::Workspaces::Funnels::Tag")
      define_resource_class("CF::Funnels::Tag")
      
      # Pages
      define_resource_class("CF::Workspaces::Page")
      define_resource_class("CF::Pages")
      define_resource_class("CF::Page")
      
      # Images
      define_resource_class("CF::Workspaces::Image")
      define_resource_class("CF::Images")
      define_resource_class("CF::Image")
      
      # Sales
      define_resource_class("CF::Workspaces::Sales::Pipeline")
      define_resource_class("CF::Sales::Pipelines")
      define_resource_class("CF::Sales::Pipeline")
      define_resource_class("CF::Sales::Pipelines::Stage")
      define_resource_class("CF::Workspaces::Sales::Opportunity")
      define_resource_class("CF::Sales::Opportunities")
      define_resource_class("CF::Sales::Opportunity")
      define_resource_class("CF::Sales::Opportunities::Note")
      
      # Shipping
      define_resource_class("CF::Workspaces::Shipping::Profile")
      define_resource_class("CF::Shipping::Profiles")
      define_resource_class("CF::Shipping::Profile")
      define_resource_class("CF::Shipping::Profiles::LocationGroup")
      define_resource_class("CF::Shipping::LocationGroups::Zone")
      define_resource_class("CF::Shipping::Zones::Rate")
      define_resource_class("CF::Workspaces::Shipping::Rates::Name")
      define_resource_class("CF::Shipping::Rates::Name")
      define_resource_class("CF::Workspaces::Shipping::Package")
      define_resource_class("CF::Shipping::Packages")
      define_resource_class("CF::Shipping::Package")
      
      # Stores
      define_resource_class("CF::Workspaces::Store")
      define_resource_class("CF::Stores")
      define_resource_class("CF::Store")
      
      # Themes & Styles
      define_resource_class("CF::Workspaces::Theme")
      define_resource_class("CF::Themes")
      define_resource_class("CF::Theme")
      define_resource_class("CF::Workspaces::Style")
      define_resource_class("CF::Styles")
      
      # Webhooks
      define_resource_class("CF::Workspaces::Webhooks::Outgoing::Endpoint")
      define_resource_class("CF::Webhooks::Outgoing::Endpoints")
      define_resource_class("CF::Webhooks::Outgoing::Endpoint")
      define_resource_class("CF::Workspaces::Webhooks::Outgoing::Event")
      define_resource_class("CF::Webhooks::Outgoing::Events")
      define_resource_class("CF::Webhooks::Outgoing::Event")
    end

    private

    def self.define_resource_class(class_name)
      # Create nested modules if they don't exist
      parts = class_name.split("::")
      current_module = Object
      
      parts[0..-2].each do |part|
        unless current_module.const_defined?(part)
          current_module.const_set(part, Module.new)
        end
        current_module = current_module.const_get(part)
      end
      
      # Create the final class
      class_name_part = parts.last
      unless current_module.const_defined?(class_name_part)
        current_module.const_set(class_name_part, Class.new(Base))
      end
    end
  end
end

# Generate all resource classes when this file is loaded
CF::Resources.generate_resource_classes!