# Section B008 - RLG Skeleton data container

## Section header
| **offset** | **attribute**          | **value**                   |
|------------|------------------------|-----------------------------|
| 0x0-0x1    | flags                  | usually 0x8001              |
| 0x2-0x3    | identifier             | 0xB008                      |
| 0x4-0x7    | body size              | model_count*0xC             |

This section contains part of the skeleton data, but according to KillzXGaming: *the bones themselves are located in .shier files with parenting information*  

## Subsections
* B00B #1 - "bone mesh hashes", first occurrence 
* B00B #2 - "bone mesh hashes", second occurrence 
* ...
* B00B #N - "bone mesh hashes", Nth occurrence
* B00A - "bone matrices"
* B00C - unknown




# Section B00B - RLG Bone mesh hashes
There are multiple occurrences of this section in a rlg file. One per each mesh.

## Section header
| **offset** | **attribute**          | **value**                        |
|------------|------------------------|----------------------------------|
| 0x0-0x1    | flags                  | usually 0x0001                   |
| 0x2-0x3    | identifier             | 0xB00B                           |
| 0x4-0x7    | body size              | number_of_bones_in_mesh*4        |

## Section body
Array of hashes containing the N bones used by the mesh.  (UINT32[N])
| **offset**   | **attribute**          | **type**  |
|--------------|------------------------|-----------|
| 0x0-0x3      | bone_hash_id           | UINT32    |
Repeat the content of this table by the amount of bones in the mesh




# Section B00A - RLG Bone matrices

## Section header
| **offset** | **attribute**          | **value**                      |
|------------|------------------------|--------------------------------|
| 0x0-0x1    | flags                  | usually 0x0001                 |
| 0x2-0x3    | identifier             | 0xB00A                         |
| 0x4-0x7    | body size              | number_of_bones_in_file*0x44   |

## Section body
It's subdivided in records of 0x44 bytes each.
Each record is associated to a bone.
| **offset**   | **attribute**            | **type**       |
|--------------|--------------------------|----------------|
| 0x0-0x3      | bone_hash_id             | UINT32         |
| 0x4-0x43     | 4x4 (transform?) matrix  | FLOAT[16]      |




# Section B00C - RLG Unknown section

## Section header
| **offset** | **attribute**          | **value**                   |
|------------|------------------------|-----------------------------|
| 0x0-0x1    | flags                  | usually 0x0001              |
| 0x2-0x3    | identifier             | 0xB00C                      |
| 0x4-0x7    | body size              | idk if there's any pattern  |

## Section body:
I just have no idea.  
  
I believe there are two parts:  
  
### Part 1:
It starts with a bunch of numbers which maybe could be bone ids (not hashes, ids from 0 to N-1, where N is bone count)  
(but it's not from 1 to N-1, just to 0x10, so it doesn't really make sense. I guess these might not be IDs then)  
Then it has a bunch of nulls  
  
### Part 2:
Small int32 numbers and floats alternate with a somewhat irregular pattern...  
Sometimes this pattern is int,float  
Sometimes it's int,float,float,float  (array of three floats? Maybe coords?)  
It's as if to each of these integers, this section associates either a float or a float[3]  
The same integer may appear multiple times.  
  
There's a portion of this part where the ints 0 thru 3 appear a lot.  
That reminds me of something I've seen in the .shier file.  
  
I believe that what I called "part 2" is actually multiple "parts". It's just that it's unclear where one of these "parts" starts and where it ends.  