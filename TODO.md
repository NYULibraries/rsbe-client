## TODO
[ ] consider creating request and response classes that handle 404, 201, 200, etc.
[ ] consider base class with get/put/post/delete methods that can be overridden, or better yet, create a "Connection" class
    which would be useful for class-level operations as well.  Then objects would have a @conn instance variable.

#### Pending User stories:
* As an Authorized Client, I want to find a Partner by code.
* As an Authorized Client, I want to list the Colls for a Partner.

* As an Authorized Client, I want to create a new Coll and have it persist.

* As an Authorized Client, I want to create a new FMD.
* As an Authorized Client, I want to use a checksum to find a list of all matching files with that same checksum.
* As an Authorized Client, I want to update the last ping datetime of an FMD.
* As an Authorized Client, I want to add a checksum value to an FMD.
* As an Authorized Client, I want to update the last fixity check datetime of an FMD.
* As an Authorized Client, I want to update the path of an FMD.
* As an Authorized Client, I want to find the id of an Fmd given its path.


#### Possible Usage
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

