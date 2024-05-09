1 pragma solidity ^0.4.11;
2 
3 contract OriginalMyDocAuthenticity {
4     
5   mapping (string => uint) private authenticity;
6 
7   function storeAuthenticity(string sha256) {
8     if (checkAuthenticity(sha256) == 0) {
9         authenticity[sha256] = now;
10     }   
11   }
12 
13   function checkAuthenticity(string sha256) constant returns (uint) {
14     return authenticity[sha256];
15   }
16 }