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
end
