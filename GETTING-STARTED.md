## Getting Started

The following instructions assume that you have [`RVM` installed](https://rvm.io/rvm/install).

```
git clone git@github.com:NYULibraries/rsbe-client.git
cd rsbe-client
rvm install 2.3
rvm use 2.3
rvm --ruby-version gemset use rsbe-client --create
gem install bundler
bundle
rake
```


 