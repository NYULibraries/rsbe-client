# Rsbe::Client

Client library for interaction with the rsbe API

## Current Status

### *UNDER DEVELOPMENT*

## Description

This library allows one to interact with the R* Backend (rsbe) API.

#### Required Environment Variables:
```
RSBE_URL
RSBE_USER
RSBE_PASSWORD
```

e.g.,
```
export RSBE_URL='https://rsbe.example.com'
export RSBE_USER='foo'
export RSBE_PASSWORD='bar'
```

#### Usage (irb example from project root)
```
$ irb -I lib
irb> require 'rsbe/client'
 => true 
irb> include Rsbe::Client
 => Object

irb> Partner.all.each {|p| puts p.id}
51213be7-c8de-4e06-8cc2-06bfc82cdd68
977e659b-886a-4626-8799-8979426ad2b3
...
...

irb> p = Rsbe::Client::Partner.all.first
 => #<Rsbe::Client::Partner:0x007fdc81b4ec08 ...>

irb> puts "#{p.id} : #{p.code} : #{p.name}"
51213be7-c8de-4e06-8cc2-06bfc82cdd68 : bar :
 => nil 

irb> p.name = 'Foo Bar'
 => "Foo Bar"

irb> p.save
 => true 

> p = Rsbe::Client::Partner.find('51213be7-c8de-4e06-8cc2-06bfc82cdd68')
 => #<Rsbe::Client::Partner:0x007fdc81a3cdd8 ...>

irb>   puts "#{p.id} : #{p.code} : #{p.name}"
51213be7-c8de-4e06-8cc2-06bfc82cdd68 : bar : Foo Bar
 => nil 

```


