### redis database dumper (rdd) 0.3

© 2012 ~ 2014 noferi mickaël (r043v/dph) / noferov@gmail.com / https://github.com/r043v/rdd/

This work is licensed under a Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.
  http://creativecommons.org/licenses/by-nc-sa/3.0/

-------------------------------------

It's a beta software, use it at your own risk !

It does not replace your own rdb file saving, do not rely only on this sofware for precious data !

### DO NOT USE THIS SOFTWARE IF YOUR KEY NAMES ARE BINARY SAFE

-------------------------------------

this tool can be used to dump a redis database, work on dump and put dump into redis

this tool not use .rdb file ! i made my own file format, .rdd

-------------------------------------

## Know bugs

not any, but I did not make any serious tests :)
there are no check tests .. so, a bad dump file can may crash

## How to compile

you need hiredis library + gcc

debian based linux :
```
apt-get install libhiredis-dev build-essential
``` 

redhat based linux :
``` 
yum install hiredis-devel build-essential
``` 

to build:
```
make
```

compiling on FreeBSD 10.0
```
portinstall hiredis
cc -std=c99 rdd.c -lhiredis -L/usr/local/lib -I/usr/local/include -o rdd
```

## Usage

all arguments are optional

```
./rdd [inputs] -f [filters] -m [match filters] -mv [find_text replace_text] -o outputType -s [hostname] -d [database] -p [port] -a [password]
```

inputs can be redis keys command filter, or, .rdd files, all specifyd inputs will be merged
filters can only be wilcards keys name filters : "*cache*" "*user:???:*", put any filter as you need
match filters are wilcards too, it specify keys to keep, you can put multiple match filters

no inputs mean "*" redis keys command filter will be used, so, get all keys

```
-mv argument
```
it's for "move", keys rename

follow mv with pairs of replace text in keys name
```
-mv "my_prefix:" "my_new_prefix:"
```

you can done some replace at the same time

```
-mv "my_prefix:" "my_new_prefix:" ":user:old_name" ":user:new_name" ":user:" ":web_site_users:"
```

match and replace are not wildcard, but plain text

output argument

- `-o "file.rdd"` save keys set into specifyd .rdd file
- `-o "insert"` will write all keys into redis (and before insert delete them)
- `-o "delete"` delete all keys from redis
- `-v` will increase verbose mode, can be 0, 1 or 2
  - `verbose level 1` print output set keys name
  - `verbose level 2` print output set keys name and all keys data
  - no output (-o) specify will increase verbose
- `-s "127.0.0.1"` specify redis database ip
- `-p "6379"` specify redis port
- `-a "password"` specify redis auth password
- `-d "#database"` specify database number to use

also, default type for no flag input are "input", can also be set with -i

## Examples

will print all keys name
```
./rdd
```

will print all keys where name match "*user*"
```
./rdd "*user*"
```

save all keys into "save.rdd"
```
./rdd -o "save.rdd"
```

will save all keys where name match "*user*" into "save.rdd" file
```
./rdd "*user*" -o "save.rdd"
```

get all "myprefix:*" redis keys, remove "*cache*" keys and save result as "mydump.rdd"
```
./rdd "myprefix:*" -f "*cache*" -o "mydump.rdd"
```

get all keys from "mydump.rdd" file, keep only keys name who match "*:user:*" and save result as "users.rdd"
```
./rdd "mydump.rdd" -m "*:user:*" -o "users.rdd"
```


merge "mydump.rdd" keys with redis keys who match "*comment*" and "*article*", remove all keys who match "*cache*", keep only keys match "myprefix*" and save the result as "mydump.rdd"
```
./rdd "mydump.rdd" "*comment*" "*article*" -f "*cache*" -m "myprefix*" -o "mydump.rdd"
```

### Move some keys from one redis instance to another one

save all keys of your choice
```
./rdd "myprefix:*" -o "keys.rdd" -s "ip of redis instance 1" -p "port of redis instance 1"
```

delete all keys from source redis
```
./rdd "keys.rdd" -o delete -s "ip of redis instance 1" -p "port of redis instance 1"
```

filter keys from dump if need, here we delete "cache" temp keys
```
./rdd "keys.rdd" -f "*cache*" -o "keys.rdd"
```

now save dump into redis instance 2
```
./rdd "keys.rdd" -o insert -s "ip of redis instance 2" -p "port of redis instance 2"
```
