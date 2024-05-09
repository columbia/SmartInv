1 pragma solidity ^0.4.0;
2 
3 contract CarelessWhisper {
4     address owner;
5     event Greeting(bytes data);
6     
7     constructor() public {
8         owner = msg.sender;
9     }
10 
11     function greeting(bytes data) public {
12     }
13     
14     function kill() public {
15         require (msg.sender == owner);
16         selfdestruct(msg.sender);
17     }
18 }