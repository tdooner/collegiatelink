module CollegiateLink
  ##
  # Container for the XML gunk returned from CollegiateLink
  #
  class Response
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

    # Utility method to determine if the request has another page to retrieve.
    def has_next_page?
      @page_number < @total_pages
    end
  end
end
