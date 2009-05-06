module AddPermissions
  module Permissions

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def add_permissions
        before_create :is_creatable?
        before_save :is_updateable?
        before_destroy :is_destroyable?
        
        include Ubilabs::Has::Permissions::InstanceMethods
        extend Ubilabs::Has::Permissions::SingletonMethods
      end
    end

    module InstanceMethods
      def active_user
        ActiveRecord::Base.active_user
      end
      
      def is_creatable?
        true
      end
        
      def is_updateable?
        true
      end
        
      def is_viewable?
        true
      end
        
      def is_destroyable?
        true
      end
    end

    module SingletonMethods
    end
    
  end
  
  module AR
    module Base

      @@active_user = nil

      def active_user= user
        @@active_user = user
      end

      def active_user
        @@active_user
      end

    end
  end
  
  module AC
    module Base
      
      def pass_current_user
        ActiveRecord::Base.active_user = current_user
      end
            
    end
  end

end
