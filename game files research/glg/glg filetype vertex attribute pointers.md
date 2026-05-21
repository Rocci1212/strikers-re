# Section B005 - GLG Vertex Attribute Pointers

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
| 0x4-0x7    | body size              | VAP_count*6                 |


Section body:
## Section body
The V.A.P. count can be found in mesh data  
It can also be calculated by dividing the section body's size by 6  
This section is subdivided in **records of 6 bytes each**    
This is how each record is structured:
| **offset**   | **attribute**              | **type**  |
|--------------|----------------------------|-----------|
| 0x0-0x3      | vertex_offset              | UINT32    |
| 0x4          | type                       | BYTE      |
| 0x5          | stride                     | BYTE      |


### V.A.P. types
Here's a list of types:
| **value**    | **what it points to**                | **possible stride number** |
|--------------|--------------------------------------|----------------------------|
| 0            |                                      |                            |
| 1            |                                      |                            |
| 2            |                                      |                            |
| 3            |                                      |                            |
| 4            |                                      |                            |

I'll fill in the table when I will have figured it out.
