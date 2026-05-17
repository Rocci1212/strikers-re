# Section B006 - RLG vertex data

## Section header
| **offset** | **attribute**          | **value**                   |
|------------|------------------------|-----------------------------|
| 0x0-0x1    | flags                  | usually 0x0001              |
| 0x2-0x3    | identifier             | 0xB006                      |
| 0x4-0x7    | body size              | depends by many factors     |


## Section body
contains all vertex data, but to navigate this section you need to look up the sections: mesh data (B004) and vertex attribute pointer (B005).  
You should read this repo's "rlg filetype mesh data.md" and "rlg filetype vertex attribute pointers.md" before reading about this section.  

### How to read the vertices of a mesh of an rlg file
* Go to the mesh data of the mesh of interest 
* Read the following values 
  * vertex_count (offset 0x8)
  * vertex_attribute_pointer_count (offset 0xB) 
  * vertex_attribute_pointer_offset (offset 0xC)
* In the vertex attribute section, go to *vertex_attribute_pointer_offset*
* Repeat the following for as many times as *vertex_attribute_pointer_count*:
  * Read the current vertex attribute's data
  * Now, in the vertex data section (B006), go to the offset you found in the vertex attribute pointer
  * Repeat *vertex_count* times:
    * Read a group of bytes of the length of *stride* bytes. This is the data associated with the Nth vertex of the mesh, where N is the number of the iteration of this inner loop
    * To know what kind of data this is and **how to read it**, see table below.
  * Once you're done with reading that, go to the next VAP (move forward by 0x8 bytes in the vertex attribute section) 
    (or exit the loop if you did this *vertex_attribute_pointer_count* times already)

### Data format of each vertex attribute
| **attribute**                        | **stride** | **data format**
|--------------------------------------|------------|----------------------------------------------------------------------------------------------------------------------| 
| position                             | 12         | vector of 3 floats                                                                                                   |
| position                             | 6          | vector of 3 16bit numbers. Divide the 16bit numbers you find by 1024 to get the actual float value                   |
| normal                               | 12         | vector of 3 floats                                                                                                   |
| normal                               | 3          | vector of 3 8bit numbers. Divide the 8bit numbers you find by 255 to get the actual float value                      |
| vertex colors (untested)             | 4          | vector of 4 bytes (RGBA)                                                                                             |
| UV coordinates                       | 4          | vector of 2 16bit numbers. Divide the 16bit numbers you find by 1024 to get the actual float value                   |
| bone weights                         | 16         | vector of 4 floats. The float i is associated to the bone bone_indices[ i ]. The sum is usually 1                    |
| bone indices                         | 4          | vector of 4 bytes. Each of these is an index that references a bone of the mesh (see bone mesh hashes section)       |