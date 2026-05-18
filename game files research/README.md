# MSC Filetype research
In this folder you can find some notes about MSC files.  
Some of these apply for Super Mario Strikers (GameCube) too.  


## Structure of an MSC filetype
Most files are made of sections that have an header of this kind (in hexadecimal):  

* An 8-bytes-long Header WWWWTXXX YYYYYYYY where...
  * 0x0-0x1: WWWW - Some flags
  * 0x2-0x3: TXXX - Section identifier
  * 0x4-0x7: YYYYYYYY - Section body size
* A YYYYYYYY bytes long body 
  * If the first bit of flags is low: the body could contain any kind of data. The format depends on the section type. See the .md files for information about each section.
  * If the first bit of flags is high (i.e. 0x8000): the body doesn't have it's own data, but it contains other sections instead. Think of this as a tree structure.


## Existing filetypes and relative sections
* 0001 - root section of .bun and .resbun files, which are file archives
* 3XXX - audio files. This kind of section is found in .resbun or .bun files, inside a 0001 section
* 4XXX - effects files. This kind of section is found in .bun files, inside a 0001 section
* 5XXX - .cam files - used for animating cameras
* 7XXX - .sanim files - used for animating characters
  * 71XX - this is also used for files like mario.bin, found in "animretarget" directory 
* 8XXX - .shier files - containing the bones for the 3D models
* BXXX - .rlg (or .glg) files - used for 3D models
* DXXX - .cph files - small files probably used for physics and collision related stuff.


## Filetypes that use multiple kinds of sections

### .nis files, 
.nis files are cutscene files and are a mix of camera and animation files. In fact, they can have both 5XXX and 7XXX.  
A .nis file usually starts with a 7 root section, then at the end of that section, there's the root section.  
In other words, it's as if it was a concatenation of a .sanim and a .cam file.  


## List of filetypes that do not follow this convention
* .rlt/.glt files used for textures
* .trg files probably used for animation triggers
* any compressed file, at least until you decompress it