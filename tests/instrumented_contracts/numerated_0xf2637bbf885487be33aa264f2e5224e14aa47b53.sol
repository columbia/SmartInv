1 pragma solidity 0.4.21;
2 
3 contract pixelgrid {
4     uint8[1000000] public pixels;
5     address public manager;
6     address public owner = 0x668d7b1a47b3a981CbdE581bc973B047e1989390;
7     event Updated();
8     function pixelgrid() public {
9         manager = msg.sender;
10     }
11 
12     function setColors(uint32[] pixelIndex, uint8[] color) public payable  {
13       require(pixelIndex.length < 256);
14       require(msg.value >= pixelIndex.length * 0.0001 ether || msg.sender == manager);
15       require(color.length == pixelIndex.length);
16     for (uint8 i=0; i<pixelIndex.length; i++) {
17     pixels[pixelIndex[i]] = color[i];
18     }
19     emit Updated();
20 
21     }
22 
23 
24     function getColors(uint32 start) public view returns (uint8[50000] ) {
25       require(start < 1000000);
26         uint8[50000] memory partialPixels;
27            for (uint32 i=0; i<50000; i++) {
28                partialPixels[i]=pixels[start+i];
29            }
30 
31       return partialPixels;
32     }
33 
34     function collectFunds() public {
35          require(msg.sender == manager || msg.sender == owner);
36          address contractAddress = this;
37          owner.transfer(contractAddress .balance);
38     }
39 
40     function () public payable {
41       // dont receive ether via fallback
42   }
43 }