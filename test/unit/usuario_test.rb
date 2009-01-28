require File.dirname(__FILE__) + '/../test_helper'

class UsuarioTest < ActiveSupport::TestCase
  # Be sure to include AuthenticatedTestHelper in test/test_helper.rb instead.
  # Then, you can remove it from this and the functional test.
  include AuthenticatedTestHelper
  fixtures :usuarios

  def test_should_create_usuario
    assert_difference 'Usuario.count' do
      usuario = create_usuario
      assert !usuario.new_record?, "#{usuario.errors.full_messages.to_sentence}"
    end
  end

  def test_should_initialize_activation_code_upon_creation
    usuario = create_usuario
    usuario.reload
    assert_not_nil usuario.activation_code
  end

  def test_should_create_and_start_in_pending_state
    usuario = create_usuario
    usuario.reload
    assert usuario.pending?
  end


  def test_should_require_login
    assert_no_difference 'Usuario.count' do
      u = create_usuario(:login => nil)
      assert u.errors.on(:login)
    end
  end

  def test_should_require_password
    assert_no_difference 'Usuario.count' do
      u = create_usuario(:password => nil)
      assert u.errors.on(:password)
    end
  end

  def test_should_require_password_confirmation
    assert_no_difference 'Usuario.count' do
      u = create_usuario(:password_confirmation => nil)
      assert u.errors.on(:password_confirmation)
    end
  end

  def test_should_require_email
    assert_no_difference 'Usuario.count' do
      u = create_usuario(:email => nil)
      assert u.errors.on(:email)
    end
  end

  def test_should_reset_password
    usuarios(:quentin).update_attributes(:password => 'new password', :password_confirmation => 'new password')
    assert_equal usuarios(:quentin), Usuario.authenticate('quentin', 'new password')
  end

  def test_should_not_rehash_password
    usuarios(:quentin).update_attributes(:login => 'quentin2')
    assert_equal usuarios(:quentin), Usuario.authenticate('quentin2', 'monkey')
  end

  def test_should_authenticate_usuario
    assert_equal usuarios(:quentin), Usuario.authenticate('quentin', 'monkey')
  end

  def test_should_set_remember_token
    usuarios(:quentin).remember_me
    assert_not_nil usuarios(:quentin).remember_token
    assert_not_nil usuarios(:quentin).remember_token_expires_at
  end

  def test_should_unset_remember_token
    usuarios(:quentin).remember_me
    assert_not_nil usuarios(:quentin).remember_token
    usuarios(:quentin).forget_me
    assert_nil usuarios(:quentin).remember_token
  end

  def test_should_remember_me_for_one_week
    before = 1.week.from_now.utc
    usuarios(:quentin).remember_me_for 1.week
    after = 1.week.from_now.utc
    assert_not_nil usuarios(:quentin).remember_token
    assert_not_nil usuarios(:quentin).remember_token_expires_at
    assert usuarios(:quentin).remember_token_expires_at.between?(before, after)
  end

  def test_should_remember_me_until_one_week
    time = 1.week.from_now.utc
    usuarios(:quentin).remember_me_until time
    assert_not_nil usuarios(:quentin).remember_token
    assert_not_nil usuarios(:quentin).remember_token_expires_at
    assert_equal usuarios(:quentin).remember_token_expires_at, time
  end

  def test_should_remember_me_default_two_weeks
    before = 2.weeks.from_now.utc
    usuarios(:quentin).remember_me
    after = 2.weeks.from_now.utc
    assert_not_nil usuarios(:quentin).remember_token
    assert_not_nil usuarios(:quentin).remember_token_expires_at
    assert usuarios(:quentin).remember_token_expires_at.between?(before, after)
  end

  def test_should_register_passive_usuario
    usuario = create_usuario(:password => nil, :password_confirmation => nil)
    assert usuario.passive?
    usuario.update_attributes(:password => 'new password', :password_confirmation => 'new password')
    usuario.register!
    assert usuario.pending?
  end

  def test_should_suspend_usuario
    usuarios(:quentin).suspend!
    assert usuarios(:quentin).suspended?
  end

  def test_suspended_usuario_should_not_authenticate
    usuarios(:quentin).suspend!
    assert_not_equal usuarios(:quentin), Usuario.authenticate('quentin', 'test')
  end

  def test_should_unsuspend_usuario_to_active_state
    usuarios(:quentin).suspend!
    assert usuarios(:quentin).suspended?
    usuarios(:quentin).unsuspend!
    assert usuarios(:quentin).active?
  end

  def test_should_unsuspend_usuario_with_nil_activation_code_and_activated_at_to_passive_state
    usuarios(:quentin).suspend!
    Usuario.update_all :activation_code => nil, :activated_at => nil
    assert usuarios(:quentin).suspended?
    usuarios(:quentin).reload.unsuspend!
    assert usuarios(:quentin).passive?
  end

  def test_should_unsuspend_usuario_with_activation_code_and_nil_activated_at_to_pending_state
    usuarios(:quentin).suspend!
    Usuario.update_all :activation_code => 'foo-bar', :activated_at => nil
    assert usuarios(:quentin).suspended?
    usuarios(:quentin).reload.unsuspend!
    assert usuarios(:quentin).pending?
  end

  def test_should_delete_usuario
    assert_nil usuarios(:quentin).deleted_at
    usuarios(:quentin).delete!
    assert_not_nil usuarios(:quentin).deleted_at
    assert usuarios(:quentin).deleted?
  end

protected
  def create_usuario(options = {})
    record = Usuario.new({ :login => 'quire', :email => 'quire@example.com', :password => 'quire69', :password_confirmation => 'quire69' }.merge(options))
    record.register! if record.valid?
    record
  end
end
