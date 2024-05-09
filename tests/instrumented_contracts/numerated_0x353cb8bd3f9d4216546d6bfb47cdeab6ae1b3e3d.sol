1 pragma solidity ^0.4.19;
2 
3 contract StoreIPHash {
4   string constant _ipHash = "IP1.txt.zip 1bdf34b347d70f6aadc952a76532e077";
5   function  getIPHash() public returns(string) {
6     return _ipHash;
7   }
8 
9 }