<% if namespaced? -%>
<% namespaces.each do |namespace| -%>
module <%= namespace.titleize %>
<% end -%>
<% end -%>
    class <%= singular_table_name.titleize %>Form
        include ActiveModel::Model

        attr_accessor(:id, <% attributes.each_with_index do |attribute, index| -%>:<%= attribute.column_name %><% if index < attributes.size - 1 -%>, <% end -%><% end -%>)

        # Validations
        <% attributes.each do |attribute| -%>
        validates :<%= attribute.column_name %>, presence: false
        <% end -%>

        def save
            if valid?
                <%= singular_table_name %> = <%= singular_table_name.camelize %>.new(id: self.id, <% attributes.each_with_index do |attribute, index| -%><%= attribute.column_name %>: self.<%= attribute.column_name %><% if index < attributes.size - 1 -%>, <% end -%><% end -%>)
                <%= singular_table_name %>.save
                true
            else
                false
            end
        end

        def update
            if valid?
                <%= singular_table_name %> = <%= singular_table_name.camelize %>.find(self.id)
                <%= singular_table_name %>.update_attributes!(<% attributes.each_with_index do |attribute, index| -%><%= attribute.column_name %>: self.<%= attribute.column_name if attribute.column_name != 'id' %><% if index < attributes.size - 1 -%>, <% end -%><% end -%>)
                true
            else
                false
            end
        end
    end
<% if namespaced? -%>
<% namespaces.each do -%>
end
<% end -%>
<% end -%>