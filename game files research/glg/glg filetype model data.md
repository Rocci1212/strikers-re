# Section B003 - GLG Model data

## Section header
| **offset** | **attribute**          | **value**                   |
|------------|------------------------|-----------------------------|
| 0x0-0x1    | flags                  | usually 0x0001              |
| 0x2-0x3    | identifier             | 0xB003                      |
| 0x4-0x7    | body size              | model_count*0x10            |


## Section body
Model count = body size / 16  
This section's body is made up of size/16 records  
This is how each record is structured:
| **offset**   | **attribute**          | **type**  |
|--------------|------------------------|-----------|
| 0x0-0x3      | mesh_count             | UINT32    |
| 0x4-0x7      | model_hash_id          | UINT32    |
| 0x8-0xF      | unknown                | -         |