def stub_current_user(user)
  controller.stub!(:current_user).and_return(user)
end

def stub_addressed_user(user)
  controller.stub!(:addressed_user).and_return(user)
end