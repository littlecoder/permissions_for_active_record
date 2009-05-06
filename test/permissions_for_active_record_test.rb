require File.dirname(__FILE__) + '/test_helper'

class PermissionsForActiveRecordTest < Test::Unit::TestCase

  include AddPermissions::Permissions
  
  context 'The class ActiveRecord::Base' do

    should 'have a getter for acting_user' do
      assert defined? ActiveRecord::Base.acting_user
    end
    
    should 'have a setter for acting_user' do
      assert defined? ActiveRecord::Base.acting_user=()
    end
    
  end
  
  context 'A Instance of ActiveRecord::Base' do
    
    setup do
      @post = Post.new(:title => 'Hello World!', :text => 'This is the first entry.')
    end
    
    should 'have the standard methods for permissions' do
      assert defined? @post.is_creatable?
      assert defined? @post.is_updateable?
      assert defined? @post.is_viewable?
      assert defined? @post.is_destroyable?
    end
        
  end
  
  context 'An Instance of ActiveRecord::Base with overwritten permission methods' do
    
    setup do
      @post = Post.new(:title => 'Hello World!', :text => 'This is the first entry.')
      @post.class_eval do
        def is_creatable?
          false
        end
      end
    end
    
    should 'not be created' do
      assert !@post.save
    end
    
  end
  
  context 'An Instance of ActionController::Base' do
    
    setup do
      @post = Post.new(:title => 'Hello World!', :text => 'This is the first entry.')
      @user = User.new(:name => 'Alice')
      @controller = ActionController::Base.new
      @controller.class_eval do
        attr_accessor :current_user
      end
      @controller.current_user = @user
    end
    
    should 'should set the active user accordingly' do
      @controller.pass_current_user
      assert_equal @user, @post.acting_user
    end
    
  end

end
