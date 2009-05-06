module AddPermissions
  module Permissions

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def add_permissions
        before_create :creatable?
        before_save :updateable?
        before_destroy :destroyable?
        
        include AddPermissions::Permissions::InstanceMethods
        extend AddPermissions::Permissions::SingletonMethods
      end
    end

    module InstanceMethods
      def acting_user
        ActiveRecord::Base.acting_user
      end
      
      def creatable?
        true
      end
        
      def updateable?
        true
      end
        
      def viewable? field
        true
      end
        
      def destroyable?
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
