1 pragma solidity ^0.4.16;
2  
3 contract CodexBeta {
4     struct MyCode {
5         string code;
6     }
7     event Record(string code);
8     function record(string code) public {
9         registry[msg.sender] = MyCode(code);
10     }
11     mapping (address => MyCode) public registry;
12 }