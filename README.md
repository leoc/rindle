# Rindle - Kindle Collections Management in Ruby

Rindle is a package of useful classes to manage the kindles content.
In mature versions it should provide an object-oriented interface to
access the collections and documents on the kindle with all their
metadata.

## Installation

Add this line to your application's Gemfile:

    gem 'rindle'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rindle

## Usage

First load the kindle:

    Rindle.load '/path/to/root'

Then just use `Rindle::Collection` or `Rindle::Document` with an
ActiveRecord like interface:

    Rindle::Collection.first named: 'Test Collection'
    collections = Rindle::Collection.all named: /(.*)[1|2]$/
    Rindle::Document.find_by_name 'A book.pdf'
    documents = Rindle::Document.all

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request