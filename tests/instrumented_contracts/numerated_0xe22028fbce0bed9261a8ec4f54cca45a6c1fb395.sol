1 pragma solidity ^0.4.16;
2 
3 interface Token {
4     function transfer(address receiver, uint amount) public;
5 }
6 
7 contract BmarktCrowdsale {
8     
9     Token public tokenReward;
10     address owner = 0xa94c531D288608f61F906B1a35468CE54C7656b7;
11 
12     uint256 public startDate;
13     uint256 public endDate;
14 
15     event FundTransfer(address backer, uint amount, bool isContribution);
16 
17     function BmarktCrowdsale() public {
18         startDate = 1515970800;
19         endDate = 1518735600;
20         tokenReward = Token(0x98E2750d38b1D24Ba6C503E9853DB69e7Cf78fe4);
21     }
22 
23     function () payable public {
24         require(msg.value > 0);
25         require(now > startDate);
26         require(now < endDate);
27         uint amount = msg.value * 20000;
28         tokenReward.transfer(msg.sender, amount);
29         FundTransfer(msg.sender, amount, true);
30         owner.transfer(msg.value);
31     }
32 }