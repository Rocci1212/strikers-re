# Section B002 - RLG Matrix data

## Section header
| **offset** | **attribute**          | **value**                   |
|------------|------------------------|-----------------------------|
| 0x0-0x1    | flags                  | usually 0x0001              |
| 0x2-0x3    | identifier             | 0xB002                      |
| 0x4-0x7    | body size              | 0x40                        |


## Section body
This is a 4x4 transform matrix made of 16 floats.
I don't really know what this is used for.
Mario has a Y-axis translation matrix. Y is the up axis in these models.