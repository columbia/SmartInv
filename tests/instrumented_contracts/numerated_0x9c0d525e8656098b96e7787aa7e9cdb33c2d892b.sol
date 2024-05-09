1 pragma solidity ^0.4.16;
2 
3 interface Token {
4     function transfer(address receiver, uint amount) public;
5 }
6 
7 contract ASCCrowdsale {
8     
9     Token public tokenReward;
10     address creator;
11     address owner = 0xb99776950E24a1D580d8c1622ab6C92002aEc169;
12 
13     uint256 public startDate;
14     uint256 public endDate;
15     uint256 public price;
16 
17     event FundTransfer(address backer, uint amount, bool isContribution);
18 
19     function ASCCrowdsale() public {
20         creator = msg.sender;
21         startDate = 1452038400;     // 06/01/2018
22         endDate = 1521586800;       // 21/03/2018
23         price = 72000;
24         tokenReward = Token(0xE5b7301D818299487b744900923A40cF7d1f0242);
25     }
26 
27     function setOwner(address _owner) public {
28         require(msg.sender == creator);
29         owner = _owner;      
30     }
31 
32     function setCreator(address _creator) public {
33         require(msg.sender == creator);
34         creator = _creator;      
35     }    
36 
37     function setStartDate(uint256 _startDate) public {
38         require(msg.sender == creator);
39         startDate = _startDate;      
40     }
41 
42     function setEndDate(uint256 _endDate) public {
43         require(msg.sender == creator);
44         endDate = _endDate;      
45     }
46 
47     function setPrice(uint256 _price) public {
48         require(msg.sender == creator);
49         price = _price;      
50     }
51 
52     function sendToken(address receiver, uint amount) public {
53         require(msg.sender == creator);
54         tokenReward.transfer(receiver, amount);
55         FundTransfer(receiver, amount, true);    
56     }
57 
58     function () payable public {
59         require(msg.value > 0);
60         require(now > startDate);
61         require(now < endDate);
62         uint amount = msg.value / 1 ether;
63 	    amount *= price * 100;
64 	    uint amount10 = amount / 10;
65 
66         // period 1 : 60%
67         if(now > startDate && now < 1516230000) {
68             amount += amount10 * 6;
69         }
70 
71         // Pperiod 2 : 40%
72         if(now > 1516230000 && now < 1517439600) {
73             amount += amount10 * 4;
74         }
75 
76         // period 3 : 20%
77         if(now > 1517439600 && now < 1518649200) {
78             amount += amount10 * 2;
79         }
80 
81         // period 4 : 10%
82         if(now > 1518649200 && now < 1519858800) {
83             amount += amount10;
84         }
85 
86         tokenReward.transfer(msg.sender, amount);
87         FundTransfer(msg.sender, amount, true);
88         owner.transfer(msg.value);
89     }
90 }