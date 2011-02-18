module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name

    when /the home\s?page/
      '/'

    when /the login page/
      new_session_path

    when /the registration page/
      new_user_path

    when /the settings page/
      settings_path

    when /the edit page of the place "([^"]*)"/
      edit_place_path(Place.find_by_name!($1))

    when /the page showing the places of "([^"]*)"/
      user_places_path(:username => $1)

    when /the information page/
      info_path

    when /the host "([^"]*)"/
      'http://' + $1 + '/'

    else
      begin
        page_name =~ /the (.*) page/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue Object => e
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end

end

World(NavigationHelpers)
