def stub_current_user(user)
  controller.stub!(:current_user).and_return(user)
end