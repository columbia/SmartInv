1 pragma solidity ^0.4.25;  
2 
3 contract GetsBurned {
4 
5     function () public payable {
6     }
7 
8     function BurnMe () {
9         selfdestruct(address(this));
10     }
11 }