module CollegiateLink
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

  class Category
    include HappyMapper

    element :id, Integer
    element :ishidden, String
    element :name, String
  end

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
