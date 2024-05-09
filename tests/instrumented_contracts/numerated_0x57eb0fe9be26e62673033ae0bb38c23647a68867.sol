1 pragma solidity ^0.4.24;
2 
3 contract SaiVox {
4     function par() public returns (uint);
5     function way() public returns (uint);
6 }
7 
8 contract GetSaiVoxValues {
9     SaiVox public saiVox = SaiVox(0x9B0F70Df76165442ca6092939132bBAEA77f2d7A);
10 
11     uint public par;
12     uint public way;
13 
14     function update() public {
15         par = saiVox.par();
16         way = saiVox.way();
17     }
18 }