# Section B004 - RLG Mesh data

## Section header
| **offset** | **attribute**          | **value**                                             |
|------------|------------------------|-------------------------------------------------------|
| 0x0-0x1:   | flags                  | usually 0x0001                                        |
| 0x2-0x3:   | identifier             | 0xB004                                                |
| 0x4-0x7:   | body size              | depends on how big each mesh record is...             |

This section contains some material data and size will vary.  
To determine the size of a mesh record, divide the section size by the total mesh count (of all models).  
It's often 0x4A for characters.


## Section body
This section's body is made of as many records as the total mesh amount of all the models in the file (check model section).  
This is how each record is structured:
| **offset**   | **attribute**                            | **type**      |
|--------------|------------------------------------------|---------------|
| 0x0-0x3      | unknown (null)                           | -             |
| 0x4-0x7      | index_start_offset                       | UINT32        |
| 0x8-0x9      | index_count                              | UINT16        |
| 0xA          | face_type                                | BYTE          |
| 0xB          | vertex_attribute_pointer_count           | BYTE          |
| 0xC-0xF      | vertex_attribyte_pointer_offset          | UINT32        |
| 0x10-0x13    | unknown (null)                           | -             |
| 0x14-0x17    | unknown (0x0CC80000)                     | -             |
| 0x18-0x1B    | unknown (null)                           | -             |
| 0x1C-0x1F    | material_hash_id?                        | UINT32        |
| 0x20-0x23    | unknown (0x001D0007)                     | -             |
| 0x24-0x27    | unknown (null)                           | -             |
| 0x25-0x2B    | texture_hash_id?                         | UINT32        |
| 0x2C-0x2F    | texture_hash_id?                         | UINT32        |
| ...          | other material data (unknown)            | -             |

