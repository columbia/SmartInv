1 pragma solidity ^0.4.18;
2 
3 
4 contract Griddeth {
5     
6   string public constant NAME = "Griddeth";
7 
8   uint8[18000] grid8; // 180x100 display
9   
10   // colors = ["#FFFFFF","#E4E4E4","#888888","#222222",
11   // "#FFA7D1","#E50000","#E59500","#A06A42","#E5D900",
12   // "#94E044","#02BE01","#00E5F0","#0083C7","#0000EA",
13   // "#E04AFF","#820080"]
14 
15   function getGrid8() public view returns (uint8[18000]) {
16       return grid8;
17   }
18   
19   // No assertion on color < 16 since the frontend will
20   // default to white otherwise.
21   function setColor8(uint256 i, uint8 color) public {
22       grid8[i] = color;
23   }
24   
25   function Griddeth() public {
26   }
27 
28 }