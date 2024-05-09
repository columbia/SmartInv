1 pragma solidity ^0.4.0;
2 contract Test {
3 
4     function send(address to) public{
5         if (to.call("0xabcdef")) {
6             return;
7         } else {
8             revert();
9         }
10     }
11 }