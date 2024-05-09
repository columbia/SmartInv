1 pragma solidity ^0.4.23;
2 
3 contract Bitmonds {
4     struct BitmondsOwner {
5         string bitmond;
6         string owner;
7     }
8 
9     BitmondsOwner[] internal registry;
10 
11     function take(string Bitmond, string Owner) public {
12         registry.push(BitmondsOwner(Bitmond, Owner));
13     }
14 
15     function lookup(string Bitmond) public view returns (string Owner) {
16         for (uint i = 0; i < registry.length; i++) {
17             if (compareStrings(Bitmond, registry[i].bitmond)) {
18                 Owner = registry[i].owner;
19             }
20         }
21     }
22 
23     function compareStrings (string a, string b) internal pure returns (bool) {
24         return (keccak256(a) == keccak256(b));
25     }
26 }