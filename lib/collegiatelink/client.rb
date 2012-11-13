module CollegiateLink
  class Client
    def initialize(apikey, ip, sharedkey)
      @params = {
        apikey: apikey,
        ip:     ip
      }
      @opts = {
        sharedkey: sharedkey
      }
    end

    def organizations
      orgs = request('organization/list')
      orgs.map{ |o| CollegiateLink::Organization.parse(o.to_s) }
    end

    def events(params = {})
      params[:startdate] ||= (Time.now.to_i - 7 * 24 * 60 * 60) * 1000
      params[:enddate]   ||= (Time.now.to_i) * 1000

      events = request('event/list', params)
      events.map{ |o| CollegiateLink::Event.parse(o.to_s) }
    end

    private

    def request(action, params = {})
      cl_request = CollegiateLink::Request.new(action, params.merge(@params), @opts)
      cl_resp = cl_request.perform

      all_items = cl_resp.items

      while cl_resp.has_next_page?
        cl_resp = cl_request.request_for_next_page.perform
        all_items += cl_resp.items
      end

      all_items
    end
  end
end
