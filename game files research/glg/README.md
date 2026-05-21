# GLG
Although the glg format is similar to the rlg one, they have many differences.     
  

## RLG/GLG file structure  
###  Section structure
See [README.md](https://github.com/Rocci1212/strikers-re/blob/main/game%20files%20research/README.md)
* An 8-bytes-long Header
  * 0x0-0x1: Some flags
  * 0x2-0x3: Section identifier
  * 0x4-0x7: Section body size
* A Body, which could contain any kind of data. The format depends on the section type. See the .md files for information about each section.

### Section hierarchy
"section identifier" - "section"
* B000 - Root section, contains all the other sections and extends from the beginning to the end of the file
  * B001 - Unknown
  * B002 - Matrix Data
  * B003 - Model Data
  * B004 - Mesh Data
  * B005 - Vertex Attributes
  * B006 - Vertex Data
  * B007 - Index Data
  * B008 - Skeleton Data, it's a section container
    * B009 - Unknown
    * B00A - Bone Data
    * B00B - Bone Mesh Hashes (there are N of these, where N is the amount of meshes)
    * B00C - Unknown 