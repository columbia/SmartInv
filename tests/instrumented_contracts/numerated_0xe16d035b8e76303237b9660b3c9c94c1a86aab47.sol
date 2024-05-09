1 pragma solidity ^0.4.24;
2 
3 
4 contract AddressRegistry {
5 
6     event AddressSet(string name, address addr);
7     mapping(bytes32 => address) registry;
8 
9     constructor() public {
10         registry[keccak256(abi.encodePacked("admin"))] = msg.sender;
11     }
12 
13     function getAddr(string name) public view returns(address) {
14         return registry[keccak256(abi.encodePacked(name))];
15     }
16 
17     function setAddr(string name, address addr) public {
18         require(
19             msg.sender == getAddr("admin") || 
20             msg.sender == getAddr("owner"),
21             "Permission Denied"
22         );
23         registry[keccak256(abi.encodePacked(name))] = addr;
24         emit AddressSet(name, addr);
25     }
26 
27 }