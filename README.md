# Rindle: A Gem packaging multiple kindle tools

Rindle is a package of useful classes to manage the kindles content.
In mature versions it should provide an object-oriented interface to access the collections and documents on the kindle with all their metadata.

## Libraries for kindle access

First load the kindle:

    Kindle.load('/path/to/root')

Then just use `Kindle::Collection` or `Kindle::File` with an
ActiveRecord like interface:

    Kindle::Collection.first(:named => 'Test Collection')
    Kindle::Collection.all(:named => /(.*)[1|2]$/)

## KindleFS

Mount the kindle the way it should have been from the start. Access and manage your kindles content via filesystem. With any file browse you'd like to use.

Simply call the kindlefs command:

    kindlefs kindle_root mount_point

## *.mobi libraries

Libs to create and edit mobi files.

    book = Rindle::Mobi.new :title => 'My book'

Rindle::Mobi::Dir

## MobiFS

### Modifing Files

You can mount a mobi file or a folder. Each document is mapped to a
directory with the same name containing the data packed and a
preview.html which gets generated when read from data.

### Auto Conversion

Copy a PDF, an RTF, a DOC or an EPUB file into the mounted folder and
it gets converted automatically. You can configure the conversion
parameters in the conversion.yml in the mounted folder.
