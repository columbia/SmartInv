1 pragma solidity ^0.4.13;
2 
3 contract BusinessCardAM {
4     
5     mapping (bytes32 => string) variables;
6     
7     function setVar(string key, string value) {
8         variables[sha3(key)] = value;
9     }
10     
11     function getVar(string key) constant returns(string) {
12         return variables[sha3(key)];
13     }
14 }