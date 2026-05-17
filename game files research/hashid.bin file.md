# hashid.bin
This game's file often use 4-byte-long hashes to reference assets.  
These hashes are what we call **hash ID**s.  
If you want to know what an hash ID is referencing, the hashid.bin file can help you.

## How to find a hashid name inside hashid.bin
1. Look for the hash ID in the file 
2. Read the 4-byte integer that comes after the hashid
3. Go to 0x1C8F4 + the number you found and you'll find the name

So let's hypotetically say you found this sequence of bytes: 66 99 66 99 00 00 12 34
where 0x66996699 is your hashid.
0x1234 is the offset, so you'll go to 0x1C8F4 + 0x1234 = 0x1DB28
There you will find a string with the name associated to that hash id