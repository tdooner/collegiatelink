Gem::Specification.new do |s|
  s.name = 'CollegiateLink Client'
  s.version = '0.0.0'
  s.date = '2012-08-23'
  s.summary = 'CollegiateLink Client Gem'
  s.authors = ['Tom Dooner']
  s.email = 'ted27@case.edu'
  s.files = ['lib/collegiatelink.rb']
  s.add_dependency 'guid'
  s.add_dependency 'nokogiri'
  s.add_dependency 'happymapper'
  s.add_development_dependency 'rspec'
end
