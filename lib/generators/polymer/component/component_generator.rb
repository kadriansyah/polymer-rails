module Polymer
    module Generators
        class ComponentGenerator < ::Rails::Generators::NamedBase
            source_root File.expand_path('../templates', __FILE__)

            def initialize(args, *options)
                super
                extract_parameter_name
            end

            def create_component_dir
                if @folder_name.empty?
                    empty_directory "app/assets/components/#{@component_name}"
                else
                    empty_directory "app/assets/components/#{@folder_name}/#{@component_name}"
                end
            end

            def copy_component_template
                if @folder_name.empty?
                    template 'component.html.erb', "app/assets/components/#{@component_name}/#{@component_name}.html"
                else
                    template 'component.html.erb', "app/assets/components/#{@folder_name}/#{@component_name}/#{@component_name}.html"
                end
            end

            private
            def extract_parameter_name
                @names = name.split('/')
                @folder_name = ''
                if @names.length > 0
                    for ii in 0..@names.length - 2
                        @folder_name += @names[ii] + '/'
                    end
                    @component_name = @names[@names.length - 1].gsub('_', '-').downcase
                else
                    @component_name = name.gsub('_', '-').downcase
                end
            end

            # def number_of_dots
            #     dots = ''
            #     for ii in 0..@names.length - 1
            #         dots += '../'
            #     end
            #     dots
            # end
        end
    end
end
