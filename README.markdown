pianoman
--------

Redis .rdb dump file analyzer in C

Functionality
-------------

Currently, pianoman runs the same dump-check that Redis does, plus basic stats
on key type breakdowns.  You can also pass pianoman up to 25 "matchers," strings
which are meant to match against the beginning of your redis keys.  For example
if your namespaces are broken down by "api," "app," "sessions," etc., you can
run stats against each of these prefixes.  A trivial example is below.

Here's a tiny redis database:

    redis 127.0.0.1:6379> keys *
    1) "wutangclan"
    2) "wu"
    3) "rza"
    4) "odb"
    5) "clan"
    6) "tang"

Here's the current output, with some matchers:

    > ./pm ~/Projects/redis/dump.rdb wu cla rz

    ==== Processed 8 valid opcodes (in 143 bytes) ==================================

    Key Space:

    Strings: 2 (33.33%)
    Lists: 1 (16.67%)
    Sets: 1 (16.67%)
    Zsets: 1 (16.67%)
    Hashes: 1 (16.67%)

    Match Stats:

    0) wu 2.00 (33.33%)
    1) cla 1.00 (16.67%)
    2) rz 1.00 (16.67%)

    Total Keys: 6


Performance
-----------

Decent. Here's a timed output on a larger (629MB) db on my macbook:

    ~/Projects/pianoman[master*]: time ./pm ~/gooddump.rdb api dashboard
    ==== Processed 408117 valid opcodes (in 659980364 bytes) =======================

    Key Space:

    Strings: 140810 (34.50%)
    Lists: 10365 (2.54%)
    Sets: 3261 (0.80%)
    Zsets: 1 (0.00%)
    Hashes: 253678 (62.16%)

    Match Stats:

    0) api 253678.00 (62.16%)
    1) dashboard 78297.00 (19.19%)

    Total Keys: 408115

    real	0m9.109s
    user	0m8.264s
    sys	0m0.821s


Installation
------------

make all

Inspiration
-----------

"And I move keys, you can call me the Piano Man" - Jay-Z

Credits
-------

(c) 2011 Michael R. Bernstein unless noted