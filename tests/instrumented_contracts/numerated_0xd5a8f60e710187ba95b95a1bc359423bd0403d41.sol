1 pragma solidity ^0.4.23;
2 
3 contract StoreValue {
4   address public owner;
5   string public storedValue;
6 
7   constructor() public {
8     owner = msg.sender;
9   }
10 
11   modifier restricted() {
12     if (msg.sender == owner) _;
13   }
14 
15   function setValue(string completed) public restricted {
16     storedValue = completed;
17   }
18 
19   function getValue() public view returns (string) {
20     return storedValue;
21   }
22 }