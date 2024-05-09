1 pragma solidity ^0.4.0;
2 
3 contract Resolver {
4     function supportsInterface(bytes4 interfaceID) constant returns (bool);
5     function dnsrr(bytes32 node) constant returns (bytes data);
6 }
7 
8 contract DNSResolver is Resolver {
9     address public owner;
10     mapping(bytes32=>bytes) zones;
11     
12     function OwnedResolver() {
13         owner = msg.sender;
14     }
15     
16     modifier owner_only {
17         if(msg.sender != owner) throw;
18         _;
19     }
20     
21     function supportsInterface(bytes4 interfaceID) constant returns (bool) {
22         return interfaceID == 0x126a710e;
23     }
24     
25     function dnsrr(bytes32 node) constant returns (bytes data) {
26         return zones[node];
27     }
28     
29     function setDnsrr(bytes32 node, bytes data) owner_only {
30         zones[node] = data;
31     }
32 }