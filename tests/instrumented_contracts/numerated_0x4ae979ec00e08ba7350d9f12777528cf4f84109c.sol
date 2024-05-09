1 pragma solidity ^0.4.19;
2 
3 interface CornFarm
4 {
5     function buyObject(address _beneficiary) public payable;
6 }
7 
8 interface Corn
9 {
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12 }
13 
14 contract Cornholio
15 {
16     address public farmer = 0x231F702070aACdbde867B323996A96Fed8aDCA10;
17     
18     function sowCorn(address soil, uint8 seeds) external
19     {
20         for(uint8 i = 0; i < seeds; ++i)
21         {
22             CornFarm(soil).buyObject(this);
23         }
24     }
25     
26     function reap(address corn) external
27     {
28         Corn(corn).transfer(farmer, Corn(corn).balanceOf(this));
29     }
30 }