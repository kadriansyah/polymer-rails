require_dependency 'moslemcorners/di_container'
<% tabs = '' -%>
<% if namespaced? -%>
<% namespaces.each do |namespace| -%>
<%= tabs %>module <%= namespace.titleize %>
<% tabs += '    ' -%>
<% end -%>
<% end -%>
    class <%= singular_table_name.titleize %>Controller < ApplicationController
        include MoslemCorners::INJECT['<%= singular_table_name %>_service']

        # http://api.rubyonrails.org/classes/ActionController/ParamsWrapper.html
        wrap_parameters :<%= singular_table_name %>, include: [:id, <% attributes.each_with_index do |attribute, index| -%>:<%= attribute.column_name %><% if index < attributes.size - 1 -%>, <% end -%><% end -%>]

        def index
            <%= singular_table_name.pluralize %> = <%= singular_table_name %>_service.find_<%= singular_table_name.pluralize %>(params[:page])
            if (<%= singular_table_name.pluralize %>.size > 0)
                respond_to do |format|
                    format.json { render :json => { results: <%= singular_table_name.pluralize %> }}
                end
            else
                render :json => { results: []}
            end
        end

        def delete
            if <%= singular_table_name %>_service.delete_<%= singular_table_name %>(params[:id])
                respond_to do |format|
                    format.json { render :json => { status: "200", message: "Success" } }
                end
            else
                respond_to do |format|
                    format.json { render :json => { status: "404", message: "Failed" } }
                end
            end
        end

        def create
            <%= singular_table_name %>_form = <%= singular_table_name.titleize %>Form.new(<%= singular_table_name %>_form_params)
            if <%= singular_table_name %>_service.create_<%= singular_table_name %>(<%= singular_table_name %>_form)
                respond_to do |format|
                    format.json { render :json => { status: "200", message: "Success" } }
                end
            else
                respond_to do |format|
                    format.json { render :json => { status: "404", message: "Failed" } }
                end
            end
        end

        def edit
            id = params[:id]
            <%= singular_table_name %> = <%= singular_table_name %>_service.find_<%= singular_table_name %>(id)

            if <%= singular_table_name %>
                respond_to do |format|
                    format.json { render :json => { status: "200", payload: <%= singular_table_name %> } }
                end
            else
                respond_to do |format|
                    format.json { render :json => { status: "404", message: "Failed" } }
                end
            end
        end

        def update
            <%= singular_table_name %>_form = <%= singular_table_name.titleize %>Form.new(<%= singular_table_name %>_form_params)
            if <%= singular_table_name %>_service.update_<%= singular_table_name %>(<%= singular_table_name %>_form)
                respond_to do |format|
                    format.json { render :json => { status: "200", message: "Success" } }
                end
            else
                respond_to do |format|
                    format.json { render :json => { status: "404", message: "Failed" } }
                end
            end
        end

        private

        # Using strong parameters
        def <%= singular_table_name %>_form_params
            params.require(:<%= singular_table_name %>).permit(:id, <% attributes.each_with_index do |attribute, index| -%>:<%= attribute.column_name %><% if index < attributes.size - 1 -%>, <% end -%><% end -%>)
            # params.require(:<%= singular_table_name %>).permit! # allow all
        end
        end
<% if namespaced? -%>
<% namespaces.each do -%>
end
<% end -%>
<% end -%>