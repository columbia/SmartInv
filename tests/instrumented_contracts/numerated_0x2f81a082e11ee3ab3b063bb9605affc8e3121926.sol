1 pragma solidity 0.4.4;
2 
3 contract AddressNames{
4 
5 	mapping(address => string) addressNames;
6 	address[] namedAddresses;
7 
8 	function setName(string name){
9 		_setNameToAddress(msg.sender,name);
10 	}
11 
12 	function hasName(address who) constant returns (bool hasAName){
13 		hasAName = _hasName(who);
14 	}
15 
16 	function getName(address who) constant returns (string name){
17 		name = addressNames[who];
18 	}
19 	
20 	function getNamedAddresses() constant returns (address[] addresses){
21 		addresses = namedAddresses;
22 	}
23 
24 	function _setNameToAddress(address who, string name) internal returns (bool valid){
25 		if (bytes(name).length < 3){
26 		valid = false;
27 		}
28 
29 		if (!_hasName(who)){
30 			namedAddresses.push(who);
31 		}
32 		addressNames[msg.sender] = name;
33 		
34 		valid = true;
35 	}
36 
37 	function _hasName(address who) internal returns (bool hasAName){
38 		hasAName = bytes(addressNames[who]).length != 0;
39 	}
40 
41 }