Gem::Specification.new do |s|
  s.name = 'collegiatelink'
  s.version = '0.1.0'
  s.date = '2012-03-28'
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
  s.add_dependency 'representable'
  s.add_dependency 'socksify'
  s.add_development_dependency 'rspec'
  s.add_dependency 'net-ssh'
end
