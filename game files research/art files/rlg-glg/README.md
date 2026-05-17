# RLG and GLG
RLG are the 3d model files MSC uses, while GLG are the SMS equivalent.  
They have similar structure, with a few differences.  
  

## RLG/GLG file structure  
###  Section structure
See [README.md](https://github.com/Rocci1212/strikers-re/blob/main/game%20files%20research/README.md)
* An 8-bytes-long Header
* * 0x0-0x1: Some flags
* * 0x2-0x3: Section identifier
* * 0x4-0x7: Section body size
* A Body, which could contain any kind of data. The format depends on the section type. See the txt files for information about each section.

### Section hierarchy
"section identifier" - "section"
* B000 - Main section container, contains all the other sections and extends from the beginning to the end of the file
  * B016 - Material data
  * B007 - Index Data
  * B006 - Vertex Data
  * B005 - Vertex Attributes
  * B004 - Mesh Data
  * B003 - Model Data
  * B002 - Matrix Data
  * B008 - Skeleton Data, it's a section container
    * B00B - Bone Mesh Hashes (there are N of these, where N is the amount of meshes)
    * B00A - Bone Data
    * B00C - Unknown 


## External files  
RLG/GLG files don't contain all the data in themselves.  
Some data is stored in external files, such as:  
* [rlt](https://github.com/Rocci1212/strikers-re/blob/main/game%20files%20research/textures/rlt%20filetype.txt)/[glt](https://github.com/Rocci1212/strikers-re/blob/main/game%20files%20research/textures/glt%20filetype.txt) files for [textures](https://github.com/Rocci1212/strikers-re/tree/main/game%20files%20research/textures)
* [shier](https://github.com/Rocci1212/strikers-re/blob/main/game%20files%20research/3d%20models/shier%20filetype.txt) files for bones
* maybe more? I'm not 100% sure this is all
These files are linked one another with hash ids.  
See [hashid.bin](https://github.com/Rocci1212/strikers-re/blob/main/game%20files%20research/hashid.bin%20file.md) to know more about hash IDs
  
  
# Useful resources  
  
## KillzXGaming's research on GLG/RLG files  
https://github.com/KillzXGaming/NLG_Research/wiki/Mario-Strikers-GLG-and-RLG  
This person (or these people) did a great job, afaik they're the first to try REing these filetypes.  
My tool or this folder of our repo wouldn't exist if it wasn't for this research.  
That documentation is not perfect, there are a few little mistakes here and there and some explanations aren't really exhaustive. Most of the mistakes were fixed in the switch-toolbox source code, but for some reason the NLG_research page was never updated since. Either way, I'm glad it exists.  
  
## Switch toolbox source code  
https://github.com/KillzXGaming/Switch-Toolbox/blob/master/File_Format_Library/FileFormats/NLG/MarioStrikers/StrikersRLG.cs  
This C# tool can decode .rlg and .glg files to .dae, but cannot generate a new .rlg or .glg file.  
Most of the mistakes of the first link are actually fixed in this tool's code, but it's harder to read and it barely has any comment.  
  
## RLG vertex tool  
https://github.com/Feder2228/rlg-vertex-tool   
My own tool for decoding/encoding rlg files, written in python.  
Currently VERY beta and will be like that for a while.  
It's the only tool that can encode rlg files.




