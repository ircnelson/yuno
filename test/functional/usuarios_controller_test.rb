require File.dirname(__FILE__) + '/../test_helper'
require 'usuarios_controller'

# Re-raise errors caught by the controller.
class UsuariosController; def rescue_action(e) raise e end; end

class UsuariosControllerTest < ActionController::TestCase
  # Be sure to include AuthenticatedTestHelper in test/test_helper.rb instead
  # Then, you can remove it from this and the units test.
  include AuthenticatedTestHelper

  fixtures :usuarios

  def test_should_allow_signup
    assert_difference 'Usuario.count' do
      create_usuario
      assert_response :redirect
    end
  end

  def test_should_require_login_on_signup
    assert_no_difference 'Usuario.count' do
      create_usuario(:login => nil)
      assert assigns(:usuario).errors.on(:login)
      assert_response :success
    end
  end

  def test_should_require_password_on_signup
    assert_no_difference 'Usuario.count' do
      create_usuario(:password => nil)
      assert assigns(:usuario).errors.on(:password)
      assert_response :success
    end
  end

  def test_should_require_password_confirmation_on_signup
    assert_no_difference 'Usuario.count' do
      create_usuario(:password_confirmation => nil)
      assert assigns(:usuario).errors.on(:password_confirmation)
      assert_response :success
    end
  end

  def test_should_require_email_on_signup
    assert_no_difference 'Usuario.count' do
      create_usuario(:email => nil)
      assert assigns(:usuario).errors.on(:email)
      assert_response :success
    end
  end
  
  def test_should_sign_up_user_in_pending_state
    create_usuario
    assigns(:usuario).reload
    assert assigns(:usuario).pending?
  end

  
  def test_should_sign_up_user_with_activation_code
    create_usuario
    assigns(:usuario).reload
    assert_not_nil assigns(:usuario).activation_code
  end

  def test_should_activate_user
    assert_nil Usuario.authenticate('aaron', 'test')
    get :activate, :activation_code => usuarios(:aaron).activation_code
    assert_redirected_to '/conta/new'
    assert_not_nil flash[:notice]
    assert_equal usuarios(:aaron), Usuario.authenticate('aaron', 'monkey')
  end
  
  def test_should_not_activate_user_without_key
    get :activate
    assert_nil flash[:notice]
  rescue ActionController::RoutingError
    # in the event your routes deny this, we'll just bow out gracefully.
  end

  def test_should_not_activate_user_with_blank_key
    get :activate, :activation_code => ''
    assert_nil flash[:notice]
  rescue ActionController::RoutingError
    # well played, sir
  end

  protected
    def create_usuario(options = {})
      post :create, :usuario => { :login => 'quire', :email => 'quire@example.com',
        :password => 'quire69', :password_confirmation => 'quire69' }.merge(options)
    end
end
