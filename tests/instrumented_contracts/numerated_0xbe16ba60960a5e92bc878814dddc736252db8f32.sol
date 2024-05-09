1 pragma solidity ^0.4.13;
2 
3 contract DappTutorial {
4   uint storedData;
5 
6   function set(uint x) {
7     storedData = x;
8   }
9 
10   function get() constant returns (uint) {
11     return storedData * 2;
12   }
13 }