Gem::Specification.new do |s|
  s.name = 'CollegiateLink'
  s.version = '0.0.2'
  s.date = '2012-11-13'
  s.summary = 'CollegiateLink Client Gem'
  s.authors = ['Tom Dooner']
  s.email = 'ted27@case.edu'
  s.files = [
    'lib/collegiatelink.rb',
    'lib/collegiatelink/request.rb',
    'lib/collegiatelink/response.rb',
    'lib/collegiatelink/client.rb',
    'lib/collegiatelink/organization.rb',
  ]
  s.add_dependency 'guid'
  s.add_dependency 'nokogiri'
  s.add_dependency 'happymapper'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'net-ssh'
end
