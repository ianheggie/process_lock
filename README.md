# ProcessLock

A simple class to acquire and check process-id file based locks on a unix filesystem.
Can also be used to see if a process is already running or designate a master process when running concurrent applications.

[![Build Status](https://travis-ci.org/ianheggie/process_lock.png?branch=master)](https://travis-ci.org/ianheggie/process_lock)

## Installation

Add this line to your application's Gemfile:

    gem 'process_lock'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install process_lock

## Usage

Create an instance of ProcessLock with a filename as the lock.
You may have more than one lock (with different names) per process.

Methods:
* acquire - Acquires a lock if it can. Returns true (or value of block if block is passed) if a lock was acquired, otherwise false.
* acquire! - Same as acquire except it throws an exception if a lock could not be obtained.
* release - Releases the lock if we are the owner. Returns true if the lock was released.
* release! - Same as release except it throws an exception if a lock was not released.
* filename - the filename passed when the instance was created
* read - the process id in the lock file, otherwise 0 (zero)

Note:
* locks don't stack - if we have already acquired the lock subsequent calls will reacquire the lock. releasing an already released lock will fail.
* If Rails.root is defined then lock files without path separators (/) will be put in tmp/pids. If no extension is specified then .pid will be appended.

To acquire a lock, do some work and then release it:

    pl = ProcessLock.new('tmp/name_of_lock.lock')

    acquired = pl.acquire do
      puts "Do some work!"
    end
    puts "Unable to obtain a lock" unless acquired

    # OR

    while ! pl.acquire
      puts "Trying to acquire a lock"
      sleep(1)
    end
    puts "Do some work!"
    pl.release

To allow many worker processes to self organise and identify a leader process. (Simon and my implementation have diverged).

    IRB 1>>
    pl = ProcessLock.new('example.tmp')
    pl.acquire
    => true
    pl.read
    => "2435"

    IRB 2>>
    pl = ProcessLock.new('example.tmp')
    pl.acquire
    => false
    pl.read
    => "2435"

example.tmp will contain the pid of the leader process

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request (Tests appreciated)

## License and contributions

* Copyright (c) 2008 Simon Engledew, released under the MIT license: https://github.com/simon-engledew/ruby-process-lock .
* Subsequent work by Ian Heggie: enhanced library and packaged into a gem, added tests and acquire method, fixed some bugs.
* See git log for other contributers

