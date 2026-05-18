# CAM filetype
cam files contain instruction for the moving cameras

## Section hierarchy
"section identifier" - "section"
* 500B - Root section, contains all the other sections and extends from the beginning to the end of the file
  * 5001 - Unknown int32 value
  * 5000 - Camera name
  * 5002 - 1st 4x4 Transform matrix
  * 500D - Initial position matrix
  * 500E - Unknown float value
  * 500F - Unknown float value
  * 500C - N, Number of frames of the camera animation?
  * 5003 - Camera positions
  * 5004 - Unknown float[4]s
  * 5005 - Unknown float[3]s 
  * 5006 - Unknown float[3]s
  * 5007 - Unknown float[4]s
  * 5008 - Unknown float[3]s
  * 5009 - Zoom
  * 500A - Zoom 2?


Important: We'll call N **the integer value found in section 500C**  
This number will appear frequently throughout the file.  
I believe this could be the number of frames of the animation.  
  
I called the sections from 5004 to 5008 "unknown", but for most of them it's only a matter of time before finding out what they are, they must be either "rotation" or other things like that.

## Section 500B - CAM root section
### Section header
  |               |                                     |
  |---------------|-------------------------------------|
  | flags         | 0x8002                              |
  | size          | (for .cam files) file length - 8    |

This section doesn't have content of its own. It's the root of the tree of sections, and the other sections are the leaves


## Section 5001 - unknown 4-byte-long value
### Section header
  |               |                              |
  |---------------|------------------------------|
  | flags         | 0x0002                       |
  | size          | 4                            |


## Section 5000 - CAM name section
### Section header
  |               |                                                    |
  |---------------|----------------------------------------------------|
  | flags         | 0x0002                                             |
  | size          | length of the string + padding to align by 4       |

### Section body
String, the name of the camera


## Section 5002 - CAM 4x4 transorm matrix (1)
### Section header
  |               |                                                    |
  |---------------|----------------------------------------------------|
  | flags         | 0x0002                                             |
  | size          | 0x40                                               |

### Section body
A 4x4 transform matrix
I don't know exactly what the purpose of this is.


## Section 500D - CAM initial position matrix
### Section header
  |               |                                                    |
  |---------------|----------------------------------------------------|
  | flags         | 0x0002                                             |
  | size          | 0x40                                               |

### Section body
A 4x4 transform matrix
I think this is the initial position of the camera.


## Section 500E - unknown float value
### Section header
  |               |                                                    |
  |---------------|----------------------------------------------------|
  | flags         | 0x0002                                             |
  | size          | 4                                                  |

### Section body
A 4 byte value. Maybe a float.


## Section 500F - unknown float value
### Section header
  |               |                                                    |
  |---------------|----------------------------------------------------|
  | flags         | 0x0002                                             |
  | size          | 4                                                  |

### Section body
A 4 byte value. Maybe a float.


## Section 500C - frame count, I think
### Section header
  |               |                                                    |
  |---------------|----------------------------------------------------|
  | flags         | 0x0002                                             |
  | size          | 4                                                  |

### Section body
An int32 value. Maybe frame count.  
Each of the next sections has a size that is a multiple of this number.  
For convenience, we'll call this number N.  


## Section 5003 - CAM positions
### Section header
  |               |                                                    |
  |---------------|----------------------------------------------------|
  | flags         | 0x0302                                             |
  | size          | (N*12) + 4                                         |

### Section body
First 4-bytes are 0s. (idk if it's always like that tbf)  
The rest of the section is many arrays of 3 floats, which represent the camera position at a given frame


## Section 5004 - CAM ???
### Section header
  |               |                                                    |
  |---------------|----------------------------------------------------|
  | flags         | 0x0302                                             |
  | size          | (N*16) + 4                                         |

### Section body
First 4 bytes are 0s.
The rest of the section is many arrays of 4 floats.


## Section 5005 - CAM ???
### Section header
  |               |                                                    |
  |---------------|----------------------------------------------------|
  | flags         | 0x0302                                             |
  | size          | (N*12)                                             |

### Section body
Many arrays of 3 floats.


## Section 5006 - CAM ???
### Section header
  |               |                                                    |
  |---------------|----------------------------------------------------|
  | flags         | 0x0302                                             |
  | size          | (N*12) + 4                                         |

### Section body
First 4 bytes are 0s.
The rest of the section is many arrays of 3 floats.


## Section 5007 - CAM ???
### Section header
  |               |                                                    |
  |---------------|----------------------------------------------------|
  | flags         | 0x0302                                             |
  | size          | (N*16) + 4                                         |

### Section body
First 4 bytes are 0s.
The rest of the section is many arrays of 4 floats.


## Section 5008 - CAM ???
### Section header
  |               |                                                    |
  |---------------|----------------------------------------------------|
  | flags         | 0x0302                                             |
  | size          | (N*12)                                             |

### Section body
Many arrays of 3 floats.


## Section 5009 - Zoom/Field of view?
### Section header
  |               |                                                    |
  |---------------|----------------------------------------------------|
  | flags         | 0x0302                                             |
  | size          | (N*4) + 4                                          |

### Section body
First 4 bytes are 0s.
The rest of the section are floats.
If you increase these numbers, the field of view increases.


## Section 500A - Also zoom?
### Section header
  |               |                                                    |
  |---------------|----------------------------------------------------|
  | flags         | 0x0302                                             |
  | size          | (N*4) + 4                                          |

### Section body
First 4 bytes are 0s.
The rest of the section are floats.
I think this is also related to zoom/FOV, but when I tested I couldn't seem to notice a difference.