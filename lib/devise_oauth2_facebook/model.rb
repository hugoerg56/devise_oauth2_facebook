module Devise
  module Models

    module DeviseOauth2Facebook
      extend ActiveSupport::Concern

      def do_update_facebook_user(fb_user, token)
        self.email = fb_user.email.to_s.downcase if fb_user.email.present?
        update_facebook_user(fb_user)
        self.save(:validate => false)
      end
      
      def update_facebook_user(fb_user)
        # override me
      end

      def active?
        true
      end

      protected
      module ClassMethods
        Devise::Models.config(self, :facebook_uid_field, :facebook_token_field)

        def find_with_facebook_user(fb_user, token)
          user = User.last(:conditions => {:email => fb_user.email.downcase})    
          if !user.nil?
            user
          else
            create_with_facebook_user(fb_user, token)
          end
        end
             
        def create_with_facebook_user(fb_user, token)
          user = User.create!( :email => fb_user.email.downcase, :password => "fakepass", :password_confirmation => "fakepass")
          user.skip_confirmation
          user.do_update_facebook_user(fb_user, token)
          user
        end
        
        def create_person_fulldata(fb_user, token, cliente)
          person_f = Person.last(:conditions => {:email => fb_user.email.downcase}) 
          unparse_data = JSON.parse(fb_user.unparsed)  
          
          begin  
            puts person_f.email
            puts "Ya existe un usuario con este correo registrado!"
          rescue
            puts "plan: " + $plan 
            usuario = cliente.selection.me.info!
            
            
            #send message
            fb_data = YAML.load_file("#{RAILS_ROOT}/config/facebook.yml") 
            puts fb_data["facebook"]["message"]
            puts fb_data["facebook"]["title"]
            puts fb_data["facebook"]["link"]
            puts fb_data["facebook"]["picture"]
            puts fb_data["facebook"]["description"]
            
            cliente.selection.user(usuario[:id]).feed.publish!(:message => fb_data["facebook"]["message"], :name => fb_data["facebook"]["title"], :link => fb_data["facebook"]["link"], :picture => fb_data["facebook"]["picture"], :description => fb_data["facebook"]["description"])
           
            person_f = Person.create( :email => fb_user.email.downcase, :nombre => fb_user.name, :telefono => "0", :account => 'turistico')
            person_f.opportunities.create(:plan => $plan, :estado => 'lead', :colores => '0', :precio_total => '0', :cantidad => '0', :facebook => unparse_data["link"], :notas => 'Creado con data de facebook!')
            person_f.save
            puts "Person creado correctamente!"      
          end
          puts "*"*100
        end
        
        
        def create_person_onboarding(tag, fb_user, token, cliente)
          person_f = Person.last(:conditions => {:email => fb_user.email.downcase}) 
          unparse_data = JSON.parse(fb_user.unparsed)  
          
          begin  
            puts person_f.email
            puts "Ya existe un usuario con este correo registrado!"
          rescue
            usuario = cliente.selection.me.info!
        
            #cliente.selection.user(usuario[:id]).feed.publish!(:message => fb_data["facebook"]["message"], :name => fb_data["facebook"]["title"], :link => fb_data["facebook"]["link"], :picture => fb_data["facebook"]["picture"], :description => fb_data["facebook"]["description"])
           
            person_f = Person.create( :email => fb_user.email.downcase, :nombre => fb_user.name, :telefono => "0", :account => tag)
            person_f.opportunities.create(:estado => 'lead', :colores => '0', :precio_total => '0', :cantidad => '0', :facebook => unparse_data["link"], :notas => 'Creado con data de facebook dede onboarding!')
            person_f.save
            puts "Person creado correctamente!"      
          end
          puts "*"*100
        end
        
        def create_person_tucupon(tag, fb_user, token, cliente)
          person_f = Person.last(:conditions => {:email => fb_user.email.downcase}) 
          unparse_data = JSON.parse(fb_user.unparsed)  
          
          begin  
            puts person_f.email
            puts "Ya existe un usuario con este correo registrado!"
          rescue
            usuario = cliente.selection.me.info!
        
            #cliente.selection.user(usuario[:id]).feed.publish!(:message => fb_data["facebook"]["message"], :name => fb_data["facebook"]["title"], :link => fb_data["facebook"]["link"], :picture => fb_data["facebook"]["picture"], :description => fb_data["facebook"]["description"])
           
            person_f = Person.create( :email => fb_user.email.downcase, :nombre => fb_user.name, :telefono => "0", :account => "tucupon-"+tag)
            person_f.opportunities.create(:estado => 'lead', :colores => '0', :precio_total => '0', :cantidad => '0', :facebook => unparse_data["link"], :notas => 'Creado con data de facebook dede onboarding!')
            person_f.save
            puts "Person creado correctamente!"      
          end
          puts "*"*100
        end
        
      end
      
    end
  end
end

