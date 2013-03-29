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
  class Address < OpenStruct
    include Representable::XML

    property :city
    property :country
    property :postalcode
    property :state
    property :street1
    property :street2
    property :type
  end

  ##
  # Category object returned by CollegiateLink as part of an Organization record
  # See: # http://support.collegiatelink.net/entries/332558-web-services-developer-documentation#orgList
  #
  # ==== Properties:
  # * <tt>:id      </tt> - Integer
  # * <tt>:ishidden</tt> - String
  # * <tt>:name    </tt> - String
  class Category < OpenStruct
    include Representable::XML

    property :id
    property :ishidden
    property :name
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
  class Organization < OpenStruct
    include Representable::XML

    property :id
    property :parentId
    property :name
    property :description
    property :shortName
    property :siteUrl
    property :status
    property :type
    collection :addresses
    collection :categories

    def self.parse(xml)
      from_xml(xml.to_s)
    end
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
  class Event < OpenStruct
    include Representable::XML

    property :id
    property :name
    property :description
    property :startDate
    property :endDate
    property :location
    property :status
    property :urlLarge
    property :urlSmall

    def self.parse(xml)
      from_xml(xml.to_s)
    end
  end

  class FinanceTransaction < OpenStruct
    include Representable::JSON

    property :transactionId
    property :transactionNumber
    property :requestId
    property :requestNumber
    property :transactionType
    property :financeTypeId
    property :financeTypeName
    property :financeCategoryId
    property :financeCategoryName
    property :accountId
    property :accountName
    property :originatingAccountId
    property :originatingAccountName
    property :originatingOrganizationId
    property :originiatingOrganizationName
    property :requestPayeeFirstName
    property :requestPayeeLastName
    property :payeeSourceFirstName
    property :payeeSourceLastName
    property :transactionDate # todo, make this usable as a date ("1363891642000")
    property :amount
    property :endingAllocationAfter
    property :endingAvailableAfter
    property :memo
    property :reconciledStatus
    property :cancelledStatus

    def self.parse(hash)
      new(hash)
    end
  end

  ##
  # A position of someone in an organization
  #
  class Position < OpenStruct
    include Representable::XML

    property :name
    property :enddate
    property :startdate
    property :userstartdate
    property :userenddate

    def current?
      use_startdate = (userstartdate > 0) ? userstartdate : startdate
      indefinite = (userenddate < 0) && (enddate < 0)

      starts = Time.at(use_startdate / 1000, use_startdate % 1000)

      if indefinite
        return (starts < Time.now)
      else
        use_enddate = (userenddate > 0) ? userenddate : enddate
        ends = Time.at(use_enddate / 1000, use_enddate % 1000)
        return (starts < Time.now && Time.now < ends)
      end
    end
  end

  ##
  # A Member record returned by CollegiateLink
  #
  class Member < OpenStruct
    include Representable::XML

    #property :affiliation   # Not sure the format of this...
    property :campusemail
    property :firstname
    property :id
    property :lastname
    property :preferredemail
    property :username

    collection :positions, :class => CollegiateLink::Position

    def active_positions
      positions.keep_if { |p| p.current? }
    end
  end
end
