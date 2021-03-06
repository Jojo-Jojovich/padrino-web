=begin

This file mounts each application within the Padrino project to a specific path.
You can mount additional applications using any of these below:

   Padrino.mount("blog").to('/blog')
   Padrino.mount("blog", :app_class => "BlogApp").to('/blog')
   Padrino.mount("blog", :app_file =>  "/path/to/blog/app.rb").to('/blog')

Note that mounted apps by default should be placed into 'apps/app_name'.

=end

# Mounts the core application for this project
Padrino.mount("PadrinoWeb").to("/")
Padrino.mount("Admin").to("/admin")