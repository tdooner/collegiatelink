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

##
# This gem provides a CollegiateLink API client in Ruby. It's still under
# development, so let me know if you plan to use it. (tomdooner@gmail.com)
#
module CollegiateLink
  # URL base for all requests. The API key will be substituted into this when
  # the request is made.
  URL_BASE = 'https://%s.collegiatelink.net/ws/'

  # Currently-supported CollegiateLink action request types
  ACTIONS = [
    'organization/list',
    'organization/roster',
    #'user/memberships',
    #'user/position',
    'event/list',
  ]

  # Raised when performing a CollegiateLink::Request for an action that is not
  # supported by the gem (as defined by CollegiateLink::ACTIONS).
  class UnknownAction < Exception; end

  # Raised when something unexpected goes wrong.
  class UnknownException < Exception; end

  # Raised when the CollegiateLink::Request HTTP request fails.
  class NetworkException < Exception; end

  # Raised when CollegiateLink returns that the combination of IP and SSL fails.
  class AuthenticationException < Exception; end

  # Raised for the CollegiateLink VALIDATION_ERROR case.
  class ValidationException < Exception; end
end
