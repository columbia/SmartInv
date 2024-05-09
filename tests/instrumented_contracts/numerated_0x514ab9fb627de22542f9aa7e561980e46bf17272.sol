1 pragma solidity ^0.4.8;
2 
3 contract wallet {
4     address owner;
5     function wallet() {
6         owner = msg.sender;
7     }
8     function transfer(address target) payable {
9         target.send(msg.value);
10     }
11     function kill() {
12         if (msg.sender == owner) {
13             suicide(owner);
14         } else {
15             throw;
16         }
17     }
18 }