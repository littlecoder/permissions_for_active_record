require 'permissions_for_active_record'
require 'permissions_helper'
require 'view_proxy'

ActiveRecord::Base.send :include, AddPermissions::Permissions

ActiveRecord::Base.send :extend, AddPermissions::AR::Base

ActionController::Base.send :include, AddPermissions::AC::Base
