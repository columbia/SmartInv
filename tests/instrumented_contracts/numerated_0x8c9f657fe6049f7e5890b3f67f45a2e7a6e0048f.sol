1 pragma solidity ^0.4.16;
2 
3 contract TokenBurner {
4     address private _burner;
5 
6     function TokenBurner() public {
7         _burner = msg.sender;
8     }
9 
10     function () payable public {
11     }
12 
13     function BurnMe () public {
14         // Only let ourselves be able to burn
15         if (msg.sender == _burner) {
16             // Selfdestruct and send tokens to self, to burn them 
17             selfdestruct(address(this));
18         }
19         
20     }
21 }