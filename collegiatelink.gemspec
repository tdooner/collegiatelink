Gem::Specification.new do |s|
  s.name = 'collegiatelink'
  s.version = '0.3.0'
  s.date = '2014-02-02'
  s.summary = 'CollegiateLink Client Gem'
  s.authors = ['Tom Dooner']
  s.email = 'tomdooner@gmail.com'
  s.files = [
    'lib/collegiatelink.rb',
    'lib/collegiatelink/request.rb',
    'lib/collegiatelink/response.rb',
    'lib/collegiatelink/client.rb',
    'lib/collegiatelink/organization.rb',
    'lib/collegiatelink/member.rb',
  ]
  s.add_dependency 'guid'
  s.add_dependency 'nokogiri'
  s.add_dependency 'representable'
  s.add_dependency 'socksify'
  s.add_development_dependency 'rspec'
  s.add_dependency 'net-ssh'
end
