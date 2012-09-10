require 'digest'
require 'net/https'
require 'net/ssh'
require 'guid'
require 'nokogiri'
require 'happymapper'

require 'collegiatelink/response'
require 'collegiatelink/request'
require 'collegiatelink/client'
require 'collegiatelink/organization'

module CollegiateLink
  URL_BASE = 'https://%s.collegiatelink.net/ws/'

  ACTIONS = [
    'organization/list',
    'organization/roster',
    'user/memberships',
    'user/position',
    'event/list',
  ]

  class UnknownAction < Exception; end
  class UnknownException < Exception; end
  class NetworkException < Exception; end
  class AuthenticationException < Exception; end
  class ValidationException < Exception; end
end
