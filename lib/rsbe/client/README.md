## Rsbe::Client Usage

Rsbe::Client::Partner.all
Rsbe::Client::Partner.find
Rsbe::Client::Partner.new(attrs = {})
Rsbe::Client::Partner#to_s
Rsbe::Client::Partner#to_h
Rsbe::Client::Partner#to_json
Rsbe::Client::Partner#<attr>=
Rsbe::Client::Partner#<attr>
Rsbe::Client::Partner#save
Rsbe::Client::Partner#errors -> {...}


Flow:
-----
Partner.all
-> get a connection
-> query the API
-> convert results into an array of resources

Partner.find(id)
-> get a connection
-> query the API
-> convert result into a resource

