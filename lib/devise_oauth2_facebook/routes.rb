ActionDispatch::Routing::Mapper.class_eval do

    protected

    def devise_facebook_consumer(mapping, controllers)
      scope mapping.fullpath do
        get mapping.path_names[:fb_auth], :to => "#{controllers[:facebook_consumer]}#auth", :as => :fb_auth
        get mapping.path_names[:fb_auth2], :to => "#{controllers[:facebook_consumer]}#auth2", :as => :fb_auth2
        get mapping.path_names[:fb_auth_onboarding], :to => "#{controllers[:facebook_consumer]}#auth_onboarding", :as => :fb_auth_onboarding
        get mapping.path_names[:fb_auth_tucupon], :to => "#{controllers[:facebook_consumer]}#auth_tucupon", :as => :fb_auth_tucupon
        get mapping.path_names[:fb_callback], :to => "#{controllers[:facebook_consumer]}#callback", :as => :fb_callback
        get mapping.path_names[:fb_callback2], :to => "#{controllers[:facebook_consumer]}#callback2", :as => :fb_callback2
        get mapping.path_names[:fb_callback_onboarding], :to => "#{controllers[:facebook_consumer]}#callback_onboarding", :as => :fb_callback_onboarding
        get mapping.path_names[:fb_callback_tucupon], :to => "#{controllers[:facebook_consumer]}#callback_tucupon", :as => :fb_callback_tucupon
      end
    end
end