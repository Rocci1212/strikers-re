# SANIM filetype
Sanim files contain animation data for animating rlg models.  
They often reference bones using the same enumeration found in shier files.  

## Section hierarchy
"section identifier" - "section"
* 7000 - Root, contains all the other sections of an animation. Sometimes files can have multiple roots. Especially .nis files.
  * 7001 - Unknown, 16bit signed ints?
  * 7002 - Name (like "Mario")
  * 7110 - Unknown, Something related to bones? (the first occurrence of this section in mario_home_capt_intro_3.nis has 0xB0 size, that's why I think so)
  * 7113 - Same as above
  * 7004 - Same as above
  * 7005 - Same as above
  * 7006 - Same as above
  * 7111 - Same as above
  * 7114 - Same as above
  * 7007 - 16bit signed ints? (mostly 0 and -1)
  * 7008 - Character positions. A long list of 3 float vectors.
  * 7100 - Bone animation container? There are like 45 of these in mario_home_capt_intro_3.nis, and they all have 0x23C size
    * 7101 - Bone angles?
    * 7102 - Bone positions?
  * 7009 - Unknown. Contains small int32 numbers. 
  * 700A - Unknown. It's size is probably always the same as 7009's. 
  * 700B - Unknown. Many 16bit ints (-1 and 0) (0x0000 and 0xFFFF)
  * 7003 - Bone indices?

I am not sure how consistent the section hierarchy is between files.  
Some files are missing most of the sections.  

Important: We'll call N **the amount of bones of the model, found in the shier file**  
You'll see many sections of this file have a size that is a multiple of N.  


## Section 7000 - SANIM root section
### Section header
  |               |                              |
  |---------------|------------------------------|
  | flags         | 0x8001                       |
  | size          | file length - 8              |

This section doesn't have content of its own. It's the root of the tree of sections.


## Section 7001 - unknown
### Section header
  |               |                              |
  |---------------|------------------------------|
  | flags         | 0x0001                       |
  | size          | N*2? Or maybe always 0x58?   |

### Section body
I don't know. Perhaps 16bit integer representing the initial angles of bones?  


## Section 7002 - name
### Section header
  |               |                              |
  |---------------|------------------------------|
  | flags         | 0x0001                       |
  | size          | string length, aligned by 4  |

### Section body
string, name of the animation, or the model


## Section 7110 - unknown bone data
### Section header
  |               |                              |
  |---------------|------------------------------|
  | flags         | 0x0001                       |
  | size          | N*4                          |

### Section body
In the files I analyzed, this was all zeros.  


## Section 7113 - unknown bone data
### Section header
  |               |                              |
  |---------------|------------------------------|
  | flags         | 0x0001                       |
  | size          | N*4                          |

### Section body
In the files I analyzed, this was all zeros.  


## Section 7004 - unknown bone data
### Section header
  |               |                              |
  |---------------|------------------------------|
  | flags         | 0x0001                       |
  | size          | N*4                          |

### Section body
In the files I analyzed, this was all zeros.  


## Section 7005 - unknown bone data
### Section header
  |               |                              |
  |---------------|------------------------------|
  | flags         | 0x0001                       |
  | size          | N*4                          |

### Section body
In the files I analyzed, this was all zeros.  


## Section 7006 - unknown bone data
### Section header
  |               |                              |
  |---------------|------------------------------|
  | flags         | 0x0001                       |
  | size          | N*4                          |

### Section body
In the files I analyzed, this was all zeros.  


## Section 7111 - unknown bone data
### Section header
  |               |                              |
  |---------------|------------------------------|
  | flags         | 0x0001                       |
  | size          | N*4                          |

### Section body
In the files I analyzed, this was all zeros.  


## Section 7114 - unknown bone data
### Section header
  |               |                              |
  |---------------|------------------------------|
  | flags         | 0x0001                       |
  | size          | N*4                          |

### Section body
In the files I analyzed, this was all zeros.  


## Section 7007 - unknown
### Section header
  |               |                              |
  |---------------|------------------------------|
  | flags         | 0x0001                       |
  | size          | Couldn't find any pattern    |

### Section body
This usually has hex numbers such as 0xFF or 0.  
I have the feeling these should be read as signed int16 numbers.


## Section 7008 - object positions
### Section header
  |               |                              |
  |---------------|------------------------------|
  | flags         | 0x0201                       |
  | size          | Couldn't find any pattern    |

### Section body
A sequence of vectors of 3 floats each.  
Probably the list of points the animated object will move to.  


## Section 7100 - unknown container sections
### Section header
  |               |                              |
  |---------------|------------------------------|
  | flags         | 0x8001                       |
  | size          | Couldn't find any pattern    |

There are **A TON** of these.  
Some have a size of zero and are empty.  
Many have the same size as others.  
There are a few more 7100 sections than there are bones, so it is possible that each one is linked to a bone.  
The files I looked at had like 45 of these. 


## Section 7101 - unknown, maybe bone angles?
### Section header
  |               |                              |
  |---------------|------------------------------|
  | flags         | 0x0001                       |
  | size          | Couldn't find any pattern    |

This is a child section of 7100.  
There are 0 or 1 of these for each 7100 section.

### Section body
It kinda looks like a sequence of vectors of 4 int16 numbers.
Perhaps angles.  
Could be the angles that a bone need to travel?


## Section 7102 - unknown, maybe bone position?
### Section header
  |               |                                                             |
  |---------------|-------------------------------------------------------------|
  | flags         | 0x0001                                                      |
  | size          | Couldn't find any pattern, except it's a multiple of 0xC    |

This is a child section of 7100.  
There are 0 or 1 of these for each 7100 section.  

### Section body
This section contains a sequence of vectors of 3 floats.  
Sometimes it's so short that it's just one vector.  
I don't know much about 3D animation, but could this be the positions that a bone needs to travel?  
It would make sense that bones that aren't moved just stay in the same position all the time, so they just have one vector.


## Section 7009 - unknown
### Section header
  |               |                                                            |
  |---------------|------------------------------------------------------------|
  | flags         | 0x0001                                                     |
  | size          | it's the same size as 700A                                 | 

### Section body
4 byte ints. Usually they're so small that they use just 1 byte.


## Section 700A - unknown
### Section header
  |               |                                                            |
  |---------------|------------------------------------------------------------|
  | flags         | 0x0001                                                     |
  | size          | Same as 7009                                               |

### Section body
Floats?


## Section 700B - unknown
### Section header
  |               |                                                                                                             |
  |---------------|-------------------------------------------------------------------------------------------------------------|
  | flags         | 0x0001                                                                                                      |
  | size          | A multiple of the size of 700A (and 7009). Which multiple you ask? Depends, I don't know from what.         |

### Section body
16bit (I think) integers. Maybe angles?  


## Section 7003 - bone indices
### Section header
  |               |                                                                                                             |
  |---------------|-------------------------------------------------------------------------------------------------------------|
  | flags         | 0x0001                                                                                                      |
  | size          | Sometimes N, sometimes not.                                                                                 |

### Section body
Bone indices. Changing them messes with the animation.

