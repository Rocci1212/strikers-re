# CPH filetype
Cph files contain components that are associated to the rlg model and (I think) handle collisions.

## Section hierarchy
"section identifier" - "section"
* D000 - Root section, contains all the other sections and extends from the beginning to the end of the file
  * D001 - Physics bone count
  * D002 - Physics bone data


## Section D000 - SHIER root section
### Section header
  |               |                              |
  |---------------|------------------------------|
  | flags         | 0x8001                       |
  | size          | file length - 8              |

This section doesn't have content of its own. It's the root of the tree of sections, and the other sections are the leaves


## Section D001 - CPH physical bone count
### Section header
  |               |                              |
  |---------------|------------------------------|
  | flags         | 0x0001                       |
  | size          | 4                            |

### Section body
32bit int, the count of the physical bone records contained in this file


## Section D002 - Literally all the CPH data
### Section header
  |               |                                                                                                              |
  |---------------|--------------------------------------------------------------------------------------------------------------|
  | flags         | 0x0301                                                                                                       |
  | size          | ((physical_bone_count*0xA0) + 4), or, if you want: (file length - 0x1C)                                      |

### Section body
The section starts with a 4 byte word of zeros of padding.  
Then there is a 0xA0 bytes long record for each physical object.  

| **offset**   | **attribute**                                                                             | **type**               |
|--------------|-------------------------------------------------------------------------------------------|------------------------|
| 0x0-0x3F     | 4x4 transform matrix                                                                      | FLOAT[16]              |
| 0x40-0x5F    | Physical bone name, followed by nulls to add up to 0x20 in length                         | STRING                 |
| 0x60-0x63    | Physical bone hash ID                                                                     | INT32                  |
| 0x64-0x83    | Bone name, followed by nulls to add up to 0x20 in length                                  | STRING                 |
| 0x84-0x87    | Physical bone hash ID                                                                     | INT32                  |
| 0x88-0x8B    | unknown, usually a value like 1 or 2                                                      | INT32                  |
| 0x8C-0x8F    | unknown, usually null                                                                     | ???                    |
| 0x90-0x93    | unknown float, often 0                                                                    | FLOAT                  |
| 0x94-0x9B    | unknown float                                                                             | FLOAT                  |
| 0x9C-0x9F    | unknown, usually null                                                                     | ???                    |