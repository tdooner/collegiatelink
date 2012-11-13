CollegiateLink client
========================================

This is a very-under-development client for CollegiateLink's [API][1].

Built for CWRU's Undergraduate Student Government by [Tom
Dooner](mailto:tom.dooner@case.edu).


Usage
----------------------------------------
A couple ways you can use this:

  school = CollegiateLink::Client.new(school name, ip addr, api key)
  school.organizations
  school.events

Look in `lib/collegiatelink/client.rb` for more information.


Gem Development
----------------------------------------
To work on this gem, you'll need to jump through some hoops. CollegiateLink
doesn't have a page to request Shared Keys, so you have to submit a support
ticket.

The ticket you will receive is valid for one hard-coded IP address, so you'll
probably need to SSH tunnel into your production machine when doing local
development.

Since this script makes HTTP requests that you want to originate from the other
end of the SSH tunnel, use [SOCKSify][2] to forward all the script's traffic
through it. For instance, if you run `ssh -D localhost:8080 [server]` then
SOCKSify should be run as `socksify_ruby localhost 8080 [your script]`

### Building The Gem
To build the gem, run `gem build collegiatelink.gemspec`

[1]: http://support.collegiatelink.net/entries/332558-web-services-developer-documentation
[2]: http://socksify.rubyforge.org/
