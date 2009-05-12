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
        
        #
        # add permissions to associations
        #

        # loop over all associations
        self.reflect_on_all_associations.each do |asoc|
          # check if the associated class already has creatable_by_association? (set by another ActiveRecord with permissions)
          unless defined? asoc.klass.saveable_by_association?
            # add a new before_save filter to this ActiveRecord and the method creatable_by_association?
            asoc.klass.class_eval do
              def saveable_by_association?
                res = true
                
                # check only the changed methods
                self.changed.each do |c|
                  # get the association for this method
                  a1 = self.class.reflect_on_all_associations.detect do |a|
                    a.primary_key_name == c
                  end
                  
                  # if the changed method has an association
                  if a1
                    # get the associated ActiveRecord
                    ao = self.method(a1.name).call
                    # get the ActiveRecord's corresponding association
                    a2 = ao.class.reflect_on_all_associations.detect do |a|
                      a.primary_key_name == c and a.klass == self.class
                    end
                    # check if the method of the associated object for this ActiveRecord is updateable
                    if ao
                      begin
                        res &= ao.updateable?(a2.name)
                      rescue
                      end
                    end
                    errors.add_to_base 'The ' + self.class.name + ' associated with ' + ao.class.name + ' is not permitted to be saved.' unless res
                  end
                end
                
                res
              end
              
              # activate the before_save filter
              before_save :saveable_by_association?
            end
          end
        end
        
      end
    end

    module InstanceMethods
      
      def acting_user
        ActiveRecord::Base.acting_user
      end
      
      def creatable?
        true
      end
        
      def updateable? method = nil
        true
      end
        
      def viewable? field
        true
      end
        
      def destroyable?
        true
      end
      
      def view field
        
        if field.is_a?(Symbol) and viewable? field
          if block_given?
            yield self[field]
          else
            self[field]
          end
        end
        
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
