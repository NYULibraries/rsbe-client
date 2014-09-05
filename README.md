# Rsbe::Client

Client library for interaction with the rsbe API

## Current Status

### *UNDER DEVELOPMENT*

## Description

This library allows one to interact with the R* Backend (rsbe) API.

User stories:
As an Authorized Client, I want to create a new Partner and have it persist.
As an Authorized Client, I want to use rsbe-client to get a list of Partners.
As an Authorized Client, I want to list the Collections for a Partner.
As an Authorized Client, I want to create a new Collection and have it persist.
As an Authorized Client, I want to create a new FMD.
As an Authorized Client, I want to use a checksum to find a list of all 
                         matching files with that same Checksum.
As an Authorized Client, I want to update the last ping datetime of an FMD.
As an Authorized Client, I want to add a checksum value to an FMD.
As an Authorized Client, I want to update the last fixity check datetime 
                         of an FMD.
As an Authorized Client, I want to update the path of an FMD.
As an Authorized Client, I want to find the id of an Fmd given its path.



Required Environment Variables:
```RSBE_URL
RSBE_HTTP_USER
RSBE_HTTP_PASSWORD```

Methods:
```
Rsbe::Partner.new([hash])
Rsbe::Partner.find(uuid)
Rsbe::Partner.where(condition)
Rsbe::Partner#valid?
Rsbe::Partner#save
Rsbe::Partner#code
Rsbe::Partner#long_name
Rsbe::Partner#collections
```


## Usage

TODO: coming soon


## Contributing

1. Fork it ( http://github.com/<my-github-username>/rsbe-client/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
