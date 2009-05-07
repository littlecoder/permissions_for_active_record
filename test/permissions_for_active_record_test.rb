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
  
  context 'A Instance of ActiveRecord::Base using permissions' do
    
    setup do
      @post = Post.new(:title => 'Hello World!', :text => 'This is the first entry.')
    end
    
    should 'have the standard methods for permissions' do
      assert defined? @post.creatable?
      assert defined? @post.updateable?
      assert defined? @post.viewable?
      assert defined? @post.destroyable?
      assert defined? @post.view
    end
        
  end
  
  context 'An Instance of ActiveRecord::Base with overwritten permission methods' do
    
    setup do
      @post = Post.new(:title => 'Hello World!', :text => 'This is the first entry.')
      @post.class_eval do
        def creatable?
          false
        end
        
        def viewable? field
          field == :title
        end
      end
    end
    
    should 'not be created' do
      assert !@post.save
    end
    
    should 'only show the as viewable defined fields' do
      assert_equal @post.title, @post.view(:title)
      assert_nil @post.view(:text)
      assert_nil @post.view(:unknown_field)
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
  
  context 'The ViewProxy' do
    
    setup do
      @post = Post.new(:title => 'Hello World!', :text => 'This is the first entry.')
      @post.class_eval do
        def viewable? field
          field != :text
        end
      end
      @view_proxy = ViewProxy.new @post
    end
    
    should 'return nil for undefined or not viewable methods' do
      assert_nil @view_proxy.unknown_field
      assert_nil @view_proxy.text
    end
    
    should 'return the content for viewable methods' do
      assert_equal @post.title, @view_proxy.title
    end
    
  end
  
  context 'The view_for helper' do
    
    setup do
      @post = Post.new(:title => 'Hello World!', :text => 'This is the first entry.')
    end
    
    should 'deliver the correct methods' do
      view_for @post do |o|
        assert_equal @post.title, o.title
      end
      view_for @post do |o|
        o.title do |a|
          assert_equal @post.title, a
        end
      end
    end
    
  end

end
