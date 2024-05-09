1 pragma solidity 0.4.4;
2 
3 contract AddressNames{
4 
5 	mapping(address => string) addressNames;
6 
7 	function setName(string name){
8 		if(bytes(name).length >= 3){
9 			addressNames[msg.sender] = name;
10 		}
11 	}
12 
13 	function hasName(address who) constant returns (bool hasAName){
14 		hasAName = bytes(addressNames[who]).length != 0;
15 	}
16 
17 	function getName(address who) constant returns (string name){
18 		name = addressNames[who];
19 	}
20 }