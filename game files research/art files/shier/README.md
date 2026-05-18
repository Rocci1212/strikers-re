# SHIER filetype
Shier files contain bone data that is used by the .rlg files.

## Section hierarchy
"section identifier" - "section"
* 8000 - Root section, contains all the other sections and extends from the beginning to the end of the file
  * 8001 - Unknown
  * 8002 - Name
  * 8003 - Bone hash IDs (kinda)
  * 8009 - Parent bone IDs
  * 8004 - Unknown
  * 8005 - Unknown
  * 8006 - Unknown
  * 8007 - Unknown
  * 8008 - Symmetrical bone IDs
  * 8010 - 3D float vectors
  * 8011 - Bone boolean values


Important: We'll call N **the amount of bones of the model**  
This number will appear frequently throughout the file.  
Bones are enumerated from 0 to N-1.  
This N number can also appear in related files, such as .sanim and .nis files


## Section 8000 - SHIER root section
### Section header
  * flags: 0x8001
  * size: file length - 8

This section doesn't have its own content. It's the root of the tree of sections, and the other sections are the leaves


## Section 8001 - unknown
### Section header
  * flags: 0x0001
  * size: maybe N + 8?


## Section 8002 - SHIER object name section
### Section header
  * flags: 0x0001
  * size: length of the string + padding to align by 4


## Section 8003 - SHIER bone hash IDs
### Section header
  * flags: 0x0001
  * size: N*4

### Section body
This section contains bone hash IDs.
A weird thing I noticed in the file I analyzed is that by checking with the hashid.bin, the first hash ID doesn't seem to be a valid hash ID, the second is called "ball". The rest make more sense, but the third doesn't appear in the "bone matrices (B00A)" or the "mesh bone hashes (B00B)" sections of the RLG file.


## Section 8009 - SHIER parent bone IDs
### Section header
  * flags: 0x0001
  * size: N*4

### Section body
This section tells you which bone is the parent of which.  

### How to tell who's the parent of bone number i
Look at the word i (with 0 <= i <= N-1) of this section's body.  
There you will find the index of the parent bone.  


## Section 8004 - unknown
### Section header
  * flags: 0x0001
  * size: N*4

### Section body
This section contains numbers from 0 to 3. Could be an enum, a bitfield or something like that.


## Section 8005 - unknown
### Section header
  * flags: 0x0001
  * size: N*4

### Section body
This section contains some bone indices.


## Section 8006 - unknown
### Section header
  * flags: 0x0001
  * size: N*4

### Section body
This section contains some bone indices.


## Section 8007 - unknown
### Section header
  * flags: 0x0001
  * size: (N-1)*4

### Section body
This section contains some bone indices.


## Section 8008 - SHIER symmetrical bone
### Section header
  * flags: 0x0001
  * size: N*4

### Section body
This section tells you who the symmetrical equivalent of a bone is. (I think)  
If bone number i doesn't have a symmetrical equivalent, the word i of this section will just be the index of the bone i.  


## Section 8010 - 3D float vector section
### Section header
  * flags: 0x0201
  * size: N*12

### Section body
These are clearly floats. Really small floats. Most of them are between -1 and 1.  
I don't know what they are for though.


## Section 8011 - SHIER bone boolean value section
### Section header
  * flags: 0x0001
  * size: N

### Section body
bytes with values of zeroes and ones  
no idea what any of these is, but in the file I analyzed, the first three are 0, the others are 1.  
Perhaps 0 means that it doesn't appear in the RLG file.