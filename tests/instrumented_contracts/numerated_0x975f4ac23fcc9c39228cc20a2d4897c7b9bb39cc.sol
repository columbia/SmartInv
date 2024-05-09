1 pragma solidity ^0.5.0;
2 contract Vote {
3     event LogVote(address indexed addr);
4 
5     function() external {
6         emit LogVote(msg.sender);
7     }
8 }