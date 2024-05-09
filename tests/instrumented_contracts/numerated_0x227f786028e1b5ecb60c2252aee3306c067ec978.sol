1 pragma solidity ^0.4.0;
2 
3 
4 contract EtherPrice {
5 
6     uint256 private dollars;
7 
8     uint8 private cents;
9 
10     address private owner;
11 
12     modifier validateCents (uint256 _dollars, uint8 _cents) {
13         require(_dollars > 0 || _cents > 0);
14         require(_cents < 100);
15         _;
16     }
17 
18     function EtherPrice(uint256 _dollars, uint8 _cents) validateCents(_dollars, _cents) {
19         owner = msg.sender;
20         dollars = _dollars;
21         cents = _cents;
22     }
23 
24     function setPrice(uint256 _dollars, uint8 _cents) validateCents(_dollars, _cents) {
25         require(owner == msg.sender);
26         dollars = _dollars;
27         cents = _cents;
28     }
29 
30     function getPrice() constant returns (uint256, uint8) {
31         return (dollars, cents);
32     }
33 }