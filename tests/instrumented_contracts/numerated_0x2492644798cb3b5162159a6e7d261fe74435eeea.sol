1 pragma solidity 0.4.24;
2 
3 contract ProofOfLove {
4     
5     uint public count = 0;
6 
7     event Love(string name1, string name2);
8 
9     constructor() public { }
10 
11     function prove(string name1, string name2) external {
12         count += 1;
13         emit Love(name1, name2);
14     }
15 
16 }