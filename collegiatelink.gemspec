Gem::Specification.new do |s|
  s.name = 'collegiatelink'
  s.version = '0.0.5'
  s.date = '2012-02-19'
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
  s.add_dependency 'socksify'
  s.add_development_dependency 'rspec'
  s.add_dependency 'net-ssh'
end
