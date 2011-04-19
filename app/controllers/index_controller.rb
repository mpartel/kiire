class IndexController < ApplicationController

  def index
    @places = addressed_user.places
    @show_via_field = addressed_user.get_setting_value(:show_via_field)
    @mobile_browser = mobile_browser?
  end

protected
  def check_authorization
    apply_hostname
    must_be_logged_in unless addressed_user && addressed_user.get_setting('dont_require_login').value
  end

  def addressed_user
    if current_user
      current_user
    elsif params[:username]
      User.find_by_username_case_insensitive(params[:username])
    end
  end

  def apply_hostname
    username = username_from_hostname
    params[:username] = username if username
  end

  def mobile_browser?
    ua = request.env['HTTP_USER_AGENT']
    mobile_browsers = addressed_user.get_setting_value(:mobile_browsers) || ''
    mobile_browsers = mobile_browsers.split("\n").map(&:strip).reject(&:empty?)
    mobile_browsers.each do |pattern|
      regex = browser_pattern_to_regex(pattern)
      if ua =~ regex
        return true
      end
    end
    return false
  end

  def browser_pattern_to_regex(pattern)
    regex = ""
    pattern.each_char do |c|
      if c == '*'
        regex += '.*'
      else
        regex += Regexp.quote(c)
      end
    end
    return Regexp.compile(regex)
  end

end
