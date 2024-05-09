1 pragma solidity ^0.4.18;
2 
3 contract corrently_iot {
4     
5 	  mapping (address => uint256) public value;
6       event Value(address indexed thing, uint256 value);
7       
8       function setValue(uint256 _value) public {
9           value[msg.sender] = _value;
10           emit Value(msg.sender,_value);
11       }
12 }