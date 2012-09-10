module CollegiateLink
  class Response
    def initialize(document)
      raise UnknownException unless document.xpath('//results/page')

      @document = document
      @page_size   = document.xpath('//results/page/pageSize').inner_html.to_i
      @page_number = document.xpath('//results/page/pageNumber').inner_html.to_i
      @total_items = document.xpath('//results/page/totalItems').inner_html.to_i
      @total_pages = document.xpath('//results/page/totalPages').inner_html.to_i
    end

    def items
      @document.xpath('//results/page/items/*')
    end

    def has_next_page?
      @page_number < @total_pages
    end
  end
end
