1 pragma solidity ^0.4.15;
2 
3 contract Token {
4     function transfer(address _to, uint _value) returns (bool success);
5 }
6 
7 contract Safe {
8     address public owner;
9     uint256 public lock;
10 
11     function Safe() {
12         owner = msg.sender;
13     }
14     
15     function transfer(address to) returns (bool) {
16         require(msg.sender == owner);
17         require(to != address(0));
18         owner = to;
19         return true;
20     }
21 
22     function lock(uint256 timestamp) returns (bool) {
23         require(msg.sender == owner);
24         require(timestamp > lock);
25         require(timestamp > block.timestamp);
26         lock = timestamp;
27         return true;
28     }
29 
30     function withdrawal(Token token, address to, uint value) returns (bool) {
31         require(msg.sender == owner);
32         require(block.timestamp >= lock);
33         require(to != address(0));
34         return token.transfer(to, value);
35     }
36 }