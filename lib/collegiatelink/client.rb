module CollegiateLink

  # The Client is what makes the requests to CollegiateLink.
  class Client
    ##
    # Creates a CollegiateLink client.
    #
    # ==== Parameters:
    # * +apikey+ - The CollegiateLink "apikey" for your institution. For example, at Case Western Reserve University we go to http://casewestern.collegiatelink.net, so our "apikey" is "casewestern"
    # * +ip+ - The IP address that the +sharedkey+ is approved for.
    # * +sharedkey+ - The shared key granted by CollegiateLink to your IP and institution.
    #
    def initialize(apikey, ip, sharedkey)
      @params = {
        apikey: apikey,
        ip:     ip,
      }
      @opts = {
        sharedkey: sharedkey,
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
      orgs = request('organization/list', CollegiateLink::Organization, params)
    end

    def financetransactions(params = {})
      # Default to only showing transactions in the past seven days
      seven_days = 7 * 24 * 60 * 60
      params[:startdate] ||= (Time.now.to_i - seven_days)
      params[:startdate] = params[:startdate].to_i * 1000

      transactions = request('financetransactions', CollegiateLink::FinanceTransaction, params)
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

      events = request('event/list', CollegiateLink::Event, params)
    end

    def roster(id, params = {})
      params.merge!(:id => id)

      members = request('organization/roster', CollegiateLink::Member, params)
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
