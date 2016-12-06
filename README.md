# Rsbe::Client

Client library for interaction with the rsbe API

## Current Status

### *UNDER DEVELOPMENT*

## Description

This library allows one to interact with the R* Backend (rsbe) API.

#### Completed User stories:
* As an Authorized Client, I want to create a new Partner and have it persist.
* As an Authorized Client, I want to update a Partner.
* As an Authorized Client, I want to find a Partner by id.
* As an Authorized Client, I want to get a list of all available Partners.


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

irb> p = Partner.new
...
irb> p.code = 'quux'
 => "quux"
irb> p.name = 'Quasi-interesting Ferrets!'
 => "Quasi-interesting Ferrets!"
irb> p.rel_path = 'a/b/c'
 => "a/b/c"
irb> p.save
 => true
```

#### Usage (code example)
```
...
def select_item_or_exit(items, label)
  print_menu_header(label)
  print_items(items)
  print_menu_footer(label)
  idx = selection_index_from_user
  err_exit("invalid selection...\nGoodbye...") if idx < 0 || idx > items.length
  ok_exit('Goodbye...') if idx == 0
  items[idx - 1]
end
#------------------------------------------------------------------------------
# MAIN ROUTINE
#------------------------------------------------------------------------------
print_header
err_exit('NEED AT LEAST 1 DIRECTORY') if ARGV.length < 1
partners = Rsbe::Client::Partner.all
partners.sort! { |a, b| a.code <=> b.code }
partner = select_item_or_exit(partners, 'partner')
collections = partner.collections.sort { |a, b| a.code <=> b.code }
collection = select_item_or_exit(collections, 'collection')
puts "collection: #{collection.code}, #{collection.name} #{collection.id}"
...
```


```
#### Methods:
```
Rsbe::Partner.new(params = {})
```

```
Rsbe::Partner#save
Rsbe::Partner#code
Rsbe::Partner#name
Rsbe::Partner#collections
```

