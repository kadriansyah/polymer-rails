<% if !@folder_name.empty? -%>
module <%= module_name %>
<% end -%>
    class <%= singular_table_name.titleize %>Service
        def create_<%= singular_table_name %>(<%= singular_table_name %>_form)
            <%= singular_table_name %>_form.save
        end

        def update_<%= singular_table_name %>(<%= singular_table_name %>_form)
            <%= singular_table_name %>_form.update
        end

        def delete_<%= singular_table_name %>(id)
            <%= singular_table_name %> = find_<%= singular_table_name %>(id)
            <%= singular_table_name %>.delete
        end

        def find_<%= singular_table_name %>(id)
            <%= singular_table_name.camelize %>.find(id)
        end

        def find_<%= singular_table_name.pluralize %>(page = 0)
            <%= singular_table_name.camelize %>.page(page)
        end
    end
<% if !@folder_name.empty? -%>
end
<% end -%>