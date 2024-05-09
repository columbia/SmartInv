1 pragma solidity ^0.4.16;
2 
3 interface Token {
4     function transfer(address receiver, uint amount) public;
5 }
6 
7 contract KaiserExTokenCrowdsale {
8     
9     Token public tokenReward;
10     address ICOowner = 0x60Bb29928F16D1295731A1B72516892D33b1e8df;
11 
12     uint256 public startDate;
13     uint256 public endPresaleDate;
14     uint256 public endDate;
15 
16     uint256 public presaleAmount;
17 
18     event FundTransfer(address backer, uint amount, bool isContribution);
19 
20     function KaiserExTokenCrowdsale() public {
21         startDate = 1513209600;  // 14/12/2017 GMT
22         endPresaleDate = startDate + 8 days;
23         endDate = endPresaleDate + 30 days;
24         tokenReward = Token(0xA9931dEf75784C50e27506d9acC4c58611bd5103);
25         presaleAmount = 12000000 * 1 ether;
26     }
27 
28     function () payable public {
29         require(msg.value > 0);
30         require(now > startDate);
31         require(now < endDate);
32         uint amount = msg.value * 1000;
33         if(now < endPresaleDate) {
34         	amount = msg.value * 1200;
35         	require(presaleAmount >= amount);
36         	presaleAmount -= amount;
37         }
38         require(amount >= 5 * 1 ether);
39         tokenReward.transfer(msg.sender, amount);
40         FundTransfer(msg.sender, amount, true);
41         ICOowner.transfer(msg.value);
42     }
43 }