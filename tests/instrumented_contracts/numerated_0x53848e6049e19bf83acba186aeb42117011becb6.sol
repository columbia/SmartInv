1 pragma solidity ^0.4.15;
2 
3 contract AffiliateNetwork {
4     uint public idx = 0;
5     mapping (uint => address) public affiliateAddresses;
6     mapping (address => uint) public affiliateCodes;
7 
8     function () payable {
9         if (msg.value > 0) {
10             msg.sender.transfer(msg.value);
11         }
12 
13         addAffiliate();
14     }
15 
16     function addAffiliate() {
17         if (affiliateCodes[msg.sender] != 0) { return; }
18 
19         idx += 1;   // first assigned code will be 1
20         affiliateAddresses[idx] = msg.sender;
21         affiliateCodes[msg.sender] = idx;
22     }
23 }