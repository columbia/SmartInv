1 pragma solidity ^0.4.13;
2 
3 // Record the thumbs up for EtherShare
4 contract EtherShareLike {
5 
6     address public link = 0xc86bdf9661c62646194ef29b1b8f5fe226e8c97e;  
7 
8     mapping(uint => mapping(uint => uint)) public allLike;
9 
10     function like(uint ShareID, uint ReplyID) public {
11         allLike[ShareID][ReplyID]++;
12     }
13 }