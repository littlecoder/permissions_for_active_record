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
        
        include AddPermissions::Permissions::InstanceMethods
        extend AddPermissions::Permissions::SingletonMethods
      end
    end

    module InstanceMethods
      def acting_user
        ActiveRecord::Base.acting_user
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

      @@acting_user = nil

      def acting_user= user
        @@acting_user = user
      end

      def acting_user
        @@acting_user
      end

    end
  end
  
  module AC
    module Base
      
      def pass_current_user
        ActiveRecord::Base.acting_user = current_user
      end
            
    end
  end

end
