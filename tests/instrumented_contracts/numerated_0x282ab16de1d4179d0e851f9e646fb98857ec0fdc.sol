1 pragma solidity ^0.4.19;
2 
3 contract Contrat {
4 
5     address owner;
6 
7     event Sent(string hash);
8 
9     constructor() public {
10         owner = msg.sender;
11     }
12 
13     modifier canAddHash() {
14         bool isOwner = false;
15 
16         if (msg.sender == owner)
17             isOwner = true;
18 
19         require(isOwner);
20         _;
21     }
22 
23     function addHash(string hashToAdd) canAddHash public {
24         emit Sent(hashToAdd);
25     }
26 }