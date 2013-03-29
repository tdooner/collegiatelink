module CollegiateLink
  ##
  # Represents a single HTTP request to the CollegiateLink API.
  #
  class Request
    ##
    # Create a new Request instance. See +CollegiateLink::ACTIONS+ for a list of
    # eligible actions.
    #
    # ==== Parameters:
    # All parameters are provided in the URL of the request to CollegiateLink.
    #
    # * <tt>:page</tt> - The desired page number of results. (default = 1)
    # * <tt>:pagesize</tt> - The desired number of records to return (default = 100)
    # * <tt>:modelformatting</tt> - Either "normal" or "humanreadable". (default = "normal")
    #
    # ==== Options:
    # Options are ways to pass in additional parameters about the request. The
    # following options are supported.
    #
    # * <tt>:sharedkey</tt> - (Required) The shared key which is used, but not included in the URL of requests
    # * <tt>:debug</tt> - Print debug information as the request happens.
    #
    def initialize(action, params = {}, opts = {})
      @action = action
      @params = params
      @opts = opts

      raise AuthenticationException unless opts.include?(:sharedkey)

      if OLD_ACTIONS.include?(action)
        @opts[:url_base] ||= 'https://casewestern.collegiatelink.net/ws/' % @params[:apikey]
        @opts[:response_format] = 'XML'
      elsif NEW_ACTIONS.include?(action)
        @opts[:url_base] ||= 'https://casewestern.collegiatelink.net/api/' % @params[:apikey]
        @opts[:response_format] = 'JSON'
      else
        raise UnknownAction, 'Action not supported!'
      end

      # URL Query String Parameters
      @params[:page]            ||= 1
      @params[:pageSize]        ||= 100

      # Default values for optional parameters
      @opts[:debug]     ||= true
    end

    ##
    # Execute the request by sending the HTTP request.
    #
    def perform
      # First, add the time-sensitive bits...
      request_params = @params.merge({
        time:   Time.now.to_i * 1000,
        random: Guid.new
      })
      request_params[:hash] = hash(request_params.merge(sharedkey: @opts[:sharedkey]))

      # Then, compute the URL...
      url = URI([
        @opts[:url_base],
        @action,
        '?',
        URI.encode_www_form(request_params),
      ].join)

      puts "requesting: \n#{url}"   if @opts[:debug]

      # Make the Request!
      res = CollegiateLink::Client.proxy.new(url.host, url.port)
      res.use_ssl = true
      res.verify_mode = OpenSSL::SSL::VERIFY_NONE

      resp = res.start { |h|
        h.request_get(url.to_s);
      }

      case resp
      when Net::HTTPSuccess
        case @opts[:response_format]
        when 'JSON'
          return parse_json_response(resp.body)
        when 'XML'
          return parse_xml_response(resp.body)
        end
      when Net::HTTPError
        raise NetworkException
      else
        raise UnknownException
      end
    end

    ##
    # Increment the page number and return a request instance that would receive
    # the next bunch of pages.
    #
    def request_for_next_page
      Request.new(@action, @params.merge(page: @params[:page] + 1), @opts)
    end

    private

    def parse_xml_response(body)
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

      CollegiateLink::Response::XML.new(d)
    end

    def parse_json_response(body)
      d = ::JSON.parse(body)
      # Handle errors?
      CollegiateLink::Response::JSON.new(d)
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
end
