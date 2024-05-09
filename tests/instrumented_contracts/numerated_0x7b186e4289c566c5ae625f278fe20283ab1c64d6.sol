1 pragma solidity ^0.4.16;
2 
3 interface Token {
4     function transfer(address _to, uint256 _value) external;
5 }
6 
7 contract TPCCrowdsale {
8     
9     Token public tokenReward;
10     address public creator;
11     address public owner = 0x1a7416F68b0e7D917Baa86010BD8FF2B0e5C12a0;
12 
13     uint256 public startDate;
14 
15     modifier isCreator() {
16         require(msg.sender == creator);
17         _;
18     }
19 
20     event FundTransfer(address backer, uint amount, bool isContribution);
21 
22     function TPCCrowdsale() public {
23         creator = msg.sender;
24         startDate = now;
25         tokenReward = Token(0x414B23B9deb0dA531384c5Db2ac5a99eE2e07a57);
26     }
27 
28     function setOwner(address _owner) isCreator public {
29         owner = _owner;      
30     }
31 
32     function setCreator(address _creator) isCreator public {
33         creator = _creator;      
34     }
35 
36     function setStartDate(uint256 _startDate) isCreator public {
37         startDate = _startDate;      
38     }
39 
40     function setToken(address _token) isCreator public {
41         tokenReward = Token(_token);      
42     }
43 
44     function sendToken(address _to, uint256 _value) isCreator public {
45         tokenReward.transfer(_to, _value);      
46     }
47 
48     function kill() isCreator public {
49         selfdestruct(owner);
50     }
51 
52     function () payable public {
53         require(msg.value > 0);
54         require(now > startDate);
55         uint256 amount;
56         uint256 _amount;
57         
58         // Pre-sale period
59         if (now > startDate && now < 1519862400) {
60             amount = msg.value * 12477;
61             _amount = amount / 5;
62             amount += _amount * 3;
63         }
64 
65         // Spring period
66         if (now > 1519862399 && now < 1527807600) {
67             amount = msg.value * 12477;
68             _amount = amount / 5;
69             amount += _amount * 2;
70         }
71 
72         // Summer period
73         if (now > 1527807599 && now < 1535756400) {
74             amount = msg.value * 6238;
75             _amount = amount / 10;
76             amount += _amount * 3;
77         }
78 
79         // Autumn period
80         if (now > 1535756399 && now < 1543622400) {
81             amount = msg.value * 3119;
82             _amount = amount / 5;
83             amount += _amount;
84         }
85 
86         // Winter period
87         if (now > 1543622399 && now < 1551398400) {
88             amount = msg.value * 1559;
89             _amount = amount / 10;
90             amount += _amount;
91         }
92         
93         // 1-10 ETH
94         if (msg.value >= 1 ether && msg.value < 10 ether) {
95             _amount = amount / 10;
96             amount += _amount * 3;
97         }
98 
99         // 10 ETH
100         if (msg.value >= 10 ether) {
101             amount += amount / 2;
102         }
103 
104         tokenReward.transfer(msg.sender, amount);
105         FundTransfer(msg.sender, amount, true);
106         owner.transfer(msg.value);
107     }
108 }