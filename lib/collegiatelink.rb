require 'digest'
require 'net/https'
require 'net/ssh'
require 'guid'
require 'nokogiri'

module CollegiateLink
  URL_BASE = 'https://casewestern.collegiatelink.net/ws/'
  ACTIONS = [
    'organization/list',
    'organization/roster',
    'user/memberships',
    'user/position',
    'event/list',
  ]

  class Client
    def initialize(key, ip)
      @key = key
      @ip = ip
    end

    def request(action, params = {})
      params[:apikey] = 'casewestern'
      params[:ip]     = @ip

      opts             = {}
      opts[:sharedkey] = @key

      cl_request = CollegiateLink::Request.new(action, params, opts)
      cl_resp = cl_request.perform

      all_items = cl_resp.items

      while cl_resp.has_next_page?
        cl_resp = cl_request.request_for_next_page.perform
        all_items += cl_resp.items
      end

      puts all_items
    end
  end

  class Request
    def initialize(action, params = {}, opts = {})
      raise UnknownAction unless ACTIONS.include?(action)
      raise AuthenticationException unless opts.include?(:sharedkey)

      @action = action
      @params = params
      @opts = opts

      # URL Parameters
      @params[:page]            ||= 1
      @params[:pagesize]        ||= 100
      @params[:modelformatting] ||= 'normal'
    end

    def perform
      # First, add the time-sensitive bits...
      request_params = @params.merge({
        time:   Time.now.to_i * 1000,
        random: Guid.new
      })
      request_params[:hash] = hash(request_params.merge(sharedkey: @opts[:sharedkey]))

      url = URI("#{URL_BASE}#{@action}?#{URI.encode_www_form(request_params)}")
      res = Net::HTTP.new(url.host, url.port)
      res.use_ssl = true
      res.verify_mode = OpenSSL::SSL::VERIFY_NONE

      resp = res.start { |h|
        h.request_get(url.to_s);
      }

      case resp
      when Net::HTTPSuccess
        return parse_response(resp.body)
      when Net::HTTPError
        raise NetworkException
      else
        raise UnknownException
      end
    end

    def request_for_next_page
      Request.new(@action, @params.merge(page: @params[:page] + 1), @opts)
    end

    private

    def parse_response(body)
      d = Nokogiri::XML::Document.parse(body)

      # Parse exceptions
      if d.xpath("//results/error").length > 0
        type = d.xpath('//results/error/type').inner_html
        message = d.xpath('//results/error/message').inner_html
        case type
        when 'AUTHENTICATION_ERROR'
          raise AuthenticationException, message
        when 'VALIDATION_ERROR'
          raise ValidationException, message
        when 'UNKNOWN_SERVICE'
          raise UnknownAction, message
        when 'GENERAL_ERROR'
          raise UnknownException, message
        else
          raise UnknownException, message
        end
      end

      # Handle pagination
      raise UnknownException unless d.xpath('//results/page')

      Response.new(d)
    end

    def hash(params = {})
      Digest::MD5.hexdigest [
        params[:apikey],
        params[:ip],
        params[:time].to_i,
        params[:random],
        params[:sharedkey],
      ].join
    end
  end

  class Response
    def initialize(document)
      @document = document
      @page_size   = document.xpath('//results/page/pageSize').inner_html.to_i
      @page_number = document.xpath('//results/page/pageNumber').inner_html.to_i
      @total_items = document.xpath('//results/page/totalItems').inner_html.to_i
      @total_pages = document.xpath('//results/page/totalPages').inner_html.to_i
    end

    def items
      @document.xpath('//results/page/items').inner_html
    end

    def has_next_page?
      @page_number < @total_pages
    end
  end

  class UnknownAction < Exception; end
  class UnknownException < Exception; end
  class NetworkException < Exception; end
  class AuthenticationException < Exception; end
  class ValidationException < Exception; end
end
