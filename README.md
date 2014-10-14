# Rsbe::Client

Client library for interaction with the rsbe API

## Current Status

### *UNDER DEVELOPMENT*

## Description

This library allows one to interact with the R* Backend (rsbe) API.

#### User stories:
* As an Authorized Client, I want to create a new Partner and have it persist.
* As an Authorized Client, I want to update a Partner.
* As an Authorized Client, I want to get a list of Partners.
* As an Authorized Client, I want to list the Colls for a Partner.

* As an Authorized Client, I want to create a new Coll and have it persist.


* As an Authorized Client, I want to create a new FMD.
* As an Authorized Client, I want to use a checksum to find a list of all  
  matching files with that same checksum.
* As an Authorized Client, I want to update the last ping datetime of an FMD.
* As an Authorized Client, I want to add a checksum value to an FMD.
* As an Authorized Client, I want to update the last fixity check datetime
  of an FMD.
* As an Authorized Client, I want to update the path of an FMD.
* As an Authorized Client, I want to find the id of an Fmd given its path.


#### Required Environment Variables:
```
RSBE_URL
RSBE_USER
RSBE_PASSWORD
```

#### Methods:
```
Rsbe::Partner.new(params = {})
Rsbe::Partner.find(uuid)
Rsbe::Partner.find_by_code(code)
Rsbe::Partner.where(condition)
```

```
Rsbe::Partner#valid?
Rsbe::Partner#save
Rsbe::Partner#code
Rsbe::Partner#long_name
Rsbe::Partner#collections
```


## Usage

```ruby
p = Rsbe::Client::Partner.new(attrs)
p.save                                      # => true or false
```

```ruby
p = Rsbe::Client::Partner.find_by_code(code)
p.name = "Lorem Ipsum"
p.save
c = p.collections.new(attrs)
c.quota = 9999
c.ready_for_content = true
unless c.save
  puts c.errors
end
```

