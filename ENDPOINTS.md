# ClickFunnels API Endpoints

## Teams
```
CF::Teams#list
pagination: cursor-based (after/before)
sort: sort_property, sort_order
comment: List Teams

CF::Team#get
comment: Fetch Team

CF::Team#update
comment: Update Team
```

## Users
```
CF::Users#list
pagination: cursor-based (after/before)
sort: sort_property, sort_order
comment: List Users

CF::User#get
comment: Fetch User
```

## Workspaces
```
CF::Team::Workspaces#list
pagination: cursor-based (after/before)
sort: sort_property, sort_order
comment: List Workspaces

CF::Workspace#get
comment: Fetch Workspace

CF::Workspace#update
comment: Update Workspace
```

## Contacts
```
CF::Workspace::Contacts#list
filters: available properties
pagination: cursor-based (after/before)
sort: sort_property, sort_order
comment: List Contacts

CF::Workspace::Contacts#create
comment: Create Contact

CF::Contact#get
comment: Fetch Contact

CF::Contact#update
comment: Update Contact

CF::Contact#delete
comment: Remove Contact

CF::Contact::GdprDestroy#delete
comment: Redact Contact

CF::Workspace::Contacts::Upsert#create
comment: Upsert a Contact
```

## Contact Tags
```
CF::Contact::AppliedTags#list
filters: available properties
pagination: cursor-based (after/before)
sort: sort_property, sort_order
comment: List Applied Tags

CF::Contact::AppliedTags#create
comment: Create Applied Tag

CF::Contacts::AppliedTag#get
comment: Fetch Applied Tag

CF::Contacts::AppliedTag#delete
comment: Remove Applied Tag

CF::Workspace::Contacts::Tags#list
filters: available properties
pagination: cursor-based (after/before)
sort: sort_property, sort_order
comment: List Tags

CF::Workspace::Contacts::Tags#create
comment: Create Tag

CF::Contacts::Tag#get
comment: Fetch Tag

CF::Contacts::Tag#update
comment: Update Tag

CF::Contacts::Tag#delete
comment: Remove Tag
```

## Courses
```
CF::Workspace::Courses#list
pagination: cursor-based (after/before)
sort: sort_property, sort_order
comment: List Courses

CF::Course#get
comment: Fetch Course

CF::Course::Enrollments#list
filters: available properties
pagination: cursor-based (after/before)
sort: sort_property, sort_order
comment: List Enrollments

CF::Course::Enrollments#create
comment: Create Enrollment

CF::Courses::Enrollment#get
comment: Fetch Enrollment

CF::Courses::Enrollment#update
comment: Update Enrollment

CF::Course::Sections#list
pagination: cursor-based (after/before)
sort: sort_property, sort_order
comment: List Sections

CF::Courses::Section#get
comment: Fetch Section

CF::Courses::Section#update
comment: Update Section

CF::Courses::Section::Lessons#list
pagination: cursor-based (after/before)
sort: sort_property, sort_order
comment: List Lessons

CF::Courses::Lesson#get
comment: Fetch Lesson

CF::Courses::Lesson#update
comment: Update Lesson

CF::Course::LessonCompletions#list
filters: available properties
pagination: cursor-based (after/before)
sort: sort_property, sort_order
comment: List Lesson Completions

CF::Course::LessonCompletions#create
comment: Create Lesson Completion

CF::Courses::LessonCompletion#get
comment: Fetch Lesson Completion

CF::Courses::LessonCompletion#delete
comment: Remove Lesson Completion
```

## Forms
```
CF::Workspace::Forms#list
pagination: cursor-based (after/before)
sort: sort_property, sort_order
comment: List Forms

CF::Workspace::Forms#create
comment: Create Form

CF::Form#get
comment: Fetch Form

CF::Form#update
comment: Update Form

CF::Form#delete
comment: Remove Form

CF::Form::FieldSets#list
pagination: cursor-based (after/before)
sort: sort_property, sort_order
comment: List Field Sets

CF::Form::FieldSets#create
comment: Create Field Set

CF::Forms::FieldSet#get
comment: Fetch Field Set

CF::Forms::FieldSet#update
comment: Update Field Set

CF::Forms::FieldSet#delete
comment: Remove Field Set

CF::Forms::FieldSet::Fields#list
pagination: cursor-based (after/before)
sort: sort_property, sort_order
comment: List Fields

CF::Forms::FieldSet::Fields#create
comment: Create Field

CF::Forms::Field#get
comment: Fetch Field

CF::Forms::Field#update
comment: Update Field

CF::Forms::Field#delete
comment: Remove Field

CF::Forms::FieldSet::Fields::Reorder#create
comment: Reorder Fields

CF::Forms::Field::Options#list
pagination: cursor-based (after/before)
sort: sort_property, sort_order
comment: List Options

CF::Forms::Field::Options#create
comment: Create Option

CF::Forms::Fields::Option#get
comment: Fetch Option

CF::Forms::Fields::Option#update
comment: Update Option

CF::Forms::Fields::Option#delete
comment: Remove Option

CF::Form::Submissions#list
pagination: cursor-based (after/before)
sort: sort_property, sort_order
comment: List Submissions

CF::Form::Submissions#create
comment: Create Submission

CF::Workspace::FormSubmissions#list
filters: available properties
pagination: cursor-based (after/before)
sort: sort_property, sort_order
comment: List Form Submissions

CF::Forms::Submission#get
comment: Fetch Submission

CF::Forms::Submission#update
comment: Update Submission

CF::Forms::Submission#delete
comment: Remove Submission

CF::Forms::Submission::Answers#list
pagination: cursor-based (after/before)
sort: sort_property, sort_order
comment: List Answers

CF::Forms::Submission::Answers#create
comment: Create Answer

CF::Forms::Submissions::Answer#get
comment: Fetch Answer

CF::Forms::Submissions::Answer#update
comment: Update Answer

CF::Forms::Submissions::Answer#delete
comment: Remove Answer
```

## Orders
```
CF::Workspace::Orders#list
filters: available properties
pagination: cursor-based (after/before)
sort: sort_property, sort_order
comment: List Orders

CF::Order#get
comment: Fetch Order

CF::Order#update
comment: Update Order

CF::Order::AppliedTags#list
comment: List Applied Tags

CF::Order::AppliedTags#create
comment: Create Applied Tag

CF::Orders::AppliedTag#get
comment: Fetch Applied Tag

CF::Orders::AppliedTag#delete
comment: Remove Applied Tag

CF::Workspace::Orders::Tags#list
comment: List Tags

CF::Workspace::Orders::Tags#create
comment: Create Tag

CF::Orders::Tag#get
comment: Fetch Tag

CF::Orders::Tag#update
comment: Update Tag

CF::Orders::Tag#delete
comment: Remove Tag

CF::Order::Invoices#list
comment: List Invoices

CF::Workspace::Orders::Invoices#list
pagination: cursor-based (after/before)
sort: sort_property, sort_order
comment: List Workspace Invoices

CF::Orders::Invoice#get
comment: Fetch Invoice

CF::Order::Transactions#list
comment: List Transactions

CF::Orders::Transaction#get
comment: Fetch Transaction

CF::Workspace::Orders::Invoices::Restocks#list
comment: List Restocks

CF::Orders::Invoices::Restock#get
comment: Fetch Restock
```

## Products
```
CF::Workspace::Products#list
filters: available properties
pagination: cursor-based (after/before)
sort: sort_property, sort_order
comment: List Products

CF::Workspace::Products#create
comment: Create Product

CF::Product#get
comment: Fetch Product

CF::Product#update
comment: Update Product

CF::Product::Archive#create
comment: Archive a Product

CF::Product::Unarchive#create
comment: Unarchive a Product

CF::Workspace::Products::Collections#list
filters: available properties
pagination: cursor-based (after/before)
sort: sort_property, sort_order
comment: List Collections

CF::Workspace::Products::Collections#create
comment: Create Collection

CF::Products::Collection#get
comment: Fetch Collection

CF::Products::Collection#update
comment: Update Collection

CF::Product::Prices#list
filters: available properties
pagination: cursor-based (after/before)
sort: sort_property, sort_order
comment: List Prices

CF::Product::Prices#create
comment: Create Price

CF::Products::Price#get
comment: Fetch Price

CF::Products::Price#update
comment: Update Price

CF::Product::Variants#list
filters: available properties
pagination: cursor-based (after/before)
sort: sort_property, sort_order
comment: List Variants

CF::Product::Variants#create
comment: Create Variant

CF::Products::Variant#get
comment: Fetch Variant

CF::Products::Variant#update
comment: Update Variant

CF::Workspace::Products::Tags#list
filters: available properties
pagination: cursor-based (after/before)
sort: sort_property, sort_order
comment: List Tags

CF::Workspace::Products::Tags#create
comment: Create Tag

CF::Products::Tag#get
comment: Fetch Tag

CF::Products::Tag#update
comment: Update Tag

CF::Products::Tag#delete
comment: Remove Tag
```

## Fulfillments
```
CF::Workspace::Fulfillments#list
pagination: cursor-based (after/before)
sort: sort_property, sort_order
comment: List Fulfillments

CF::Workspace::Fulfillments#create
comment: Create Fulfillment

CF::Fulfillment#get
comment: Fetch Fulfillment

CF::Fulfillment#update
comment: Update Fulfillment

CF::Fulfillment#delete
comment: Remove Fulfillment

CF::Fulfillment::Cancel#create
comment: Cancel a Fulfillment

CF::Workspace::Fulfillments::Locations#list
pagination: cursor-based (after/before)
sort: sort_property, sort_order
comment: List Locations

CF::Workspace::Fulfillments::Locations#create
comment: Create Location

CF::Fulfillments::Location#get
comment: Fetch Location

CF::Fulfillments::Location#update
comment: Update Location

CF::Fulfillments::Location#delete
comment: Remove Location
```

## Funnels
```
CF::Workspace::Funnels#list
filters: available properties
pagination: cursor-based (after/before)
sort: sort_property, sort_order
comment: List Funnels

CF::Funnel#get
comment: Fetch Funnel

CF::Funnel#update
comment: Update Funnel

CF::Workspace::Funnels::Tags#list
filters: available properties
pagination: cursor-based (after/before)
sort: sort_property, sort_order
comment: List Tags

CF::Workspace::Funnels::Tags#create
comment: Create Tag

CF::Funnels::Tag#get
comment: Fetch Tag

CF::Funnels::Tag#update
comment: Update Tag

CF::Funnels::Tag#delete
comment: Remove Tag
```

## Pages
```
CF::Workspace::Pages#list
filters: available properties
pagination: cursor-based (after/before)
sort: sort_property, sort_order
comment: List Pages

CF::Page#get
comment: Fetch Page

CF::Page#update
comment: Update Page
```

## Images
```
CF::Workspace::Images#list
pagination: cursor-based (after/before)
sort: sort_property, sort_order
comment: List Images

CF::Workspace::Images#create
comment: Create Image

CF::Image#get
comment: Fetch Image

CF::Image#update
comment: Update Image

CF::Image#delete
comment: Remove Image
```

## Sales
```
CF::Workspace::Sales::Pipelines#list
filters: available properties
pagination: cursor-based (after/before)
sort: sort_property, sort_order
comment: List Pipelines

CF::Workspace::Sales::Pipelines#create
comment: Create Pipeline

CF::Sales::Pipeline#get
comment: Fetch Pipeline

CF::Sales::Pipeline#update
comment: Update Pipeline

CF::Sales::Pipeline::Stages#list
filters: available properties
pagination: cursor-based (after/before)
sort: sort_property, sort_order
comment: List Stages

CF::Sales::Pipeline::Stages#create
comment: Create Stage

CF::Sales::Pipelines::Stage#get
comment: Fetch Stage

CF::Sales::Pipelines::Stage#update
comment: Update Stage

CF::Sales::Pipelines::Stage#delete
comment: Remove Stage

CF::Workspace::Sales::Opportunities#list
filters: available properties
pagination: cursor-based (after/before)
sort: sort_property, sort_order
comment: List Opportunities

CF::Workspace::Sales::Opportunities#create
comment: Create Opportunity

CF::Sales::Opportunitie#get
comment: Fetch Opportunity

CF::Sales::Opportunitie#update
comment: Update Opportunity

CF::Sales::Opportunitie#delete
comment: Remove Opportunity

CF::Sales::Opportunitie::Notes#list
filters: available properties
pagination: cursor-based (after/before)
sort: sort_property, sort_order
comment: List Notes

CF::Sales::Opportunitie::Notes#create
comment: Create Note

CF::Sales::Opportunities::Note#get
comment: Fetch Note

CF::Sales::Opportunities::Note#update
comment: Update Note

CF::Sales::Opportunities::Note#delete
comment: Remove Note
```

## Shipping
```
CF::Workspace::Shipping::Profiles#list
pagination: cursor-based (after/before)
sort: sort_property, sort_order
comment: List Profiles

CF::Workspace::Shipping::Profiles#create
comment: Create Profile

CF::Shipping::Profile#get
comment: Fetch Profile

CF::Shipping::Profile#update
comment: Update Profile

CF::Shipping::Profile#delete
comment: Remove Profile

CF::Shipping::Profile::LocationGroups#list
pagination: cursor-based (after/before)
sort: sort_property, sort_order
comment: List Location Groups

CF::Shipping::LocationGroup#get
comment: Fetch Location Group

CF::Shipping::LocationGroup::Zones#list
pagination: cursor-based (after/before)
sort: sort_property, sort_order
comment: List Zones

CF::Shipping::LocationGroup::Zones#create
comment: Create Zone

CF::Shipping::Zone#get
comment: Fetch Zone

CF::Shipping::Zone#update
comment: Update Zone

CF::Shipping::Zone#delete
comment: Remove Zone

CF::Shipping::Zone::Rates#list
pagination: cursor-based (after/before)
sort: sort_property, sort_order
comment: List Rates

CF::Shipping::Zone::Rates#create
comment: Create Rate

CF::Shipping::Rate#get
comment: Fetch Rate

CF::Shipping::Rate#update
comment: Update Rate

CF::Shipping::Rate#delete
comment: Remove Rate

CF::Workspace::Shipping::Rates::Names#list
pagination: cursor-based (after/before)
sort: sort_property, sort_order
comment: List Names

CF::Workspace::Shipping::Rates::Names#create
comment: Create Name

CF::Shipping::Rates::Name#get
comment: Fetch Name

CF::Shipping::Rates::Name#update
comment: Update Name

CF::Shipping::Rates::Name#delete
comment: Remove Name

CF::Workspace::Shipping::Packages#list
pagination: cursor-based (after/before)
sort: sort_property, sort_order
comment: List Packages

CF::Workspace::Shipping::Packages#create
comment: Create Package

CF::Shipping::Package#get
comment: Fetch Package

CF::Shipping::Package#update
comment: Update Package

CF::Shipping::Package#delete
comment: Remove Package
```

## Stores
```
CF::Workspace::Stores#list
pagination: cursor-based (after/before)
sort: sort_property, sort_order
comment: List Stores

CF::Workspace::Stores#create
comment: Create Store

CF::Store#get
comment: Fetch Store

CF::Store#update
comment: Update Store

CF::Store#delete
comment: Remove Store
```

## Themes & Styles
```
CF::Workspace::Themes#list
pagination: cursor-based (after/before)
sort: sort_property, sort_order
comment: List Themes

CF::Theme#get
comment: Fetch Theme

CF::Theme#update
comment: Update Theme

CF::Workspace::Styles#list
pagination: cursor-based (after/before)
sort: sort_property, sort_order
comment: List Styles
```

## Webhooks
```
CF::Workspace::Webhooks::Outgoing::Endpoints#list
pagination: cursor-based (after/before)
sort: sort_property, sort_order
comment: List Endpoints

CF::Workspace::Webhooks::Outgoing::Endpoints#create
comment: Create Endpoint

CF::Webhooks::Outgoing::Endpoint#get
comment: Fetch Endpoint

CF::Webhooks::Outgoing::Endpoint#update
comment: Update Endpoint

CF::Webhooks::Outgoing::Endpoint#delete
comment: Remove Endpoint

CF::Workspace::Webhooks::Outgoing::Events#list
pagination: cursor-based (after/before)
sort: sort_property, sort_order
comment: List Events

CF::Webhooks::Outgoing::Event#get
comment: Fetch Event
```

## Summary

Most list endpoints support:
- **Filtering**: Using `filter[property]=value` syntax
- **Pagination**: Cursor-based using `after` and `before` parameters
- **Sorting**: Using `sort_property` and `sort_order` parameters

The API follows RESTful conventions with standard CRUD operations across all resources.