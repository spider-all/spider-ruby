require 'ruby-enum'

USERAGENT = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.130 Safari/537.36"
HOST = "api.github.com"
TIMEZONE = "Asia/Shanghai"

class RequestType
  include Ruby::Enum

  define :TypeFollowing, "Following"
  define :TypeFollowers, "Followers"
  define :TypeUserinfo, "Userinfo"
end
