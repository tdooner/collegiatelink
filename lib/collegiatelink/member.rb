module CollegiateLink
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
      use_startdate = (userstartdate.to_i > 0) ? userstartdate.to_i : startdate.to_i
      indefinite = (userenddate.to_i < 0) && (enddate.to_i < 0)

      starts = Time.at(use_startdate / 1000, use_startdate % 1000)

      if indefinite
        return (starts < Time.now)
      else
        use_enddate = (userenddate.to_i > 0) ? userenddate.to_i : enddate.to_i
        ends = Time.at(use_enddate / 1000, use_enddate % 1000)
        return (starts < Time.now && Time.now < ends)
      end
    end
  end

  module PositionRepresenter
    include Representable::XML

    property :name
    property :enddate
    property :startdate
    property :userstartdate
    property :userenddate
  end

  class PositionList < OpenStruct
    include Representable::XML

    collection :positions, :extend => PositionRepresenter, :class => Position, :as => :position
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
    property :positionList, :class => PositionList, :as => :positions

    def positions
      positionList.positions
    end

    def active_positions
      positions.keep_if { |p| p.current? }
    end

    def self.parse(xml)
      from_xml(xml.to_s)
    end
  end
end
