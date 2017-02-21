module Polymer
    module Generators
        class InstallGenerator < ::Rails::Generators::Base
            source_root File.expand_path('../templates', __FILE__)
            argument :namespace_name, :type => :string, :default => ""

            desc "Adds app/assets/components and vendor/assets/components directories and adds webcomponents to js manifest"

            def create_manifest
                template "application.html.erb", "app/assets/components/#{folder_name}/application.html.erb"
            end

            def inject_js
                insert_into_file "app/assets/javascripts/#{folder_name}/application.js", before: "//= require jquery\n" do
                    out = ""
                    out << "//= require #{folder_name}/webcomponentsjs/webcomponents-lite"
                    out << "\n"
                end
            end

            def copy_bowerrc
                template "bowerrc.json", ".bowerrc"
            end

            def create_vendor_dir
                create_file "vendor/assets/components/.keep"
            end

            private
            def folder_name
                namespace_name.underscore
            end
        end
    end
end
