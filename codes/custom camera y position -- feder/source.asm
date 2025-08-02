#To be inserted at 800f4e78
lis r12, 0x8000
ori r12, r12, 0x3fc

lfs f1, 0 (r12)
stfs f1, 0x0058 (r31) # default instruction