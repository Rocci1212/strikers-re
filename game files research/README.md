# MSC Filetype research
In this folder you can find some notes about MSC files.  
Some of these apply for Super Mario Strikers (GameCube) too.  


## Structure of an MSC filetype
Most files are made of sections that have an header of this kind (in hexadecimal):  
WWWWTXXX YYYYYYYY where...
* W are some flags we don't know much about
* T identifies the filetype (see below)
* X identifies the section within the filetype
* Y is the size of the section body

The section is then followed by a body of YYYYYYYY bytes of length, which contains some content that can vary depending by the section. See the documentation for the specific filetypes to know more about that.  
If the first bit of the section's flags is high, that means the section is a section container.  
If it's a section container, that means its content is other sections. You can think of this as a tree structure, where the leaves are the section that have the first flag bit low.  
Every file starts with a root section, which is a container of sections.  


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