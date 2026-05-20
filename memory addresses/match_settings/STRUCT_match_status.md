# Match status struct
This struct stores information such as: score and items of both teams.  
It's pointer is located at 80100FDC


## Offsets
| **offset**          | **data type** | **description**                                                                                                                          | 
|---------------------|---------------|------------------------------------------------------------------------------------------------------------------------------------------|
| 0x4                 | INT32         | home score                                                                                                                               |
| 0x8C                | INT32         | home item 1 ID                                                                                                                           |
| 0x90                | INT32         | home item 1 quantity                                                                                                                     |
| 0x98                | INT32         | home item 2 ID                                                                                                                           |
| 0x9C                | INT32         | home item 2 quantity                                                                                                                     |
| 0xB6C               | INT32         | away score                                                                                                                               |
| 0xBF4               | INT32         | away item 1 ID                                                                                                                           |
| 0xBF8               | INT32         | away item 1 quantity                                                                                                                     |
| 0xC00               | INT32         | away item 2 ID                                                                                                                           |
| 0xC04               | INT32         | away item 2 quantity                                                                                                                     |
| 0x1828              | UINT32        | displayed home score                                                                                                                     |
| 0x182C              | UINT32        | displayed home score                                                                                                                     |