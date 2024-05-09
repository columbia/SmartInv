1 pragma solidity ^0.4.0;
2 
3 contract EtherVoxelSpace {
4     
5     struct Voxel {
6         uint8 material;
7         address owner;
8     }
9     
10     event VoxelPlaced(address owner, uint8 x, uint8 y, uint8 z, uint8 material);
11     event VoxelRepainted(uint8 x, uint8 y, uint8 z, uint8 newMaterial);
12     event VoxelDestroyed(uint8 x, uint8 y, uint8 z);
13     event VoxelTransferred(address to, uint8 x, uint8 y, uint8 z);
14     
15     address creator;
16     uint constant PRICE = 1000000000000;
17     Voxel[256][256][256] public world;
18     
19     function EtherVoxelSpace() public {
20         creator = msg.sender;
21     }
22     
23     function isAvailable(uint8 x, uint8 y, uint8 z) private view returns (bool) {
24         if (x < 256 && y < 256 && z < 256 && world[x][y][z].owner == address(0)) {
25             return true;
26         } 
27         return false;
28     }
29     
30     function placeVoxel(uint8 x, uint8 y, uint8 z, uint8 material) payable public {
31         require(isAvailable(x, y, z) && msg.value >= PRICE);
32         world[x][y][z] = Voxel(material, msg.sender);
33         VoxelPlaced(msg.sender, x, y, z, material);
34     }
35     
36     function repaintVoxel(uint8 x, uint8 y, uint8 z, uint8 newMaterial) payable public {
37         require(world[x][y][z].owner == msg.sender && msg.value >= PRICE);
38         world[x][y][z].material = newMaterial;
39         VoxelRepainted(x, y, z, newMaterial);
40     }
41     
42     function destroyVoxel(uint8 x, uint8 y, uint8 z) payable public {
43         require(world[x][y][z].owner == msg.sender && msg.value >= PRICE);
44         world[x][y][z].owner = address(0);
45         VoxelDestroyed(x, y, z);
46     } 
47     
48     function transferVoxel(address to, uint8 x, uint8 y, uint8 z) payable public {
49         require(world[x][y][z].owner == msg.sender && msg.value >= PRICE);
50         world[x][y][z].owner = to;
51         VoxelTransferred(to, x, y, z);
52     }
53     
54     function withdraw() public {
55         require(msg.sender == creator);
56         creator.transfer(this.balance);
57     }
58 }