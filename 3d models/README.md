Notes about RLG (and GLG) 3D model formats  

# Useful links  

##KillzXGaming's research on GLG/RLG files  
https://github.com/KillzXGaming/NLG_Research/wiki/Mario-Strikers-GLG-and-RLG  
Not perfect, there are a few little mistakes here and there and some explanations aren't exhaustive, but I'm glad it exists.  
My tool or this folder of our repo wouldn't exist if it wasn't for this research.  
  
##Switch toolbox source code  
https://github.com/KillzXGaming/Switch-Toolbox/blob/master/File_Format_Library/FileFormats/NLG/MarioStrikers/StrikersRLG.cs  
This C# tool can decode .rlg and .glg files to .dae, but cannot generate a new .rlg or .glg file.  
Most of the mistakes of the first link are actually fixed in this tool's code, but it's harder to read and it barely has any comment.  
  
##Rlg vertex tool  
https://github.com/Feder2228/rlg-vertex-tool   
My own tool for decoding/encoding rlg files, written in python.  
Currently VERY beta and will be like that for a while. It doesn't support .glg at all (for now). Switch-toolbox is far ahead of this tool.  
BUT this tool does something switch-toolbox does not do: generating .rlg file.  
It does NOT generate it from scratch, but it takes the original .rlg file, plus a .dae file, takes the .dae vertices and writes them to the .rlg file.



