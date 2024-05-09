1 pragma solidity ^0.4.19;
2 
3 interface Token {
4     function transfer(address receiver, uint amount) public;
5 }
6 
7 contract CELLCrowdsale {
8     
9     Token public tokenReward;
10     address creator;
11     address owner = 0x81Ae4b8A213F3933B0bE3bF25d13A3646F293A64;
12 
13     uint256 public startDate;
14     uint256 public endDate;
15     uint256 public price;
16     uint256 public tokenSelled = 0;
17 
18     event FundTransfer(address backer, uint amount, bool isContribution);
19 
20     function CELLCrowdsale() public {
21         creator = msg.sender;
22         startDate = 1515974400;         // 15/01/2018
23         price = 500;
24         tokenReward = Token(0xC42de4250cA009C767818eC6f8fb1eacBa859f38);
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
61         require(tokenSelled < 100000001);
62         uint amount = msg.value / 10 finney;
63         require(amount > 5);
64         uint amount20; 
65         // Step 1 (15.01. - 12.02.) - 40% BONUS (1 ETH = 700 Tokens)
66         if(now > startDate && now < 1518480000) {
67             price = 700;
68             amount *= price * 100;
69             amount20 = amount / 20;
70             amount += amount20 * 8;
71         }
72         // Step 2 (12.02. - 19.02.) - 25% BONUS (1 ETH = 625 Tokens)
73         if(now > 1518480000 && now < 1519084800) {
74             price = 625;
75             amount *= price * 100;
76             amount += amount / 4;
77         }
78         // Step 3 (19.02. - 26.02.) - 15% BONUS (1 ETH = 575 Tokens)
79         if(now > 1519084800 && now < 1519689600) {
80             price = 575;
81             amount *= price * 100;
82             amount20 = amount / 20;
83             amount += amount20 * 3;
84         }
85         // Step 4 (26.02. - 05.03.) - 10% BONUS (1 ETH = 550 Tokens)
86         if(now > 1519689600 && now < 1520294400) {
87             price = 550;
88             amount *= price * 100;
89             amount += amount / 10;
90         }
91         // Step 5
92         if(now > 1520294400) {
93             price = 500;
94             amount *= price * 100;
95         }
96         
97         tokenSelled += amount;
98         tokenReward.transfer(msg.sender, amount);
99         FundTransfer(msg.sender, amount, true);
100         owner.transfer(msg.value);
101     }
102 }