require 'test/unit'
require 'rubygems'
require 'shoulda'
require 'active_record'
require 'active_record/fixtures'
require 'action_controller'

require File.dirname(__FILE__) + '/../lib/permissions_for_active_record'
require File.dirname(__FILE__) + '/../init'
require File.dirname(__FILE__) + '/fixtures/post'
require File.dirname(__FILE__) + '/fixtures/user'

ActiveRecord::Base.establish_connection({
  :adapter => 'sqlite3',
  :dbfile => 'test.db'
})

require File.dirname(__FILE__) + '/fixtures/schema'
