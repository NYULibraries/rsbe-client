## `Rsbe::Client::SearchResults` examples:

#### overview

The `Rsbe::Client::SearchResults` class takes the results of an  
`Rsbe::Client::Search` call, parses the results, and returns an  
array of `Rsbe::Client::Se` objects.  

You can use `Se` attribute values as search filters.


##### Example: search by `digi_id`  

The most common example is to retrieve the `Rsbe::Client::Se` object  
for a digitization id (`digi_id`) registered in `Rsbe`.

```
irb> require 'rsbe/client'
irb> response = Rsbe::Client::Se.search(digi_id: 'foo_quux_cuid0')
 => #<Faraday::Response:0x007fdc819cd050 ...>

irb> search_results = Rsbe::Client::SearchResults.new(response)
 => #<Rsbe::Client::SearchResults:0x007fdc81943ee0 ...>

irb> search_results.success?
 => true

irb> search_results.num_found
 => 1

irb> se = search_results.results.first
 => #<Rsbe::Client::Se:0x007fdc819ffbb8 ...>

irb> se.id
 => "2edf966a-cde3-48e1-a04e-9c87af07b9b5"

irb> se.digi_id
 => "foo_quux_cuid0"

irb> se.phase
 => "digitization"

irb> se.step
 => "digitization"

irb> se.status
 => "queued"

irb> se.status = 'error'
 => "error"

irb> se.save
 => true

```


##### Example: search for all `Se`s currently in the digitization queue:

```
irb> require 'rsbe/client'
irb> response = Rsbe::Client::Se.search(phase: 'digitization',
                                        step:  'digitization',
                                        status: 'queued')
 => #<Faraday::Response:0x007fdc81b257b8 ...>

irb> search_results = Rsbe::Client::SearchResults.new(response)
 => #<Rsbe::Client::SearchResults:0x007fdc81b15660 ...>

irb> search_results.success?
 => true

# NOTE:
# this is fast because it just returns the num_found value
#   from the Search response  
#  
irb> search_results.num_found
 => 920

# NOTE:
# this operation may be slow. Calling Rsbe::Client::SearchResults#results
#   instantiates an Se object for every record returned by the search.  
#   Subsequent invocations of #results will be fast, however, because the
#   Se objects are memoized.
#
irb> search_results.results[0..10].each {|se| puts "#{se.digi_id}"}
foo_quux_cuid0
foo_quux_cuid01234
foo_quux_cuid1
foo_quux_cuid10
foo_quux_cuid100
foo_quux_cuid101
foo_quux_cuid102
foo_quux_cuid103
foo_quux_cuid104
foo_quux_cuid105
foo_quux_cuid106

```
