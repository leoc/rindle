# Rindle: A Gem packaging multiple kindle tools

Rindle is a package of useful classes to manage the kindles content.
In mature versions it should provide an object-oriented interface to
access the collections and documents on the kindle with all their
metadata. And it should provide a convenient way for converting
various eBook formats.

## Libraries for kindle access

First load the kindle:

    Rindle::Kindle.load '/path/to/root'

Then just use `Kindle::Collection` or `Kindle::File` with an
ActiveRecord like interface:

    Rindle::Collection.first named: 'Test Collection'
    Rindle::Collection.all named: /(.*)[1|2]$/