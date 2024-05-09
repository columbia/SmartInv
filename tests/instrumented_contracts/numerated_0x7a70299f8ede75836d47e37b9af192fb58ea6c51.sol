1 pragma solidity ^0.4.0;
2 contract GetsBurned {
3     function () payable public {
4     }
5 
6     function BurnMe() public {
7         // Selfdestruct and send eth to self, 
8         selfdestruct(address(this));
9     }
10 }