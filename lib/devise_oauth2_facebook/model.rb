module Devise
  module Models

    module DeviseOauth2Facebook
      extend ActiveSupport::Concern

      def do_update_facebook_user(fb_user, token)
        self.send("#{self.class.facebook_uid_field}=".to_sym, fb_user["id"])
        self.send("#{self.class.facebook_token_field}=".to_sym, token)
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
          end
        end
        puts "*"*100
        puts fb_user.email
        puts fb_user. 
        
        def create_with_facebook_user(fb_user, token)
          user = User.create!(:facebook_uid_field =>  fb_user["id"], :email => fb_user.email.downcase, :password => "fakepass", :password_confirmation => "fakepass")
          user.skip_confirmation! if user.respond_to?(:skip_confirmation!)
          user.do_update_facebook_user(fb_user, token)
          user
        end
      end
      
    end
  end
end
