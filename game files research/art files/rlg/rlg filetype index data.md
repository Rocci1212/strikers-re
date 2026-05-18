# Section B007 - RLG Index Data

### What are indices 
In 3D graphics, each triangle is made of three vertices.  
To reference the vertices, we use indices.  

## Section header
| **offset** | **attribute**          | **value**                   |
|------------|------------------------|-----------------------------|
| 0x0-0x1    | flags                  | usually 0x0001              |
| 0x2-0x3    | identifier             | 0xB007                      |
| 0x4-0x7    | body size              | depends on many factors     |


## Section body
The body contains 16bit indices.  
They are 0-based (Like the .dae format, and unlike the .obj format, the first index is 0, not 1).  

### How to tell which indices are related to which mesh?
1. go to the mesh data of the mesh of interest
2. In that data, look for: 
  * index_offset, offset 0x0 (INT32)
  * index_count, offset 0x6 (INT16)
3. Go to index_offset (remember: offsets are always relative to the beginning of the section body)
4. The following index_count indices are related to this mesh.

### How to actually read the indices
* Consider the first three indices of the mesh
  * If **they're all different from each other**, this is a triangle
  * Otherwise this is not a triangle, just ignore it
* Move forward by 1. So if you were considering at indices 0,1,2 now look at 1,2,3 (NOT 3,4,5)
* Repeat until you get to the end of the meshes section

After you're done with this procedure, you'll have a list of faces, but there is still one thing you have to take care of

### Face normals (they're weird)
In many file formats (i.e. .dae format), face normals (the direction the face points to) are to the counterclockwise side.  
The .rlg format works like that, but only for **faces whose indices start at a even index** of the meshe's index data.  
**Faces that start at an odd index are flipped**  


### Old notes featuring examples
>[...]
>For instance, if in mario.rlg I want to find the index offset of the first mesh, so I go to the mesh data section (identifier 0x8004)  
>For mario.rlg the mesh data section's data starts at byte 0x4AB88  
>I look at the first 32bit integer, which is at 0x4AB88, and in this case it's 0.  

>If I wanted to find the second meshe's index offset I would have gone to 0x4AB88 + 0x30 = 0x4ABB8
>Here I find the value 0x2C2


>3. Now that we have the index offset, go to index section's beginning plus the offset
>
>In the case of mario.rlg's first mesh, that's 0x4F8 + 0 = 0x4F8
>
>In the case of mario.rlg's second mesh, that's 0x4F8 + 0x2C2 = 0x7BA


>4. Now read the meshe's index count, which is a 16bit integer located at the meshe's mesh data offset 0x6
>
>In the case of mario.rlg's first meshe's it can be found at 0x4AB88 + 0 + 0x6 = 0x4AB8E
>It's value is 0x161
>
>In the case of mario.rlg's first meshe's it can be found at 0x4AB88 + 0x30 + 0x6 = 0x4ABBE
>It's value is 0x024D
>
>( the 0x4AB88 is the mesh data section's start, the 0 or 0x30 is the mesh data of the specific mesh ( mesh_number*0x30 ), the 0x6 is the offset of the index count value within a meshe's mesh data )


>5. Now that we have the index count we know how much to read. Read as many 16bit integers* as the index count.
>
>*This could actually be 8bit integers for some files, but I haven't really explored that. 
> The mesh data value with offset 0x4 is called index format and face format and should tell you whether it's a 8bit or 16bit int.
> Afaik, if it's 0x0000 it's 16bit, if it's 0x8000 it's 8bit, though I haven't seen 8bit indices being used yet.


>6. Now that we have a list of the indices of the mesh, loop through them.
>- Start by taking the first three of them, so like 1st to 3rd
>- Check if they're all different
>- IF they are, that's a triangle. Add it to your list of triangles in whatever code you're writing.
>- if two or more are the same, skip this
>- repeat the process with indices 2nd-4th, then 3rd-5th, then 4th-6th, you get the point...