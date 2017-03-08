module Polymer
    module Generators
        class ScaffoldGenerator < ::Rails::Generators::NamedBase
            source_root File.expand_path('../templates', __FILE__)
            argument :attributes, type: :array, default: [], banner: "field:type field:type"

            def initialize(args, *options)
                super
                extract_parameter_name
            end

            # polymer component directory
            def create_component_dir
                if @folder_name.empty?
                    available_views.each do |view|
                        empty_directory "app/assets/components/#{@component_name}-#{view}"
                    end
                else
                    available_views.each do |view|
                        empty_directory "app/assets/components/#{@folder_name}/#{@component_name}-#{view}"
                    end

                    # controllers
                    empty_directory "app/controllers/#{@folder_name}"

                    # services
                    empty_directory "app/services/#{@folder_name}"

                    # form value objects
                    empty_directory "app/value_objects/#{@folder_name}"
                end
            end

            def copy_component_template
                if @folder_name.empty?
                    # polymer components
                    available_views.each do |view|
                        template "#{view}.html.erb", "app/assets/components/#{@component_name}-#{view}/#{@component_name}-#{view}.html"
                    end

                    # controllers
                    template 'controller.rb', "app/controllers/#{@component_name}_controller.rb"

                    # services
                    template 'service.rb', "app/services/#{@component_name}_service.rb"

                    # form value objects
                    template 'form.rb', "app/value_objects/#{@component_name}_form.rb"
                else
                    # polymer components
                    available_views.each do |view|
                        template "#{view}.html.erb", "app/assets/components/#{@folder_name}/#{@component_name}-#{view}/#{@component_name}-#{view}.html"
                    end

                    # controllers
                    template 'controller.rb', "app/controllers/#{@folder_name}/#{@component_name}_controller.rb"

                    # services
                    template 'service.rb', "app/services/#{@folder_name}/#{@component_name}_service.rb"

                    # form value objects
                    template 'form.rb', "app/value_objects/#{@folder_name}/#{@component_name}_form.rb"
                end
            end

            def add_resource_route
                    insert_into_file 'config/routes.rb', :before => /^end/ do <<-RUBY
    resources "#{singular_table_name.pluralize}", controller: "#{singular_table_name}" do
        get 'delete', on: :member # http://guides.rubyonrails.org/routing.html#adding-more-restful-actions
    end
                        RUBY
                    end
            end

            private
            def available_views
                %w(form list)
            end

            def namespaced?
                if @namespaces.size == 0
                    false
                else
                    true
                end
            end

            def namespaces
                @namespaces
            end

            def singular_table_name
                @component_name
            end

            def extract_parameter_name
                @namespaces = []
                @names = name.split('/')
                @folder_name = ''
                if @names.length > 0
                    for ii in 0..@names.length - 2
                        @namespaces[ii] = @names[ii]
                        @folder_name += @names[ii] + '/'
                    end
                    @component_name = @names[@names.length - 1].gsub('_', '-').downcase
                else
                    @component_name = name.gsub('_', '-').downcase
                end
            end
        end
    end
end
