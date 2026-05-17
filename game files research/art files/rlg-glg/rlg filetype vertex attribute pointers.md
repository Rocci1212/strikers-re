# Section B005 - RLG Vertex Attribute Pointers

### What is a "Vertex Attribute Pointer"?
A Vertex Attribute Pointer, or VAP for short, is **a record that tells the game where to find the vertices**.  
This data is a requirement for being able to navigate the vertex section (B006)  
* The **offset** tells you where in the vertex section the data is
* The **type** tells you what kind of data it is (position, normals, ...)
* The **stride** tells you how many bytes of the data to read for each vertex.
  * For instance, if stride=12:
    * The bytes 0-11 are associated to the first vertex
    * The bytes 12-23 are associated to the second vertex
    * The bytes 24-35 third vertex
    * and so on...


## Section header
| **offset** | **attribute**          | **value**                   |
|------------|------------------------|-----------------------------|
| 0x0-0x1    | flags                  | usually 0x0001              |
| 0x2-0x3    | identifier             | 0xB005                      |
| 0x4-0x7    | body size              | VAP_count*8                 |


Section body:
## Section body
The V.A.P. count can be found in mesh data  
It can also be calculated by dividing the section body's size by 8  
This section is subdivided in **records of 8 bytes each**    
This is how each record is structured:
| **offset**   | **attribute**              | **type**  |
|--------------|----------------------------|-----------|
| 0x0-0x3      | vertex_offset              | UINT32    |
| 0x4          | flags?                     | BYTE      |
| 0x5          | stride                     | BYTE      |
| 0x6          | type                       | BYTE      |
| 0x7          | probably padding (0x00)    | -         |


### V.A.P. types
Here's a list of types:
| **value**    | **what it points to**                | **possible stride number** |
|--------------|--------------------------------------|----------------------------|
| 1            | position                             | 12, 6                      |
| 2            | normal                               | 12, 3                      |
| 3            | vertex colors (I think)              | 4                          |
| 4            | UV coordinates                       | 4                          |
| 5            | bone weights                         | 16                         |
| 7            | bone indices                         | 4                          |


### V.A.P. flags thing
I call it "flags", but I am not sure what that byte is really.  
Each type always has the same "flags", except for UV coordinates.  
There can be multiple UV coordinate V.A.P.s in a mesh, and each of them will have a different flag, but it can vary across rlg files.


### Old notes that I want to keep for preservation
> The type is something I haven't fully figured out yet. Here's what I know as of right now.
>
>0x67  is for the vertex's position. 
>      - The value is always an array of 3 single floats. 
>      - Stride is always 12 afaik
>
>0xFE  is for the vertex's normal. 
>      - The value is an array of 3 numbers... 
>      - If stride is 12, it's there single floats. From my experience, the files I analyzed were always like this.
>      - According to KillzXGaming, the stride could be 3, and in that case the value is a array of 3 signed bytes. 
>        Divide each of those bytes by 255 to get the floating point equivalent.
>
>0xCC  is uv mapping. 
>      - The value is an array of 2 16bit signed ints.
>      - Stride is always 4 afaik
>        Divide each of these bytes by 1024 to get the floating point equivalent.
>        According to the switch-toolbox source code the integers are unsigned, but I found out they're actually signed.
>        Some texture have uv coords with a negative value, even though it's extremely rare. mario.rlg contains like 3 negative uv coords in total
>
>0xED  unknown (stride 4)
>0x52  unknown (stride 4)
>0xC0  unknown (stride 4)
>0xD6  unknown (stride 4)
>0xD7  unknown (stride 4)
>
>0xD4  bone ids
>      - The value is an array of 4 bytes.
>      - Stride is always 4 afaik
>      - Each byte of the array represents a bone ID
>
>0xB0  bone weights
>      - The value is an array of 4 32bits numbers.
>      - Stride is always 16 afaik
>      - I believe each number of the array is a float between 0 and 1 (in fact, it is a weight)
>      - I think it works like this: bone_weight[ X ] is the weight associated to the bone that has id of bone_id[ X ]
>
>
>
>The following attribute pointer types are mentioned in the switch-toolbox source code, but I've never seen them.
>Maybe some of these are for glt only?
>
>0x00  from toolbox source code:
>      if (pointer.Stride == 6)
>            vert.pos = new Vector3(reader.ReadInt16() / 1024f, reader.ReadInt16() / 1024f, reader.ReadInt16() / 1024f);
>      else if (pointer.Stride == 12)
>            vert.pos = new Vector3(reader.ReadSingle(), reader.ReadSingle(), reader.ReadSingle());
>
>0x01  this is like the normal, and it can have either stride of 3 or 12. Apparently type 0xFE always has stride of 12
>
>0x03  another uv pointer type
>
>0x26 yet another uv pointer type
>
>0x17 this is called "uv1" in sw-toolbox. I have no idea what this is. I guess a texture can have multiple uvs?

