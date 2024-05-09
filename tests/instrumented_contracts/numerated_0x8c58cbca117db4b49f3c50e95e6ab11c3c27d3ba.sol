1 pragma solidity ^0.4.16;
2 
3 interface Token {
4     function transfer(address receiver, uint amount) public;
5 }
6 
7 contract RETHCrowdsale {
8     
9     Token public tokenReward;
10     address owner = 0x269b07eF928110683123a9CDb99156D58B5bb737;
11     address creator;
12 
13     uint256 public startDate;
14     uint256 public endDate;
15 
16     event FundTransfer(address backer, uint amount, bool isContribution);
17 
18     function RETHCrowdsale() public {
19         creator = msg.sender;
20         startDate = 1513382400;
21         endDate = 1516060800;
22         tokenReward = Token(0x993551184c994737dAda24D6a0c6b54EE0196971);
23     }
24 
25     function newStartDate(uint256 _startDate) public {
26         require(msg.sender == creator);
27         startDate = _startDate;
28     }
29 
30     function newEndDate(uint256 _endDate) public {
31         require(msg.sender == creator);
32         endDate = _endDate;
33     }
34 
35     function () payable public {
36         require(msg.value > 0);
37         require(now > startDate);
38         require(now < endDate);
39         uint amount = msg.value * 100;
40         tokenReward.transfer(msg.sender, amount);
41         FundTransfer(msg.sender, amount, true);
42         owner.transfer(msg.value);
43     }
44 }