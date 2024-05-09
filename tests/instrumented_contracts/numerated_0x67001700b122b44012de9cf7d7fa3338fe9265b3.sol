1 pragma solidity ^0.4.8;
2 contract Counter {
3   uint i=1;
4   function inc() {
5     i=i+1;
6   }
7   function get() constant returns (uint) {
8     return i;
9   }
10 }