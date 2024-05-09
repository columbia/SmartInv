1 pragma solidity ^0.4.0;
2 
3 contract PotatoStorage {
4     string storedPotato;
5 
6     function setPotato(string x) public {
7         storedPotato = x;
8     }
9 
10     function getPotato() public view returns (string) {
11         return storedPotato;
12     }
13 }