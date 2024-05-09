1 pragma solidity ^0.4.0;
2 contract whoSays {
3 
4     string public name = "whoSays";
5 
6     mapping(address => bytes) public data;
7 
8     event Said(address indexed person, bytes message);
9 
10     function saySomething(bytes _data) public {
11         data[msg.sender] = _data;
12         Said(msg.sender, _data);
13     }
14 
15 }