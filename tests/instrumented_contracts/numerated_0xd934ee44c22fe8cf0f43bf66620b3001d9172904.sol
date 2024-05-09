1 pragma solidity ^0.4.0;
2 
3 contract ContractPlay {
4     address owner;
5     uint16 numCalled;
6     
7     modifier onlyOwner {
8         if (msg.sender != owner) {
9             throw;
10         }
11         _;
12     }
13     
14     function ContractPlay() {
15         owner = msg.sender;
16     }
17     
18     function remove() onlyOwner {
19         selfdestruct(owner);
20     }
21     
22     function addFunds() payable {
23         numCalled++;
24     }
25     
26     function getNumCalled() returns (uint16) {
27         return numCalled;
28     }
29     
30     function() {
31         throw;
32     }
33 }