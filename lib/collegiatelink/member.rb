module CollegiateLink

  ##
  # A Member record returned by CollegiateLink
  #
  class Member < OpenStruct
    include Representable::JSON

    property :membershipId
    property :organizationId
    property :organizationName
    property :organizationShortName
    property :positionTemplate
    property :positionTypeName
    property :positionId
    property :positionName
    property :userId
    property :username
    property :userFirstName
    property :userLastName
    property :userCampusEmail
    property :preferredemail
    property :positionRecordedStartDate
    property :positionRecordedEndDate
    property :positionReportedStartDate
    property :positionReportedEndDate

    def id
      membershipId
    end

    def current?
      if (use_startdate = positionReportedStartDate.to_i) == 0
        use_startdate = positionRecordedStartDate.to_i
      end
      if (use_enddate = positionReportedEndDate.to_i) == 0
        use_enddate = positionRecordedEndDate.to_i
      end

      indefinite = (positionReportedEndDate.to_i <= 0) && (positionRecordedEndDate.to_i <= 0)

      starts = Time.at(use_startdate / 1000, use_startdate % 1000)

      if indefinite
        return (starts < Time.now)
      else
        ends = Time.at(use_enddate / 1000, use_enddate % 1000)
        return (starts < Time.now && Time.now < ends)
      end
    end

    def self.parse(json)
      new(json)
    end
  end
end
