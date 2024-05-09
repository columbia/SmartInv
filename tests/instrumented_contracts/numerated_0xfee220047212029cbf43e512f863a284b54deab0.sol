1 pragma solidity ^0.4.11;
2 
3 contract greeter {
4 
5     address owner;
6     string message;
7 
8     function greeter(string _message) public {
9         owner = msg.sender;
10         message = _message;
11     }
12 
13     function say() constant returns (string) {
14         return message;
15     }
16 
17     function die() {
18         if (msg.sender == owner) {
19             selfdestruct(owner);
20         }
21     }
22 }