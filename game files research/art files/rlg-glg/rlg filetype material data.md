# Section B016 - RLG Material data

## Section header
| **offset** | **attribute**          | **value**                                                    |
|------------|------------------------|--------------------------------------------------------------|
| 0x0-0x1    | flags                  | usually 0x0001                                               |
| 0x2-0x3    | identifier             | 0xB016                                                       |
| 0x4-0x7    | body size              | varies from file to file, I cannot seem to find a pattern    |


## Section body
This section is divided in two halves

### First half - Texture hash ID section 
This part contains N 8-byte-long records of this kind
I am unsure how to determine the value of N, but it seems to be related to how many UV VAPs there are in the mesh.
  * for instance, mario.rlg has 6 UV VAPs and 6 textures for each material.
| **offset** | **attribute**          | **value**                                     |
|------------|------------------------|-----------------------------------------------|
| 0x0-0x3    | texture hash ID        | an INT32, hash id of the texture              |
| 0x4-0x7    | some bytes             | it's always 0xFF00                            |

The first texture is usually what I call the main texture, it's the one you see clearly.  
The other texture are stuff like images used for reflectiveness, or textures that appear only after the character is frozen (icicles texture).  
If you replace an hash ID, the game will load the texture for the hash ID you entered, so it is possible to change material.  
This probably only works with texture that are located in the associated .rlt file though. (i.e. you cannot give luigi's texture to mario) never tried though.

### Second half - Some floats and some flags
The structure this varies from file to file and I don't understand how.  
The floats should regulate texture transparency. For instance, setting the first float of mario.rlg to 0.5 (instead of 1.0) makes mario transparent  
The flags should enable some material properties such as metallicness, but I am unsure.  