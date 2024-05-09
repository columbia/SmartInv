1 pragma solidity ^0.4.25;
2 contract etherSinkhole{
3     constructor() public{}
4     function destroy() public{
5         selfdestruct(msg.sender);
6     }
7 }