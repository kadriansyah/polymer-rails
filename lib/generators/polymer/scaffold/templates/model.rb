require_dependency 'moslemcorners/common_model'

<% if namespaced? -%>
<% namespaces.each do |namespace| -%>
module <%= namespace.titleize %>
<% end -%>
<% end -%>
    class <%= singular_table_name.titleize %>
        include Mongoid::Document
        include MoslemCorners::CommonModel
        store_in collection: '<%= singular_table_name.pluralize %>'

        # kaminari page setting
        paginates_per 20

<% attributes.each_with_index do |attribute, index| -%>
        field :<%= attribute.column_name %>, type: <%= attribute.type %>, default: ""
<% end -%>

    end
<% if namespaced? -%>
<% namespaces.each do -%>
end
<% end -%>
<% end -%>
