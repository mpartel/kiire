module HostnameHelper
  def username_from_hostname
    controller.send(:username_from_hostname)
  end

  def hostname_without_username
    controller.send(:hostname_without_username)
  end

  def with_regular_hostname(path_or_url)
    uri = URI.parse(path_or_url)
    current_uri = URI.parse(current_url)
    uri.scheme ||= current_uri.scheme
    uri.port ||= current_uri.port unless [80, 443].include? current_uri.port

    uri.host = hostname_without_username

    return uri.to_s
  end

private
  def current_url
    url_for :only_path => false
  end
end