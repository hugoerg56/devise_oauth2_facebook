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
        
        def create_person_fulldata(fb_user, token)
          
          person_f = Person.last(:conditions => {:email => fb_user.email.downcase}) 
          puts person_f
          if !person_f.nil?
            person_f = Person.create!( :email => fb_user.email.downcase, :nombre => fb_user.name, :telefono => "0", :opportunities => {:estado => 'lead', :colores => '0', :precio_total => '0', :cantidad => '0', :facebook => fb_user.link, :notas => 'Creado con data de facebook!'})
            person_f.save
            puts "Person creado correctamente!"
          else
            puts "Ya existe un usuario con este correo registrado!"
          end
          puts "*"*100
        end
      end
      
    end
  end
end
