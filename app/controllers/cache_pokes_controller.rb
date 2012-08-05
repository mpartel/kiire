# Loads the application and its sqlite db into memory cache.
# Useful on shared hosting to keep the app speedy.
class CachePokesController < ApplicationController
  def show
    `find -type f -print0 | xargs -0 -I{} cat {} > /dev/null`
    success = $?.success?

    respond_to do |format|
      format.text { render :text => (if success then 'OK' else 'Fail' end) }
    end
  end

private
  def check_authorization
  end
end