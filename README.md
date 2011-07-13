clouddns
========

A DSL for managing your DNS on cloud services through [fog](http://fog.io/).

Clouddns allows a convenient way to manage DNS on Amazon Route 53, bluebox, DNSimple, DNS Made Easy, Linode DNS, Slicehost DNS or Zerigo DNS.
DNS records are described by configuration files in ruby, which are in a readable commentable format.
This also allows keeping your DNS configuration in version control.
Since DNS records are described in ruby, they can be defined programmatically, allowing DNS records to be made from database entries or other sources like a [chef server](http://www.opscode.com/chef/).

Installation
============

    gem install clouddns

Usage
=====

To change your DNS to that in the config file run

    clouddns migrate dns.rb

Where dns.rb is a file in the following format

Configuration file
==================

The configuration files used by clouddns are written in ruby and specify zones at the top level, and records within.

*Zones* group all records within a domain (usually, second-level or third-level).
Within these zones, records are declared in the format `TYPE 'FULL.DOMAIN.NAME' 'VALUE'`

Example configuration
---------------------

    provider 'AWS'

    defaults :ttl => 600

    zone 'example.com.' do
    	A 'example.com.', '1.2.3.4'
    	CNAME 'www.example.com.', 'example.com.'

    	A 'mail.example.com.', '4.3.2.1'
    	MX 'www.example.com.', '10 mail.exmaple.com.', :ttl => 300
    end
    
    zone 'example.net.' do
    	A 'www.example.net.', '1.2.3.4'
    end

Zone
----

Defines a zone. Takes one argument, the fully qualified domain name, and a block, which declares the records associated with the zone.
Domain names can end with a dot, if missing, is is implied.

Records
-------

Records must be defined within a zone.
They are defined by calling the helper method for their type (A, CNAME, etc) with their FQDN, value, and any options.
If the domain name is missing the trailing dot, it is implied.

Value can be an array to specify multiple entries for that record (like in the case of Round-robin DNS, or multiple MX records).

Options is currently only :ttl, which is specified in seconds. :ttl defaults to 3600, which can be changed using the defaults directive.

Provider (optional)
-------------------

Credentials are required to access whichever service is desired through dns.
This can be specified in full in the config file

    provider 'AWS',
             :aws_secret_access_key => YOUR_SECRET_ACCESS_KEY,
             :aws_access_key_id     => YOUR_SECRET_ACCESS_KEY_ID

Alternatively, to avoid specifying access keys or access key in the file (A good idea if it's to enter version control),
fog will read credentials from `~/.fog` or the file specified in `ENV["FOG_RC"]`.
One can then specify the provider by itself in the config file (like `provider 'AWS'`) or using the `-p PROVIDER` option of the clouddns executable.

Defaults
--------

Defaults specified options which will be used by any zones or records defined in the file.
Currently, this can only be used to specify :ttl.


Copyright
=========

(The MIT License)

Copyright (c) 2011 [John Hawthorn](http://www.johnhawthorn.com/)

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION

