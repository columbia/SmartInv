1 /*
2   Copyright (c) 2015-2016 Oraclize SRL
3   Copyright (c) 2016 Oraclize LTD
4 */
5 
6 pragma solidity ^0.4.11;
7 
8 
9 contract FlightDelayAddressResolver {
10 
11     address public addr;
12 
13     address owner;
14 
15     function FlightDelayAddressResolver() {
16         owner = msg.sender;
17     }
18 
19     function changeOwner(address _owner) {
20         require(msg.sender == owner);
21         owner = _owner;
22     }
23 
24     function getAddress() constant returns (address _addr) {
25         return addr;
26     }
27 
28     function setAddress(address _addr) {
29         require(msg.sender == owner);
30         addr = _addr;
31     }
32 }