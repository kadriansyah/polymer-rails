require_dependency 'moslemcorners/common_model'

class <%= namespaces if namespaced? %><%= singular_table_name.camelize %>
    include Mongoid::Document
    include MoslemCorners::CommonModel
    store_in collection: '<%= singular_table_name.pluralize %>'

    # kaminari page setting
    paginates_per 20

<% attributes.each_with_index do |attribute, index| -%>
    field :<%= attribute.column_name %>, type: <%= attribute.type %>, default: ""
<% end -%>
end
