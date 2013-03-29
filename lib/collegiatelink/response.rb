module CollegiateLink
  module Response
    module Common
      # Utility method to determine if the request has another page to retrieve.
      def has_next_page?
        @page_number < @total_pages
      end
    end

    ##
    # Container for the XML gunk returned from CollegiateLink
    #
    class XML
      include CollegiateLink::Response::Common

      # Create the response.
      #
      # ==== Parameters:
      # * +document+ - The Nokogiri document of the returned XML
      def initialize(document)
        raise UnknownException unless document.xpath('//results/page')

        @document = document
        @page_size   = document.xpath('//results/page/pageSize').inner_html.to_i
        @page_number = document.xpath('//results/page/pageNumber').inner_html.to_i
        @total_items = document.xpath('//results/page/totalItems').inner_html.to_i
        @total_pages = document.xpath('//results/page/totalPages').inner_html.to_i
      end

      # Extract the items from the response. Returns a Nokogiri NodeSet.
      def items
        @document.xpath('//results/page/items/*')
      end
    end

    class JSON
      include CollegiateLink::Response::Common

      def initialize(document)
        raise UnknownException unless document["items"]

        @document = document
        @page_size   = document["pageSize"]
        @page_number = document["pageNumber"]
        @total_items = document["totalItems"]
        @total_pages = document["totalPages"]
      end

      def items
        @document["items"]
      end
    end
  end
end
