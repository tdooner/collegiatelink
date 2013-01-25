module CollegiateLink
  ##
  # Address object returned by CollegiateLink as part of an Organization or
  # Event record.
  #
  # ==== Properties:
  # * <tt>:city      </tt> - String
  # * <tt>:country   </tt> - String
  # * <tt>:postalcode</tt> - String
  # * <tt>:state     </tt> - String
  # * <tt>:street1   </tt> - String
  # * <tt>:street2   </tt> - String
  # * <tt>:type      </tt> - Integer
  class Address
    include HappyMapper

    element :city, String
    element :country, String
    element :postalcode, String
    element :state, String
    element :street1, String
    element :street2, String
    element :type, Integer
  end

  ##
  # Category object returned by CollegiateLink as part of an Organization record
  # See: # http://support.collegiatelink.net/entries/332558-web-services-developer-documentation#orgList
  #
  # ==== Properties:
  # * <tt>:id      </tt> - Integer
  # * <tt>:ishidden</tt> - String
  # * <tt>:name    </tt> - String
  class Category
    include HappyMapper

    element :id, Integer
    element :ishidden, String
    element :name, String
  end

  ##
  # An Organization record returned by CollegiateLink
  # See: http://support.collegiatelink.net/entries/332558-web-services-developer-documentation#orgList
  #
  # ==== Properties:
  # * <tt>:id      </tt> - Integer
  # * <tt>:parentId</tt> - Integer
  # * <tt>:name    </tt> - String
  # * <tt>:description   </tt> - String
  # * <tt>:shortName  </tt> - String
  # * <tt>:siteUrl  </tt> - String
  # * <tt>:status  </tt> - String
  # * <tt>:type  </tt> - String
  # * <tt>:addresses  </tt> - Array of CollegiateLink::Address
  # * <tt>:categories  </tt> - Array of CollegiateLink::Category
  class Organization
    include HappyMapper

    element :id, Integer
    element :parentId, Integer
    element :name, String
    element :description, String
    element :shortName, String
    element :siteUrl, String
    element :status, String
    element :type, String
    has_many :addresses, Address
    has_many :categories, Category
  end

  ##
  # An Event record returned by CollegiateLink
  # See: http://support.collegiatelink.net/entries/332558-web-services-developer-documentation#eventList
  #
  # ==== Properties:
  # * <tt>:id         </tt> - Integer
  # * <tt>:name       </tt> - String
  # * <tt>:description</tt> - String
  # * <tt>:startDate  </tt> - Integer
  # * <tt>:endDate    </tt> - Integer
  # * <tt>:location   </tt> - String
  # * <tt>:status     </tt> - String
  # * <tt>:urlLarge   </tt> - String
  # * <tt>:urlSmall   </tt> - String
  # * <tt>:organization</tt> - The hosting Organization
  #
  class Event
    include HappyMapper

    element :id, Integer
    element :name, String
    element :description, String
    element :startDate, Integer
    element :endDate, Integer
    element :location, String
    element :status, String
    element :urlLarge, String
    element :urlSmall, String

    has_one :organization, Organization
  end
end
