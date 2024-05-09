1 // File: contracts/FlightDelayAddressResolver.sol
2 
3 /*
4   Copyright (c) 2015-2016 Oraclize SRL
5   Copyright (c) 2016 Oraclize LTD
6 */
7 
8 pragma solidity ^0.4.11;
9 
10 
11 contract FlightDelayAddressResolver {
12 
13     address public addr;
14 
15     address owner;
16 
17     function FlightDelayAddressResolver() public {
18         owner = msg.sender;
19     }
20 
21     function changeOwner(address _owner) public {
22         require(msg.sender == owner);
23         owner = _owner;
24     }
25 
26     function getAddress() public constant returns (address _addr) {
27         return addr;
28     }
29 
30     function setAddress(address _addr) public {
31         require(msg.sender == owner);
32         addr = _addr;
33     }
34 }