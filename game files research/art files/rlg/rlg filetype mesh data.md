# Section B004 - RLG Mesh data

## Section header
| **offset** | **attribute**          | **value**                   |
|------------|------------------------|-----------------------------|
| 0x0-0x1:   | flags                  | usually 0x0001              |
| 0x2-0x3:   | identifier             | 0xB004                      |
| 0x4-0x7:   | body size              | mesh_count*0x30             |


## Section body
Mesh count = body size / 48  
This section's body is made up of size/48 records  
This is how each record is structured:
| **offset**   | **attribute**                            | **type**      |
|--------------|------------------------------------------|---------------|
| 0x0-0x3      | index_start_offset                       | UINT32        |
| 0x4-0x5      | index_format                             | UINT16        |
| 0x6-0x7      | index_count                              | UINT16        |
| 0x8-0x9      | vertex_count                             | UINT16        |
| 0xA          | unknown (probably material count)        | BYTE          |
| 0xB          | vertex_attribute_pointer_count           | BYTE          |
| 0xC-0xF      | vertex_attribyte_pointer_offset          | UINT32        |
| 0x10-0x13    | material_hash_id                         | UINT32        |
| 0x14-0x17    | mesh_hash_id                             | UINT32        |
| 0x18-0x1F    | unknown                                  | -             |
| 0x20-0x23    | material_offset                          | UINT32        |
| 0x24-0x2F    | unknown                                  | -             |


## Example 
If you need to read any data from the mesh data section, use the following formula to find the location of that data:
(section_body_start) + (0x30 * number_of_the_mesh) + offset of the value to look for  
For example, if we need the mesh number 5's vetex_count:  
Let's pretend our rlg file has a mesh data section body that starts at 0x1000, the formula would be:
0x1000 + (0x30 * 5) + 0x8 = 0x10F8

