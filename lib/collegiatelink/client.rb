module CollegiateLink

  # The Client is what makes the requests to CollegiateLink.
  class Client
    ##
    # Creates a CollegiateLink client.
    #
    # ==== Parameters:
    # * +options+ - A hash containing the following values:
    #   * +apikey+ - The CollegiateLink "apikey"
    #   * +ip+ - (Optional) The IP address that the +apikey+ is approved for,
    #     if and only if that is how the +apikey+ is configured on CollegiateLink's
    #     side.
    #   * +privatekey+ - The shared key granted by CollegiateLink to your IP and
    #     institution.
    #
    def initialize(options = {})
      @params = {
        apikey: options[:apikey],
      }
      @params.merge(ip: options[:ip]) if options[:ip]

      @opts = {
        privatekey: options[:privatekey],
      }
      @@proxy = Net::HTTP
    end

    def self.proxy
      @@proxy
    end

    def use_socks_proxy(host, port)
      @@proxy = Net::HTTP.SOCKSProxy(host, port)
    end

    ##
    # Return a complete list of CollegiateLink::Organization instances for your
    # institution.
    #
    # ==== Required Parameters:
    # None
    #
    # ==== Optional Parameters:
    # See CollegiateLink::Request#initialize for a list of optional parameters
    #
    def organizations(params = {})
      request('organizations', CollegiateLink::Organization, params)
    end

    def financetransactions(params = {})
      # Default to only showing transactions in the past seven days
      seven_days = 7 * 24 * 60 * 60
      params[:startdate] ||= (Time.now.to_i - seven_days)
      params[:startdate] = params[:startdate].to_i * 1000

      request('financetransactions', CollegiateLink::FinanceTransaction, params)
    end

    ##
    # Return a complete list of CollegiateLink::Event instances for your
    # institution.
    #
    # ==== Required Parameters:
    # * <tt>:startdate</tt> - Time instance or the Unix integral timestamp for the beginning of results.
    # * <tt>:enddate</tt> - Time instance or the Unix integral timestamp for the end of results.
    #
    # ==== Optional Parameters:
    # See CollegiateLink::Request#initialize for a list of additional parameters
    # that requests can use.
    def events(params = {})
      # Default to showing events in the past 7 days
      seven_days = 7 * 24 * 60 * 60
      params[:startdate] ||= (Time.now.to_i - seven_days)
      params[:enddate]   ||= (Time.now.to_i)

      # Convert to milliseconds...
      params[:startdate] = params[:startdate].to_i * 1000
      params[:enddate]   = params[:enddate].to_i * 1000

      request('events', CollegiateLink::Event, params)
    end

    def roster(id, params = {})
      params.merge!(:organizationId => id)

      request('memberships', CollegiateLink::Member, params)
    end

    private

    def request(action, model, params = {})
      cl_request = CollegiateLink::Request.new(action, params.merge(@params), @opts)
      cl_resp = cl_request.perform

      all_items = cl_resp.items.map { |i| model.parse(i) }

      while cl_resp.has_next_page?
        cl_request = cl_request.request_for_next_page
        cl_resp = cl_request.perform
        all_items += cl_resp.items.map { |i| model.parse(i) }
      end

      all_items
    end
  end
end
