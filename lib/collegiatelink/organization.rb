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
  class Organization < OpenStruct
    include Representable::JSON

    property :organizationId
    property :name
    property :status
    property :shortName
    property :summary
    property :description
    property :addressStreet1
    property :addressStreet2
    property :addressCity
    property :addressStateProvince
    property :addressZipPostal
    property :phoneNumber
    property :email
    property :externalWebsite
    property :facebookUrl
    property :twitterUrl
    property :profileUrl
    property :typeId
    property :typeName
    property :parentId

    def self.parse(json)
      new(json)
    end
  end

  ##
  # An Event record returned by CollegiateLink
  # See: http://support.collegiatelink.net/entries/332558-web-services-developer-documentation#eventList
  #
  class Event < OpenStruct
    include Representable::JSON

    property :eventId
    property :eventName
    property :organizationId
    property :organizationName
    property :startDateTime
    property :endDateTime
    property :externalLocationId
    property :locationId
    property :otherLocation
    # properties for address here...
    property :description
    property :flyerUrl
    property :thumbnailUrl
    property :typeId
    property :typeName
    property :status

    def self.parse(json)
      new(json)
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
end
