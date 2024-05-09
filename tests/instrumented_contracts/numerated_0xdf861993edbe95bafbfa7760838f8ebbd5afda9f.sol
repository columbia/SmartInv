1 pragma solidity ^0.4.0;
2 contract Nobody {
3     function die() public {
4         selfdestruct(msg.sender);
5     }
6 }