1 pragma solidity ^0.4.24;
2 
3 contract TandaPayDemo {
4     
5     uint public tandaBalance;
6     address secretary;
7     mapping(address=>bool) public policyholders;
8     
9     constructor() {
10         secretary =  msg.sender;
11     }
12     
13     function() payable { payPremium(); }
14     
15     function payPremium()
16         public payable returns (bool)
17     {
18         require(msg.value >= .0001 ether);
19         if(!policyholders[msg.sender]){
20             policyholders[msg.sender] = true;
21         }
22         tandaBalance += msg.value;
23         return true;
24     }
25     
26     function sendClaim(address claimant, uint claimAmount) {
27         require(msg.sender == secretary);
28         require(claimAmount <= tandaBalance);
29         require(policyholders[claimant]);
30         claimant.transfer(claimAmount);
31     }
32     
33 }