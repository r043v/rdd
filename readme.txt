-------------------------------------
--- redis dumper --- rdd --- 0.2 ---
-------------------------------------

by r043v/dph  ...  noferov@gmail.com  ...  https://github.com/r043v/rdd/

This work is licensed under a Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.
  http://creativecommons.org/licenses/by-nc-sa/3.0/

-------------------------------------

it's an alpha software, use it at your own risk !

it does not replace your own rdb file saving, do not rely on this sofware for precious data !

-------------------------------------

this tool can be used to dump a redis database, work on dump and put dump into redis

this tool not use .rdb file ! i made my own file format, .rdd

-------------------------------------

changelog

0.2	add ttl support, save ttl with end unix timestamp value, will auto filter expired keys before output them anywhere.
0.1	memory leak fix
0.1a	initial release

-------------------------------------

know bugs ..

not any, but i not made serious test :)
there are no check test .. so, a bad dump can crash

-------------------------------------

how to compile ..

you need hiredis library,
single file mean single line : gcc -std=c99 rdd.c ./libhiredis.a -o rdd

-------------------------------------

usage ..

all arguments are optionals

./rdd [inputs] -f [filters] -m [match filters] -o outputType

inputs can be redis keys command filter, or, .rdd files, all specified inputs will be merged
filters can only be wilcards keys name filters : "*cache*" "*user:???:*", put any filter as you need
match filters are wilcards too, it specifie keys to keep, you can put multiple match filters

no inputs mean "*" redis keys command filter will be used, so, get all keys

output argument

-o "file.rdd" save keys set into specified .rdd file
-o "insert" will write all keys into redis (and before insert delete them)
-o "delete", delete all keys from redis

-v will increase verbose mode, can be 0, 1 or 2
verbose == 1 will print output set keys name
verbose == 2 will print output set keys name and all keys data
no output (-o) specified will made verbose++;

-s "127.0.0.1" specifie redis database ip
-p "6379" specifie redis port
-a "password" specifie redis auth password
-d "#database" specifie database number to use

also, default type for no flag input are "input", can also be set with -i

-------------------------------------

exemple ..

./rdd
will print all keys name

./rdd "*user*"
will print all keys where name match "*user*"

./rdd -o "save.rdd"
save all keys into "save.rdd"

./rdd "*user*" -o "save.rdd"
will save all keys where name match "*user*" into "save.rdd" file

./rdd "myprefix:*" -f "*cache*" -o "mydump.rdd"
get all "myprefix:*" redis keys, remove "*cache*" keys and save result as "mydump.rdd"

./rdd "mydump.rdd" -m "*:user:*" -o "users.rdd"
gat all keys from "mydump.rdd" file, keep only keys name who match "*:user:*" and save result as "users.rdd"

./rdd "mydump.rdd" "*comment*" "*article*" -f "*cache*" -m "myprefix*" -o "mydump.rdd"
merge "mydump.rdd" keys with redis keys who match "*comment*" and "*article*", remove all keys who match "*cache*", keep only keys match "myprefix*" and save the result as "mydump.rdd"


exemple, move some keys from one redis instance to another one

// save all keys of your choice
./rdd "myprefix:*" -o "keys.rdd" -s "ip of redis instance 1" -p "port of redis instance 1"

// delete all keys from source redis
./rdd "keys.rdd" -o delete  -s "ip of redis instance 1" -p "port of redis instance 1"

// filter keys from dump if need, here we delete "cache" temp keys
./rdd "keys.rdd" -f "*cache*" -o "keys.rdd"

// now save dump into redis instance 2
./rdd "keys.rdd" -o insert -s "ip of redis instance 2" -p "port of redis instance 2"

-------------------------------------
