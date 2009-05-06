require 'permissions_for_active_record'
ActiveRecord::Base.send :include, AddPermissions::Has::Permissions

ActiveRecord::Base.send :extend, AddPermissions::AR::Base

ActionController::Base.send :include, AddPermissions::AC::Base
