Shier files are believed to contain bone data that is used by the .rlg files.

Disclaimer: I know very little about 3d modelling, so I'm not sure how bones are encoded even in commonly used file types.
If anyone experience wants to help me with this, please do so.



0x000: 80 01 80 00  this is the section identifier that is also at the beginning of any .rlg file
0x004: this is the size of the section. It extends all the way to the end of the file
There are actually other sections within this section. This is more like a "macro-section", a "section container".

The sections of this file work the same way as the rlg sections.
The header is 8 bytes long and is structured like this:
0x0: flags?
0x2: section identifier
0x4: length of section body in bytes 


SECTION 8001: ???
no idea what any of this is


SECTION 8002: object name
The body contains a string. It seems to be the name of the object.


SECTION 8003: hashes (?)
These look like some really big 32bit ints. Probably hashes.
(or maybe it's actually bytes?)
The length of this section seems to be related to the amount of bones.


SECTION 8009: ???
Not sure what these are
These look like 32bit signed ints. Some indices or something?  
They often range from -1 to ( ( section_length / 4 ) - 2 )
There are not two equal numbers within the section, they're all different.
The length seems to be the same as section 8003's


SECTION 8004: ???
Not sure what these are
They're 32bit ints that range from 0 to 3 and there are repetitions.
The length seems to be the same as section 8003's


SECTION 8005: ???
Not sure what these are
They're 32bit ints that range from 0 to ( ( section_length / 4 ) - 1 )
No repeat numbers.
It seems like they're usually ordered from smallest to biggest
The length seems to be the same as section 8003's


SECTION 8006: ???
Not sure what these are
This section looks the exact same as 8005
The length seems to be the same as section 8003's
This section looks the exact same as 8005


SECTION 8007: ???
Not sure what these are
They're 32bit ints that range from 1 to ( section_length / 4 )
No repeat numbers.
The length seems to be = section 8003's length - 4


SECTION 8008: ???
Not sure what these are
They're 32bit ints that range from 0 to ( ( section_length / 4 ) - 1 )
No repeat numbers.
They're the same numbers you can find in section 8005, except in different order


SECTION 8010: Coordinates
Header:
0x0: 02 01 80 10  this is interesting, it's the first time I see a section identifier start with anything different than "00"
                  I think it's a flag. I guess this section has some special property, idk what that is tho.
                  Not sure if it's like that in every file though. Haven't checked.
0x4: length, it's triple the length of section 8003
I am pretty sure this section contains coordinates
these are clearly floats. Really small floats, I think they're all between -1 and 1.
rlg file's coordinates seem to also have numbers this small.


SECTION 8011 ???
bytes with values of zeroes and ones
no idea what any of these is.
Could be flags? It's a weird way to store flags though.