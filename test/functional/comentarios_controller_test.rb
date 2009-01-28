require 'test_helper'

class ComentariosControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:comentarios)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create comentario" do
    assert_difference('Comentario.count') do
      post :create, :comentario => { }
    end

    assert_redirected_to comentario_path(assigns(:comentario))
  end

  test "should show comentario" do
    get :show, :id => comentarios(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => comentarios(:one).id
    assert_response :success
  end

  test "should update comentario" do
    put :update, :id => comentarios(:one).id, :comentario => { }
    assert_redirected_to comentario_path(assigns(:comentario))
  end

  test "should destroy comentario" do
    assert_difference('Comentario.count', -1) do
      delete :destroy, :id => comentarios(:one).id
    end

    assert_redirected_to comentarios_path
  end
end
